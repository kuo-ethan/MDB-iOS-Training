//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Ethan Kuo on 10/12/22.
//

import Foundation
import UIKit


class PokemonCell: UICollectionViewCell {
    static let reuseIdentifier = "PokemonCell"
    
    private let imageView: UIImageView = {
        
    }()
    
    private let idLabel: UILabel = {
        
    }()
    
    private let nameLabel: UILabel = {
        
    }()
    
    var symbol: Pokemon? {
        didSet {
            let completion: (UIImage) -> Void = { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
            }
            DispatchQueue.global(qos: .utility).async { [self] in
            guard let url = symbol?.imageUrl else { return }
            guard let data = try? Data(contentsOf: url) else { return }
                completion(UIImage(data: data)!)
            }
            
            
            let name = symbol?.name ?? ""
            let id = symbol?.id ?? 0
            
            nameLabel.text = name
            idLabel.text = "#\(id)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)
        imageView.frame = contentView.bounds
        
        // set constraints
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
