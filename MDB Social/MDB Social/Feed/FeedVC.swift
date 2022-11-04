//
//  FeedVC.swift
//  MDB Social
//
//  Created by Michael Lin on 10/17/21.
//

import UIKit

class FeedVC: UIViewController {
    
    var events: [Event] = []
    
//    private let signOutButton: UIButton = {
//        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        btn.backgroundColor = .primary
//        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
//        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
//        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
//        btn.tintColor = .white
//        btn.layer.cornerRadius = 50
//
//        return btn
//    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.shared.getAllEvents(vc: self)
        
        navigationItem.title = "MDB Socials"
        navigationItem.rightBarButtonItem = .init(title: "Sign Out", style: .plain, target: self, action: #selector(didTapSignOut))
        
        
        // Display collection view
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 100, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        Authentication.shared.signOut { [weak self] in
            guard let self = self else { return }
            guard let window = self.view.window else { return }
            
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
}

extension FeedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("called collection view count")
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let symbol = events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.reuseIdentifier, for: indexPath) as! EventCell
        cell.symbol = symbol
        return cell
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let symbol = events[indexPath.item]
        print("Selected \(symbol.name)")
        // MARK: Make a profile VC for each event upon click
    }
}

class EventCell: UICollectionViewCell {
    static let reuseIdentifier = "EventCell"
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rsvpLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Whenever the event of this cell is set, we update the cell's views
    var symbol: Event? {
        didSet {
            let completion: (UIImage) -> Void = { image in
                // Update our imageView using main thread. UI elements must be updated through main.
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            DispatchQueue.global(qos: .utility).async { [self] in
                guard let photoURL = symbol?.photoURL else { return }
                guard let url = URL(string: photoURL) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                completion(UIImage(data: data)!)
            }
            
            guard let event = symbol else { return }
            nameDateLabel.text = "\(event.name)), \(event.startDate))"
            creatorLabel.text = "Posted by \(event.creator)"
            rsvpLabel.text = "Number of RSVPs: \(event.rsvpUsers.count)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // imageView.frame = contentView.bounds
        contentView.addSubview(imageView)
        contentView.addSubview(nameDateLabel)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(rsvpLabel)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameDateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            creatorLabel.topAnchor.constraint(equalTo: nameDateLabel.bottomAnchor, constant: 10),
            creatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            creatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rsvpLabel.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 10),
            rsvpLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rsvpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
