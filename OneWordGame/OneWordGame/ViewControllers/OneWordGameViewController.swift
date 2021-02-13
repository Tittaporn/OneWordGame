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
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var gameStatusButtonLable: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    
    // MARK: - Properties
    var target = ""
    var targetArray: [String] = []
    var hiddenLetters: [String] = []
    var countdownTimer: Timer!
    var countdownTimerForWord: Timer!
    var countdownTimerForLetter: Timer!
    var totalTime = 60
    var score = 0
    var isPlayingGame: Bool = false
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        typingWordTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultLabel.isHidden = true
        gameOverLabel.text = "One Word Game"
        timerLabel.text = "00 : 00"
    }
    
    // MARK: - Actions
    @IBAction func startGameButtonTapped(_ sender: Any) {
        // print("button Tapped")
        isPlayingGame.toggle()
        print("isPlayingGame \(isPlayingGame)")
        if isPlayingGame {
            playingGame()
        } else {
            stoppingGame()
        }
    }
    
    // MARK: - Game Methods
    func playingGame() {
        gameOverLabel.isHidden = true
        resultLabel.isHidden = true
        score = 0
        totalTime = 60
        scoreLabel.text = "\(score)"
        startTimer()
        stackViewTargetWord.isHidden = false
        setRandomTarget()
        buildTargetStack()
        gameStatusButtonLable.text = "Stop Game"
    }
    
    func stoppingGame() {
        totalTime = 0
        timerLabel.text = "00 : 00"
        gameStatusButtonLable.text = "Start Game"
        if score > 10 {
            resultLabel.isHidden = false
            resultLabel.text = "Congratulation ! 🌟🌟🌟 \nOne Word Master."
        } else {
            resultLabel.isHidden = false
            resultLabel.text = "Try Again ! ❌ \nBetter Luck Next Time."
        }
        gameOverLabel.isHidden = false
        gameOverLabel.text = "Game Over"
        stackViewTargetWord.isHidden = true
        resetStackView()
    }
    
    //  MARK: - Timer Methods
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
        countdownTimerForWord.invalidate()
        countdownTimerForLetter.invalidate()
        isPlayingGame = false
        stoppingGame()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startTimerForEachWord() {
        countdownTimerForWord = Timer(timeInterval: 10, repeats: true, block: { (timer) in
            timer.invalidate()
            self.setRandomTarget()
            self.resetStackView()
            self.buildTargetStack()
            self.typingWordTextField.text = ""
        })
        RunLoop.current.add(countdownTimerForWord, forMode: .common)
    }
    
    func startTimerForEachLetter() {
        countdownTimerForLetter = Timer(timeInterval: 2, repeats: true, block: { (timer) in
            timer.invalidate()
            self.showRandomLetter()
        })
        RunLoop.current.add(countdownTimerForLetter, forMode: .common)
    }
    
    // MARK: -  Target's Word Methods
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
            score += 1
            scoreLabel.text = "\(score)"
            resultLabel.isHidden = false
            resultLabel.text = "👍 ✅"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.resultLabel.text = ""
            }
            textField.text = ""
            textField.becomeFirstResponder()
            countdownTimerForWord.invalidate()
            countdownTimerForLetter.invalidate()
            setRandomTarget()
            resetStackView()
            buildTargetStack()
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
    }
}   //  End of Class
