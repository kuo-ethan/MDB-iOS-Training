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
    
    /* Update the data for a user in the database. */
    func setUser(_ user: User, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    /* Updates the data for an event in the database. */
    func setEvent(_ event: Event, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    /* TODO: Events getter */
    // For example, see Authentication.linkUser(withuid:completion:)
    // Make specialized getEvents like getAllEvents(...) or getEventsMadeByUser(...)
    
    /* Retrieves the data */
    func getUserEvents() {
        
    }
}
