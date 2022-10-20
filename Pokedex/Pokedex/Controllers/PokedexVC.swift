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
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    
    // let currPokemons = ... // filter pokemons, then call batchUpdates
    
    var settingsVC: SettingsVC! = nil
    
    let settingsButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.tinted()
        config.title = "Settings"
        config.baseBackgroundColor = .systemGray
        config.baseForegroundColor = .systemGray
        config.imagePadding = 10
        config.buttonSize = .small
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
//    let searchBar: UISearchBar = { // UISearchBarController
//        let searchBar = UISearchBar()
//        searchBar.searchBarStyle = .minimal
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        return searchBar
//    }()

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

        
        // Display settings button
        view.addSubview(settingsButton)
        settingsButton.addAction(UIAction(handler: tapSettingsHandler), for: .touchUpInside)
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            settingsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Display search bar
//        view.addSubview(searchBar)
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            searchBar.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//
//        searchBar.delegate = self // Connect search bar to search bar delegate
        
        // Display collection view
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 150, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.dataSource = self // Connect collection view to data source
        collectionView.delegate = self // Connect collection view to layout delegate
    }
    
    func tapSettingsHandler(_ action: UIAction) {
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

// The PokedexVC is also a data source for updating its collection view.
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
        if settingsVC.gridSwitch.isOn {
            return CGSize(width: 80, height: 100) // 3 pokemon per row
        } else {
            return CGSize(width: 160, height: 200) // 1 pokemon per row
        }
    }
    
    // Is this one needed?
    // func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {}
    
    // Print which pokemon was selected.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let symbol = pokemons[indexPath.item]
        print("Selected \(symbol.name)")
    }
}

extension PokedexVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        print(text)
    }
}

//extension PokedexVC: UISearchBarDelegate {
//    // Add functionality for search bar
//    // textDidChange function
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { // any time they edit the search bar
//        // searchText is what's in the search bar
//        // filter or contains are built in to swift
//        // if statement if curent pokemons is empty, show all of them?
//    }
//}



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
    
    // The Pokemon associated with a cell. This is a computed property.
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
