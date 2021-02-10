//
//  OneWordGameViewController.swift
//  OneWordGame
//
//  Created by Lee McCormick on 2/10/21.
//

import UIKit

class OneWordGameViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stackViewTargetWord: UIStackView!
    @IBOutlet weak var typingWordTextField: UITextField!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
