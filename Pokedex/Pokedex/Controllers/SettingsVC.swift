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
    
    let filterTable: UITableView = {
        let tableView = UITableView()
        tableView.register(FilterElement.self, forCellReuseIdentifier: FilterElement.reuseIdentifier)
        return tableView
    }()
    
    
    init(_ collectionView: UICollectionView) {
        super.init(nibName: nil, bundle: nil)
        self.collectionView = collectionView
        
        // let typeList: [String] = PokeType.allCases.map({ "\($0)" }).joined(separator: "|").components(separatedBy: "|")
        
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
        
        // Display filter table
        view.addSubview(filterTable)
        filterTable.frame = view.bounds.inset(by: UIEdgeInsets(top: 250, left: 30, bottom: 0, right: 30))
        filterTable.dataSource = self
        filterTable.delegate = self
    }
    
    
    func layoutSwitchHandler(_action: UIAction) {
        PokedexData.shared.gridLayoutOn = gridSwitch.isOn
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PokeType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = PokeType.allCases[indexPath.item]
        let row = tableView.dequeueReusableCell(withIdentifier: FilterElement.reuseIdentifier, for: indexPath) as! FilterElement
        row.type = type
        return row
    }
    
    
}

class FilterElement: UITableViewCell {
    
    static let reuseIdentifier = "FilterElement"
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Not set yet"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    let filterSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.isOn = false
        return toggle
    }()
    
    var type: PokeType? {
        didSet {
            typeLabel.text = type?.rawValue
            filterSwitch.isOn = false
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(typeLabel)
        contentView.addSubview(filterSwitch)
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            typeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            filterSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            filterSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
