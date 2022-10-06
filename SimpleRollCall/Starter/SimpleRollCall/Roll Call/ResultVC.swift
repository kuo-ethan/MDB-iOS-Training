//
//  ResultVC.swift
//  CalHacksDemo
//
//  Created by Michael Lin on 8/26/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    override func viewDidLoad() {
        // Insert IBOutlet entry points here
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        presentNames.text = Roster.main.namesPresent.joined(separator: ", ")
        absentNames.text = Roster.main.namesPresent.joined(separator: ", ")
        
        var config = UIButton.Configuration.filled()
        config.title = "Share"
        config.image = UIImage(systemName: "square.and.arrow.up")
        config.imagePadding = 10
        config.preferredSymbolConfigurationForImage = .init(weight: .medium)
        shareButton.configuration = config
        shareButton.addAction(UIAction { _ in
            let url = Roster.main.saveResultToFile()!
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil) // airdrop page
            self.present(vc, animated: true)
        }, for: .touchUpInside
        )
        
        config = UIButton.Configuration.tinted()
        config.title = "Reset"
        config.image = UIImage(systemName: "arrow.clockwise")
        config.imagePadding = 10
        shareButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        })
        
        // how to make it refresh after swiping back from sheet
        
        // CONNECTING STORYBOARD TO SWIFT
        // 1. set the class
        // 2. control + drag to top of class, should add @IBOutlet weak var ... (entry point)
        // 3. can then treat the views as normal!
        // 4. make a storyboard ID
        // 4b. make sure when you intialize the view controller, do vc = UIStoryboard(name: "Main", bundle: nil).intstantiateViewController(withIdentifier: storyboardID)
        
    }
}
