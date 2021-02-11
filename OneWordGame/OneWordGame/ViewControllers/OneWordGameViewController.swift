//
//  OneWordGameViewController.swift
//  OneWordGame
//
//  Created by Lee McCormick on 2/10/21.
//

import UIKit

class OneWordGameViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stackViewTargetWord: UIStackView!
    @IBOutlet weak var typingWordTextField: UITextField!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    // MARK: - Properties
    var target = ""
    var targetArray: [String] = []
    var countdownTimer: Timer!
    var totalTime = 60
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typingWordTextField.delegate = self
        setRandomTarget()
        buildTargetStack()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    //  MARK: - Methods
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setRandomTarget() {
        
        target = WordController.shared.words.randomElement() ?? ""
        targetArray = target.map(String.init)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if self.typingWordTextField.text == self.target {
            // scoreFunction() based on the timer
            // update scoreLabel
            
            setRandomTarget()
            resetStackView()
            
            textField.text = ""
            textField.becomeFirstResponder()
        }
    }

    func buildTargetStack()  {
        for letter in targetArray {
            let letterBlock = generateLetterBlock(for: letter)
            stackViewTargetWord.addArrangedSubview(letterBlock)
        }
    }

    func generateLetterBlock(for letter: String) -> UILabel {
        let letterBlock = UILabel()
        letterBlock.text = letter.capitalized
        letterBlock.font = UIFont(name: "Helvetica", size: 30)
        letterBlock.font = UIFont.boldSystemFont(ofSize: 30)
        letterBlock.textColor = .white
//        letterBlock.layer.borderColor = CGColor(gray: 30.0, alpha: 1)
//        letterBlock.layer.borderWidth = 3
        letterBlock.textAlignment = .center
        
        return letterBlock
    }

    func resetStackView() {
        for subview in stackViewTargetWord.arrangedSubviews {
            subview.removeFromSuperview()
        }
        buildTargetStack()
    }
    
}   //  End of Class
