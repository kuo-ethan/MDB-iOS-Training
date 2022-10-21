//
//  PokedexData.swift
//  Pokedex
//
//  Created by Ethan Kuo on 10/20/22.
//

import Foundation

class PokedexData {
    
    static let shared = PokedexData()
    
    let allPokemons: [Pokemon] = PokemonGenerator.shared.getPokemonArray()
    
    var currPokemons: [Pokemon]! = nil
    
    var gridLayoutOn: Bool = true
    
    var includedTypes: Set<PokeType> = Set(PokeType.allCases)
    
    // Keep track of whether a pokemon type is included on not by filter
    var typeFilterTracker: Dictionary<PokeType, Bool> = {
        var dict: Dictionary<PokeType, Bool> = [:]
        for type in PokeType.allCases {
            dict[type] = true
        }
        return dict
    }()
}
