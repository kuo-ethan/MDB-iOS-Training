//
//  SettingsVC.swift
//  Pokedex
//
//  Created by Ethan Kuo on 10/16/22.
//

import UIKit

class SettingsVC: UIViewController {
    
    // SettingsVC should have access to the collection view in order to change layouts
    var collectionView: UICollectionView! = nil
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Settings"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 27, weight: .medium)
        return label
    }()
    
    let gridSwitchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Grid Layout"
        label.textAlignment = .center
        return label
    }()
    
    let gridSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = true
        return toggle
    }()
    
    // Make a view for a filter
    let filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Filter"
        label.textAlignment = .center
        return label
    }()
    
    init(_ collectionView: UICollectionView) {
        super.init(nibName: nil, bundle: nil)
        self.collectionView = collectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        // Display "Settings" header label
        view.addSubview(settingsLabel)
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Display grid layout toggle and label
        view.addSubview(gridSwitchLabel)
        NSLayoutConstraint.activate([
            gridSwitchLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            gridSwitchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(gridSwitch)
        gridSwitch.addAction(UIAction(handler: layoutSwitchHandler), for: .valueChanged)
        NSLayoutConstraint.activate([
            gridSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            gridSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        // Display filter
        view.addSubview(filterLabel)
        NSLayoutConstraint.activate([
            filterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
    }
    
    
    func layoutSwitchHandler(_action: UIAction) {
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}
