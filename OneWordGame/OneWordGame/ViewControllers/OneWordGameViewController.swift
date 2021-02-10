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
    
    // MARK: - Properties
    var mockedTarget = "mock"
    var countdownTimer: Timer!
    var totalTime = 60
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
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
    
}
