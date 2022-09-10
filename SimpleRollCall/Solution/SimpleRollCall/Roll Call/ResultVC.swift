//
//  ResultVC.swift
//  CalHacksDemo
//
//  Created by Michael Lin on 8/26/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {

    @IBOutlet weak var presentListLabel: UILabel! {
        didSet {
            presentListLabel.text = Roster.main.namesPresent.joined(separator: ", ")
            presentListLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var absentListLabel: UILabel! {
        didSet {
            absentListLabel.text = Roster.main.namesAbsent.joined(separator: ", ")
            absentListLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var resetButton: UIButton! {
        didSet {
            var config = UIButton.Configuration.tinted()
            config.title = "Reset"
            config.image = UIImage(systemName: "arrow.clockwise")
            config.imagePadding = 10
            config.buttonSize = .medium
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
            
            
            resetButton.configuration = config
            resetButton.addAction(UIAction { [unowned self] _ in
                Roster.main.reset()
                self.dismiss(animated: true, completion: nil)
            }, for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            var config = UIButton.Configuration.filled()
            config.title = "Share"
            config.image = UIImage(systemName: "square.and.arrow.up")
            config.imagePadding = 10
            config.buttonSize = .medium
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
            shareButton.configuration = config
            shareButton.addAction(UIAction { [unowned self] _ in
                let url = Roster.main.resultToFile()!
                let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }, for: .touchUpInside)
        }
    }
}
