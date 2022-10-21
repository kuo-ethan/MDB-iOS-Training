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
    
    let filteredTypes: Set<PokeType> = []
}
