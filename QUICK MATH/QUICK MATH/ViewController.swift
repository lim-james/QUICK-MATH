//
//  ViewController.swift
//  QUICK MATH
//
//  Created by James Lim on 23/12/17.
//  Copyright © 2017 james. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var width: CGFloat = 0
    private var height: CGFloat = 0

    // whether answer is true or false
    private var answer: Bool = true
    
    // defining what type of question
    // 0: +     1: -     2: *     3: /
    private var type: Int = 0
    
    // i1: int 1    i2: int 2   a: answer
    private var i1: Int = 0
    private var i2: Int = 0
    private var a: Int = 0
    
    private var highscore: Int = 0
    private var score: Int = 0
    
    private var interval: TimeInterval = 0
    private var timer = Timer()
    
    // declaring elements
    
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var trueShadow: UIView!
    
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var falseShadow: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startShadow: UIView!
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        height = view.frame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        formatScoreLabel()
        mainLabel.text = "QUICK\nMATH"
        
        trueButton.frame.origin.y = height
        trueShadow.frame.origin.y = height + 10
        
        falseButton.frame.origin.y = height
        falseShadow.frame.origin.y = height + 10
    }
    
    // format score label's appearance
    private func formatScoreLabel() {
        if highscore < score {
            highscore = score
            scoreLabel.text = "\(score)\nNEW BEST: \(highscore)"
        } else {
            scoreLabel.text = "\(score)\nBEST: \(highscore)"
        }
    }
    
    // randomise int with an exception
    private func random_int(before r: UInt32, except x: Int) -> Int {
        var i: Int = Int(arc4random_uniform(r))
        // randomise if it is the same number
        while x == i { i = Int(arc4random_uniform(r)) }
        return i
    }
    
    private func randomise() {
        // set if answer is true or false
        answer = arc4random_uniform(2) == 0
        
        // set integers
        i1 = Int(arc4random_uniform(9) + 1)
        i2 = Int(arc4random_uniform(9) + 1)
        
        // 0: +     1: -     2: *     3: /
        switch arc4random_uniform(4) {
        case 0: type = 0
            a = answer ? i1 + i2 : random_int(before: 20, except: i1 + i2)
        case 1: type = 1
            a = answer ? i1 + i2 : random_int(before: 20, except: i1 + i2)
            let x: Int = i1; i1 = a; a = x // switching answer and first integer values
        case 2: type = 2
            a = answer ? i1 * i2 : random_int(before: 100, except: i1 * i2)
        case 3: type = 3
            a = answer ? i1 * i2 : random_int(before: 100, except: i1 * i2)
            let x: Int = i1; i1 = a; a = x // switching answer and first integer values
        default: break
        }
    }
    
    // display the information
    private func display() -> String {
        var sign: String = ""
        // change sign based on type
        switch type {
        case 0: sign = "+"
        case 1: sign = "-"
        case 2: sign = "x"
        case 3: sign = "÷"
        default: break
        }
        return "\(i1) \(sign) \(i2)\n= \(a)"
    }
    
    // start game action
    private func start() {
        interval = 2
        trueButton.isUserInteractionEnabled = true
        falseButton.isUserInteractionEnabled = true
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            self.startButton.frame.origin.y = self.height
            self.startShadow.frame.origin.y = self.height + 10
        }) { (Bool) in
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self.timerView.frame.size.height = self.height
                
                self.trueButton.frame.origin.y = self.height - 70
                self.trueShadow.frame.origin.y = self.height - 70
                
                self.falseButton.frame.origin.y = self.height - 70
                self.falseShadow.frame.origin.y = self.height - 70
            }, completion: { (Bool) in
                self.randomise()
                self.mainLabel.textColor = .white
                self.mainLabel.text = self.display()
                self.score = 0
                self.scoreLabel.text = "\(self.score)\n"
                self.timer = Timer.scheduledTimer(timeInterval: self.interval + 0.5, target: self, selector: #selector(self.timeEnd), userInfo: nil, repeats: false)
                UIView.animate(withDuration: self.interval + 0.5, animations: {
                    self.timerView.frame.size.height = 0
                })
                UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.trueButton.center.y -= 10
                    self.falseButton.center.y -= 10
                }, completion: nil)
            })
        }
    }
    
    // ending action from running out of time
    @objc private func timeEnd() {
        formatScoreLabel()
        mainLabel.text = "TOOOO\nSLOW!"
        mainLabel.textColor = falseButton.backgroundColor
        trueButton.isUserInteractionEnabled = false
        falseButton.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            self.timerView.frame.size.height = 0
            
            self.trueButton.frame.origin.y = self.height
            self.trueShadow.frame.origin.y = self.height + 10
            
            self.falseButton.frame.origin.y = self.height
            self.falseShadow.frame.origin.y = self.height + 10
            
            self.mainLabel.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2).rotated(by: -CGFloat.pi/12)
        }) { (Bool) in
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self.startButton.frame.origin.y = self.height - 70
                self.startShadow.frame.origin.y = self.height - 70
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.startButton.center.y -= 10
                    self.mainLabel.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1).rotated(by: 0)
                }, completion: { (Bool) in
                    
                })
            })
        }
    }
    
    // ending action from wrong
    private func wrongEnd() {
        formatScoreLabel()
        mainLabel.text = "   WRONG!\n   WRONG!\n   WRONG!"
        mainLabel.textColor = falseButton.backgroundColor
        trueButton.isUserInteractionEnabled = false
        falseButton.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.25, delay: 0, options: [], animations: {
            self.timerView.frame.size.height = 0
            
            self.trueButton.frame.origin.y = self.height
            self.trueShadow.frame.origin.y = self.height + 10
            
            self.falseButton.frame.origin.y = self.height
            self.falseShadow.frame.origin.y = self.height + 10
            
            self.mainLabel.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2).rotated(by: -CGFloat.pi/12)
        }) { (Bool) in
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
                self.startButton.frame.origin.y = self.height - 70
                self.startShadow.frame.origin.y = self.height - 70
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.25, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.startButton.center.y -= 10
                    self.mainLabel.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1).rotated(by: 0)
                }, completion: { (Bool) in
                    
                })
            })
        }
    }
    
    // check if answer is correct
    private func check(if x: Bool) {
        timer.invalidate()
        if x == answer {
            // increase score
            score += 1
            scoreLabel.text = "\(score)\n"
            // randomise values
            randomise()
            mainLabel.text = display()
            UIView.animate(withDuration: 0.1, animations: {
                self.timerView.frame.size.height = self.height
            })
            
            // decrease interval time
            interval = interval < 0 ? interval - 0.05 : interval
            timer = Timer.scheduledTimer(timeInterval: interval + 0.5, target: self, selector: #selector(self.timeEnd), userInfo: nil, repeats: false)
            UIView.animate(withDuration: interval + 0.4, delay: 0.1, options: .curveEaseOut, animations: {
                self.timerView.frame.size.height = 0
            }, completion: nil)
        } else {
            wrongEnd()
        }
    }
    
    @IBAction func truePressedAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.trueButton.center.y += 10
        }, completion: nil)
    }
    
    @IBAction func trueReleasedAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.trueButton.center.y -= 10
        }, completion: nil)
        check(if: true)
    }
    
    @IBAction func falsePressedAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.falseButton.center.y += 10
        }, completion: nil)
    }
    
    @IBAction func falseReleasedAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.falseButton.center.y -= 10
        }, completion: nil)
        check(if: false)
    }
    
    @IBAction func startPressedAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.startButton.center.y += 10
        }, completion: nil)
    }
    
    @IBAction func startReleased(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.startButton.center.y -= 10
        }, completion: nil)
        start()
    }
    
}

