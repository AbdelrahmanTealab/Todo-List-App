//
//  ViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    var lists:[List] = [
        List(title: "Grocery", dueDate: Date(), items: ["banana","apple","orange"]),
        List(title: "Games", dueDate: Date(), items: ["Red Dead","Cyberpunk","Tekken"]),
        List(title: "Productivity", dueDate: Date(), items: ["Finish app UI","Study iOS","Study UIUX"]),
        List(title: "Music", dueDate: Date(), items: ["Her Mannelig","In The Air Tonight","Unshaken"]),
        List(title: "Random list", dueDate: Date(), items: ["shave beard","trim hair","wash clothes"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

