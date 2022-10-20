//
//  SFSCollectionVC.swift
//  SFSCollectionVC
//
//  Created by Michael Lin on 9/26/21.
//

import UIKit

class SFSCollectionVC: UIViewController {
    
    // TODO: Collection View
    let collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SFSCollectionCell.self, forCellWithReuseIdentifier: SFSCollectionCell.reuseIdentifier)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1B 1D 1F
        view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 88, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.dataSource = self
    }
}



extension SFSCollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SymbolProvider.symbols.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let symbol = SymbolProvider.symbols[indexPath.item]
        // collectionView.dequeueReusableCell(withReuseIdentifier: SFSCollectionCell.reuseIdentifier, for: indexPath) as? SFSCollectionCell -> SFSCollectionCell?
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SFSCollectionCell.reuseIdentifier, for: indexPath) as? SFSCollectionCell else {
            fatalError("Unexpected cell class")
        }
        cell.symbol = symbol
        return cell
    }
}

extension SFSCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let symbol = SymbolProvider.symbols[indexPath.item]

        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
            return SFSPreviewVC(symbol: symbol)
        }) { _ in
            let okItem = UIAction(title: "OK", image: UIImage(systemName: "arrow.down.right.and.arrow.up.left")) { _ in }
            return UIMenu(title: "", image: nil, identifier: nil, children: [okItem])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let symbol = SymbolProvider.symbols[indexPath.item]
        print("Selected \(symbol.name)")
    }
}
