//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

// Make navigation controller class
// Do search bar first

class PokedexVC: UIViewController {
    
    var pokemons = PokedexData.shared.allPokemons
    
    var settingsVC: SettingsVC! = nil
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a single SettingsVC (to save state)
        settingsVC = SettingsVC(collectionView)
        settingsVC.modalPresentationStyle = .fullScreen
        
        // Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pokemon"
        navigationItem.searchController = searchController
        navigationItem.title = "Pokedex"
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(tapSettingsHandler))

        // Display collection view
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 100, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self // Connect collection view to data source
        collectionView.delegate = self // Connect collection view to layout delegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadPokemon()
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    // Sets pokemons according to filtered types.
    func reloadPokemon() {
        pokemons = PokedexData.shared.allPokemons.filter({ pokemon in
            Set(pokemon.types).isSubset(of: PokedexData.shared.includedTypes)
        })
    }
    
    @objc func tapSettingsHandler(_ sender: Any) {
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// The PokedexVC is also a data source for its own collection view.
extension PokedexVC: UICollectionViewDataSource {
    
    // Set the number of cells in the collection view.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    // Get a PokemonCell for the pokemon specificied by indexPath.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let symbol = pokemons[indexPath.item]
        // Grab a PokemonCell from the available pool
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        cell.symbol = symbol
        return cell
    }
}

extension PokedexVC: UICollectionViewDelegateFlowLayout {
    // Get the size of a cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if PokedexData.shared.gridLayoutOn {
            return CGSize(width: 80, height: 100) // 3 pokemon per row
        } else {
            return CGSize(width: 160, height: 200) // 1 pokemon per row
        }
    }
    
    // Open profile VC for the selected pokemon.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let symbol = pokemons[indexPath.item]
        print("Selected \(symbol.name)")
        navigationController?.pushViewController(ProfileVC(pokemon: symbol, nil, nil), animated: true)
    }
}

// PokedexVC is the delegate for search bar functions.
extension PokedexVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        reloadPokemon()
        if !text.isEmpty {
            var searchedPokemons: [Pokemon] = []
            for pokemon in pokemons {
                if pokemon.name.lowercased().contains(text.lowercased()) {
                    searchedPokemons.append(pokemon)
                }
            }
            pokemons = searchedPokemons
        }
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}

// A cell in the collection view grid for a pokemon
class PokemonCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PokemonCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameIDLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // When a pokemon is set to this cell, it's image and label will be updated.
    var symbol: Pokemon? {
        didSet {
            let completion: (UIImage) -> Void = { image in
                // Update our imageView using main thread. UI elements must be updated through main.
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            // When a Pokemon is set, attempt to get the image data using global threads.
            DispatchQueue.global(qos: .utility).async { [self] in
                guard let url = symbol?.imageUrl else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                completion(UIImage(data: data)!)
            }
            
            let name = symbol?.name ?? ""
            let id = symbol?.id ?? 0
            nameIDLabel.text = "\(name), #\(id)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
        contentView.addSubview(nameIDLabel)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameIDLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            nameIDLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameIDLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
