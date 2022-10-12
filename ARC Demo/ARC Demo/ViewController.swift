//
//  ViewController.swift
//  ARC Demo
//
//  Created by Ethan Kuo on 10/6/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class CustomViewController: UIViewController, CustomViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CustomView()
        view.dataSource = self
    }
}

protocol CustomViewDataSource: AnyObject {}

class CustomView: UIView {
    var dataSource: CustomViewDataSource? = nil; // has to conform to a protocol
}
