//
//  ViewController.swift
//  Demo
//
//  Created by Ethan Kuo on 9/25/22.
//

import UIKit

class ViewController: UIViewController {
    
    var welcomeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: 60))
        label.text = "Welcome to MDB"
        label.font = .systemFont(ofSize: 25, weight: UIFont.Weight.medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(welcomeLabel)
    }


}

