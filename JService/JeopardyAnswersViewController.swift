//
//  JeopardyAnswersViewController.swift
//  JService
//
//  Created by Christian Shirichena on 12/28/20.
//

import UIKit

final class JeopardyAnswersViewController: UIViewController {
    @IBOutlet weak var JeopadyAnswersLabel: UILabel!
    @IBOutlet weak var JeopadyAnswersTableView: UITableView!
    
    var question: Clue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.JeopadyAnswersLabel.text = self.question.answer
        
    }
    
}

