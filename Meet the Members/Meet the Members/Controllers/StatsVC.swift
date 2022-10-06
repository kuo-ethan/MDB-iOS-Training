//
//  StatsVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 11: Going to StatsVC
    // Read the instructions in MainVC.swift
    
    let data: String
    
    init(data: String) {
        self.data = data
        // Delegate rest of the initialization to super class
        // designated initializer.
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: >> Your Code Here <<
    
    // MARK: STEP 12: StatsVC UI
    // Action Items:
    // - Initialize the UI components, add subviews and constraints
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let returnButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.tinted()
        config.title = "Resume"
        config.baseBackgroundColor = .systemGreen // background color
        config.baseForegroundColor = .systemGreen // text color
        config.imagePadding = 10
        config.buttonSize = .small
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: >> Your Code Here <<
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = data
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(returnButton)
        
        // Constraints go here
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            returnButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        returnButton.addAction(UIAction(handler: tapResumeHandler), for: .touchUpInside)

        
        
    }
    
    func tapResumeHandler (_action: UIAction) {
        paused = false
        dismiss(animated: true)
    }
}
