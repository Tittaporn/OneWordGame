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
    var hiddenLetters: [String] = []
    var countdownTimer: Timer!
    var countdownTimerForWord: Timer!
    var countdownTimerForLetter: Timer!
    var totalTime = 60
    var letterTimer = 2
    var score = 0
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        typingWordTextField.delegate = self
        setRandomTarget()
        buildTargetStack()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        startTimer()
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
    
    func startTimerForEachWord() {
        countdownTimerForWord = Timer(timeInterval: 10, repeats: true, block: { (timer) in
            timer.invalidate()
            self.setRandomTarget()
            self.resetStackView()
        })
        RunLoop.current.add(countdownTimerForWord, forMode: .common)
    }
    //  BenTin - startTimerForEachWord is now working for both typing and just regular counting... change the timeIntervale in the parameters above to chage the duration of the time for each word.  Can probably write a similar function for startTimerForEachLetter.  Note that this function is not using the variable wordTimer.
    
    func startTimerForEachLetter() {
        countdownTimerForLetter = Timer(timeInterval: 2, repeats: true, block: { (timer) in
            timer.invalidate()
            self.showRandomLetter()
        })
        RunLoop.current.add(countdownTimerForLetter, forMode: .common)
    }
    
    func setRandomTarget() {
        target = WordController.shared.words.randomElement() ?? ""
        targetArray = target.map(String.init)
    }
    
    func showRandomLetter() {
        guard let random = hiddenLetters.randomElement() else { return }
        
        var index = 0
        for letter in targetArray {
            if letter == random {
                guard let labelView = stackViewTargetWord.arrangedSubviews[index] as? UILabel else { return }
                labelView.text = random.capitalized
            }
            index += 1
        }
        
        hiddenLetters.removeAll { (test) -> Bool in
            if test == random {
                return true
            }
            return false
        }
        
        startTimerForEachLetter()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if self.typingWordTextField.text == self.target {
            // scoreFunction() based on the timer
            // update scoreLabel
            
            textField.text = ""
            textField.becomeFirstResponder()
            
            countdownTimerForWord.invalidate()
            countdownTimerForLetter.invalidate()
            setRandomTarget()
            resetStackView()
        }
    }
    
    func buildTargetStack()  {
        hiddenLetters.removeAll()
        
        for letter in targetArray {
            let letterBlock = generateLetterBlock(for: letter)
            
            if letter == targetArray.first {
                letterBlock.text = letter.capitalized
            }
            
            stackViewTargetWord.addArrangedSubview(letterBlock)
        }
        
        hiddenLetters = targetArray
        hiddenLetters.removeFirst()
        
        startTimerForEachLetter()
        startTimerForEachWord()
    }
    
    func generateLetterBlock(for letter: String) -> UILabel {
        let letterBlock = UILabel()
        letterBlock.text = ""
        letterBlock.font = UIFont(name: "Helvetica", size: 30)
        letterBlock.font = UIFont.boldSystemFont(ofSize: 30)
        letterBlock.textColor = .white
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
