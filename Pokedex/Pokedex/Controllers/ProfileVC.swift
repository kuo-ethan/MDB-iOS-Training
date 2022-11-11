//
//  ProfileVC.swift
//  Pokedex
//
//  Created by Ethan Kuo on 10/21/22.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {
    var pokemon: Pokemon! = nil
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameIDLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 27, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(nameIDLabel)
        view.addSubview(statsLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            nameIDLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameIDLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statsLabel.topAnchor.constraint(equalTo: nameIDLabel.bottomAnchor, constant: 30),
            statsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            statsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
    }
    
    init(pokemon: Pokemon, _ nibName: String?, _ bundle: Bundle?) {
        self.pokemon = pokemon
        
        super.init(nibName: nibName, bundle: bundle)
        
        let completion: (UIImage) -> Void = { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        
        DispatchQueue.global(qos: .utility).async { [self] in
            guard let url = self.pokemon.imageUrl else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            completion(UIImage(data: data)!)
        }
        
        let name = self.pokemon.name
        let id = self.pokemon.id
        nameIDLabel.text = "\(name), #\(id)"
        
        // Stats include attack, defense, health, specialAttack, specialDefense, speed, total, types
        initializeStatsLabel()
    }
    
    func initializeStatsLabel() {
        var stringifiedTypes = ""
        for i in 0..<(pokemon.types.count-1) {
            stringifiedTypes = stringifiedTypes + pokemon.types[i].rawValue + ", "
        }
        stringifiedTypes += pokemon.types.last!.rawValue
        statsLabel.text = "Attack: \(pokemon.attack)\n Defense: \(pokemon.defense)\n Health: \(pokemon.health)\n Special attack: \(pokemon.specialAttack)\n" +
            "Special defense: \(pokemon.specialDefense)\n Speed: \(pokemon.speed)\n Total: \(pokemon.total)\n Types: \(stringifiedTypes)\n"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
