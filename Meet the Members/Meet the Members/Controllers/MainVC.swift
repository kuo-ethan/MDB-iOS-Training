//
//  MainVC.swift
//  Meet the Members
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit


// Indicates whether the game is paused. Global so accessible by other VCs.
var paused: Bool = false

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    
    // Time elapsed
    var timeLeft = 5
    
    // Freeze for two seconds
    var freeze = -1
    
    // Current correct answer
    var answer: Int?
    
    
    // Answer streak
    var streak: Int = 0
    
    // Score
    var score: Int = 0
    
    // Last three answers
    var lastThree: [Bool] = []
    
    // MARK: STEP 7: UI Customization
    // Action Items:
    // - Customize your imageView and buttons.
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Score: 0"
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttons: [UIButton] = {
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
            
            // MARK: >> Your Code Here <<
            button.backgroundColor = .systemCyan
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
        
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Time left: 5"
        return label
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.tinted()
        config.title = "Pause"
        config.baseBackgroundColor = .systemGreen // background color
        config.baseForegroundColor = .systemGreen // text color
        config.imagePadding = 10
        config.buttonSize = .small
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: STEP 10: Stats Button
    // Action Items:
    // - Follow the examples you've seen so far, create and
    // configure a UIButton for presenting the StatsVC. Only the
    // callback function `didTapStats(_:)` was written for you.
    
    // MARK: >> Your Code Here <<
    let statsButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.tinted()
        config.title = "Stats"
        config.baseBackgroundColor = .systemGreen // background color
        config.baseForegroundColor = .systemGreen // text color
        config.imagePadding = 10
        config.buttonSize = .small
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        modalPresentationStyle = .fullScreen
        
        // MARK: >> Your Code Here <<
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 300),
        ])
        
        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        
        for i in 0...3 {
            let button = buttons[i]
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: CGFloat(-75 * (i + 1))),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        startTimer()
        getNextQuestion()
        
        // MARK: STEP 9: Bind Callbacks to the Buttons
        // Action Items:
        // - Bind the `didTapAnswer(_:)` function to the buttons.
        
        // MARK: >> Your Code Here <<
        for i in 0...3 {
            buttons[i].addAction(UIAction(handler: tapAnswerHandler), for: .touchUpInside)
        }
        
        
        
        // MARK: STEP 10: Stats Button
        // See instructions above.
        
        // MARK: >> Your Code Here <<
        statsButton.addAction(UIAction(handler: tapStatsHandler), for: .touchUpInside)
        view.addSubview(statsButton)
        NSLayoutConstraint.activate([
            statsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            statsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        pauseButton.addAction(UIAction(handler: tapPauseResumeHandler), for: .touchUpInside)
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pauseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            pauseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
                if question.choices[i] == question.answer {
                    answer = i
                }
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
        if paused {
            return
        }
        
        if freeze > 0 {
            freeze -= 1
        } else if freeze == 0 {
            freeze -= 1
            timeLeft = 5
            for button in buttons {
                button.backgroundColor = .systemCyan
            }
            getNextQuestion()
        } else {
            // Not frozen
            timeLeft -= 1
            if timeLeft == 0 {
                // Ran out of time
                buttons[answer!].backgroundColor = .systemGreen
                freeze = 2
                streak = 0
                updateLastThree(false)
                
            }
        }
        
        timeLabel.text = "Time left: \(max(timeLeft, 0))"
    }
    
    func tapAnswerHandler(_ action: UIAction) {
        if paused {
            return
        }
        guard let sender = action.sender, let button = sender as? UIButton else {
            return
        }
        if button.tag == answer {
            button.backgroundColor = .systemGreen
            score += 1
            streak += 1
            updateLastThree(true)
            scoreLabel.text = "Score: \(score)"
        } else {
            button.backgroundColor = .systemRed
            updateLastThree(false)
            streak = 0
        }
        freeze = 2
    }
            
    func updateLastThree(_ correct: Bool) {
        lastThree.append(correct)
        if lastThree.count > 3 {
            lastThree.remove(at: 0)
        }
    }
    
    func tapPauseResumeHandler(_ action: UIAction) {
        guard let sender = action.sender, let button = sender as? UIButton else {
            return
        }
        paused = !paused
        if paused { // Then we are in the paused screen
            button.setTitle("Resume", for: .normal)
        } else {
            button.setTitle("Pause", for: .normal)
        }
        
        
    }
    
    func tapStatsHandler(_ action: UIAction) {
        paused = true
        var lastThreeCount = 0
        for b in lastThree {
            if b {
                lastThreeCount += 1
            }
        }
        let vc = StatsVC(data: "Your answer streak is \(streak), and you got \(lastThreeCount) of the last three questions correct.")
        
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
