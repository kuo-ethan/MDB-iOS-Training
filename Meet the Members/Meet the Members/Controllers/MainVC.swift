//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            
            // MARK: >> Your Code Here <<
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
    
    // MARK: >> Your Code Here <<
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // MARK: STEP 6: Adding Subviews and Constraints
        // Action Items:
        // - Add imageViews and buttons to the root view.
        // - Create and activate the layout constraints.
        // - Run the App
        
        // Additional Information:
        // If you don't like the default presentation style,
        // you can change it to full screen too! However, in this
        // case, because user can no longer swipe down to dismiss
        // the sheet, you will have to find a way to manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
        
        // MARK: >> Your Code Here <<
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        
        for i in 0...3 {
            let button = buttons[i]
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-100 * i)),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                button.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        
        getNextQuestion()
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
        
        // MARK: >> Your Code Here <<
        
        
        // MARK: STEP 10: Stats Button
        // See instructions above.
        
        // MARK: >> Your Code Here <<
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 13: Resume Game
        
        // MARK: >> Your Code Here <<
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Data Model
        // Action Items:
        // - Get a question instance from `QuestionProvider`
        // - Configure the imageView and buttons with information from
        //   the question instance
        
        // MARK: >> Your Code Here <<
        if let question = QuestionProvider.shared.nextQuestion() {
            imageView.image = question.image
            for i in 0...3 {
                buttons[i].setTitle(question.choices[i], for: .normal)
            }
        } else {
            return
        }
        
    }
    
    // MARK: STEP 8: Buttons and Timer Callback
    // You don't have to
    // Action Items:
    // - Complete the callback function for the 4 buttons.
    // - Complete the callback function for the timer instance
    // - Call `startTimer()` where appropriate
    //
    // Additional Information:
    // Take some time to plan what should be in here.
    // The 4 buttons should share the same callback.
    //
    // Add instance properties and/or methods
    // to the class if necessary. You may need to come back
    // to this step later on.
    //
    // Hint:
    // - Checkout `UIControl.addAction(_:for:)`
    //      (`UIButton` subclasses `UIControl`)
    // - You can use `sender.tag` to identify which button is pressed.
    // - The timer will invoke the callback every one second.
    func startTimer() {
        // Create a timer that calls timerCallback() every one second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func timerCallback() {
        
        // MARK: >> Your Code Here <<
    }
    
    func tapAnswerHandler(_ action: UIAction) {
        // MARK: >> Your Code Here <<

    }
    
    func tapStatsHandler(_ action: UIAction) {
        
        let vc = StatsVC(data: "Hello")
        
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 11: Going to StatsVC
        // When we are navigating between VCs (e.g MainVC -> StatsVC),
        // we often need a mechanism for transferring data
        // between view controllers. There are many ways to achieve
        // this (initializer, delegate, notification center,
        // combined, etc.). We will start with the easiest one today,
        // which is custom initializer.
        //
        // Action Items:
        // - Pause the game when stats button is tapped i.e. stop the timer
        // - Read the example in StatsVC.swift, and replace it with
        //   your custom init for `StatsVC`
        // - Update the call site here on line 139
        
        present(vc, animated: true, completion: nil)
    }
}
