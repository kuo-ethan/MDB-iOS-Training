//
//  ViewController.swift
//  GCDDemo
//
//  Created by Ethan Kuo on 10/13/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async { // Is a Singleton object from DispatchQueue class, same with DispatchQueue.global (one for each QoS)
            print("From main dispatch queue")
        }
        
        let completion: (Int)->Void = { num in
            print("The result is \(num)")
        }
        
        DispatchQueue.global(qos: .background).async { // QoS determine how threads are used. "background" is for slow tasks, save battery
            // some elaborate task
            completion(1) // handles what should happen after an async task is completed. Note that completion closer is implicitly captured
        }
        
        DispatchQueue.global(qos: .userInteractive).async { // QoS determine how threads are used. "background" is for slow tasks, save battery
            print("From global dispatch queue with userInteractive qos")
        }
        
        // Sync vs Async
        // Treated all the same in a DispatchQueue, only matters in call site (the function that calls)
        // Sync means you can't move past that code until the task is finished, wait for DispatchQueue to finish
        // Async means let's DispatchQueue take care of it on its own time, can't have return statement in async
        // @escaping means that the closure might return even after the function that calls it returns
        // Completion and completion handlers
    }


}

