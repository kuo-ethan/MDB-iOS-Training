//
//  Authentication.swift
//  MDB Social
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Authentication {
    
    static let shared = Authentication()
    
    let auth = Auth.auth()
    
    enum AuthenticationError: Error {
        // For sign in
        case wrongPassword
        case userNotFound
        case invalidEmail
        case internalError
        case errorFetchingUserDoc
        case errorDecodingUserDoc
        case unspecified
        // For sign up
        case emailAlreadyInUse
        case weakPassword
        case passwordConfirmationFailed
        case missingInputField
    }
    
    let db = Firestore.firestore()
    
    var currentUser: User?
    
    // A reference to a listener attached to some document.
    private var userListener: ListenerRegistration?
    
    init() {
        guard let user = auth.currentUser else { return }
        
        linkUser(withuid: user.uid, completion: nil)
    }
    
    func signIn(withEmail email: String, password: String,
                completion: ((Result<User, AuthenticationError>)->Void)?) {
        
        // MARK: potential reference cycle here because ...
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .wrongPassword:
                    completion?(.failure(.wrongPassword))
                case .userNotFound:
                    completion?(.failure(.userNotFound))
                case .invalidEmail:
                    completion?(.failure(.invalidEmail))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            // Sign in successful, link the user to the current execution.
            self?.linkUser(withuid: authResult.user.uid, completion: completion)
        }
    }
    
    /* TODO: Firebase sign up handler, add user to firestore */
    func signUp(withEmail email: String, password: String, fullName: String, userName: String, completion: ((Result<User, AuthenticationError>)->Void)?) {
        // Register a user using FirebaseAuth (not in database yet)
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .emailAlreadyInUse:
                    completion?(.failure(.emailAlreadyInUse))
                case .weakPassword:
                    completion?(.failure(.weakPassword))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            // Now actually put the new user in the database
            self?.linkNewUser(withuid: authResult.user.uid, email: email, userName: userName, fullName: fullName, completion: completion)
        }
    }
    
    func isSignedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func signOut(completion: (()->Void)? = nil) {
        do {
            try auth.signOut()
            unlinkCurrentUser()
            completion?()
        } catch { }
    }
    
    /* Given a UID, adds a listener to the user's document and updates current user */
    private func linkUser(withuid uid: String,
                          completion: ((Result<User, AuthenticationError>)->Void)?) {
        
        // calls that closure when that document is updated
        userListener = db.collection("users").document(uid).addSnapshotListener { [weak self] docSnapshot, error in
            guard let document = docSnapshot else {
                completion?(.failure(.errorFetchingUserDoc))
                return
            }
            guard let user = try? document.data(as: User.self) else {
                completion?(.failure(.errorDecodingUserDoc))
                return
            }
            
            self?.currentUser = user
            completion?(.success(user))
        }
    }
    
    /* Create a new document for a new user, then link the user as above */
    private func linkNewUser(withuid uid: String, email: String, userName: String, fullName: String,
                          completion: ((Result<User, AuthenticationError>)->Void)?) {
        // First, create the document for the new user
        db.collection("users").document(uid).setData(["email": email, "fullname": fullName, "savedEvents": [], "username": userName])
        // Then, link the user to the current execution
        linkUser(withuid: uid, completion: completion)
    }
    
    private func unlinkCurrentUser() {
        userListener?.remove()
        currentUser = nil
    }
}
