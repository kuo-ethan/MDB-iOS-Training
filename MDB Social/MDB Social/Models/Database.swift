//
//  DatabaseRequest.swift
//  MDB Social
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestore

class Database {
    
    static let shared = Database()
    
    let db = Firestore.firestore()
    
    /* Create or update the data for a user in the database. */
    func setUser(_ user: User, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    /* Create or update the data for an event in the database. */
    func setEvent(_ event: Event, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    /* TODO: Events getter */
    // For example, see Authentication.linkUser(withuid:completion:)
    
    /* Retrieves all events ever created from firestore database. Then displays them in FeedVC. */
    func getAllEvents(vc: FeedVC) {
        // Read all events from database
        var events: [Event] = []
        db.collection("events").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting events: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    // Cast document into an Event instance
                    guard let event = try? document.data(as: Event.self) else { return }
                    events.append(event)
                }
                vc.events = events
                vc.collectionView.performBatchUpdates(nil, completion: nil)
            }
        }
    }
    
    /* Sets the username label of the EventCell object for the given UserID. */
    func setUserNameLabel(id: UserID, cell: EventCell) {
        let docRef = db.collection("users").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                cell.creatorLabel.text = data?["fullname"] as? String ?? ""
                cell.creatorLabel.text = "Posted by: " + cell.creatorLabel.text!
            } else {
                print("Document does not exist, unable to get username")
            }
        }
    }
}
