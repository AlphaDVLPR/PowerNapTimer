//
//  TimerController.swift
//  PowerNapTimer
//
//  Created by AlphaDVLPR on 9/24/19.
//  Copyright © 2019 JesseRae. All rights reserved.
//

import Foundation

//MARK: - Protocols
protocol TimerDelegate: class {
    func timerSecondTicked()
    func timerCompleted()
    func timerStopped()
}

//MARK: - TimerController class
class TimerController {
    
    //MARK: - Source of Truth
    var timer: Timer?
    var timeRemaining: TimeInterval?
    var isOn: Bool {
        return timeRemaining != nil ? true : false
    }
    
    //MARK: - Delegate
    weak var delegate: TimerDelegate?
    
    func secondTicked() {
        guard let timeRemaining = timeRemaining else { return }
        if timeRemaining > 0 {
            self.timeRemaining = timeRemaining - 1
            delegate?.timerSecondTicked()
        } else {
            timer?.invalidate()
            self.timeRemaining = nil
            delegate?.timerCompleted()
        }
    }
    
    func startTimer(_ time: TimeInterval) {
        if isOn == false {
            timeRemaining = time
        } else {
            DispatchQueue.main.async {
                self.secondTicked()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
                    self.secondTicked()
                })
            }
        }
    }
    
    func stopTimer() {
        if isOn == true {
            timeRemaining = 0
            timer?.invalidate()
            delegate?.timerStopped()
        }
    }
}
