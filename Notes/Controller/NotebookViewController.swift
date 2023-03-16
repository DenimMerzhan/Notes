//
//  ViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit

class ViewController: UIViewController {

    var notesArray = ["Заметки","Песни","Блог"]
    override func viewWillAppear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = UIColor(named: "NotesBackgound")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

