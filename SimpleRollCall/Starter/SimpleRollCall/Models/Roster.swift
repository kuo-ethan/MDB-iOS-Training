//
//  Roster.swift
//  CalHacksDemo
//
//  Created by Michael Lin on 10/22/21.
//  Copyright © 2021 Michael Lin. All rights reserved.
//

import Foundation

class Roster {
    
    static let main = Roster()
    
    struct Result: Codable {
        let presentList: [String]
        let absentList: [String]
        
        enum CodingKeys: String, CodingKey {
            case presentList = "present"
            case absentList = "absent"
        }
        
        init(withRoster roster: Roster) {
            self.presentList = roster.namesPresent
            self.absentList = roster.namesAbsent
        }
    }
    
    // MDB Newbies - Class of Spring 2022
    let names = ["Blake", "David", "Jeffrey", "Marco", "Mod", "Mustafa", "Noah"]
    
    private(set) var remainingNames = [String]()
    
    private(set) var namesPresent = [String]()
    
    private(set) var namesAbsent = [String]()
    
    init() { reset() }
    
    func reset() {
        remainingNames = names.shuffled()
        namesPresent = []
        namesAbsent = []
    }
    
    func getNextName() -> String? {
        return remainingNames.popLast()
    }
    
    func addName(toPresent name: String) {
        namesPresent.append(name)
    }
    
    func addName(toAbsent name: String) {
        namesAbsent.append(name)
    }
    
    func hasNamesLeft() -> Bool {
        return remainingNames.count != 0
    }
    
    func resultToFile() -> URL? {
        let result = Result(withRoster: self)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(result) else {
            return nil
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let url = cacheDirectory.appendingPathComponent("RollCall-\(Date.now.formatted(date: .abbreviated, time: .omitted)).json")
        do {
            try jsonString.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            return nil
        }
    }
}
