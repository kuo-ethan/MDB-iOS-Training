//
//  SOCDBRequest.swift
//  MDB Social
//
//  Created by Michael Lin on 10/9/21.
//

import Foundation
import FirebaseFirestore

class Database {
    
    static let shared = Database()
    
    let db = Firestore.firestore()
    
    func setUser(_ user: User, completion: (()->Void)?) {
        /* TODO: Demo */
    }
    
    func setEvent(_ event: Event, completion: (()->Void)?) {
        /* TODO: Demo */
    }
    
    /* TODO: Project */
}
