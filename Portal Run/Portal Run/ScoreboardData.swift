//
//  ScoreboardData.swift
//  Portal Run
//
//  Created by Phat Pham on 12/6/16.
//  Copyright © 2016 Portal Run Team. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class ScoreboardData: NSObject {
    
    /** Provides the score of the current game session. */
    private var _currentScore: Int
    var currentScore: Int {
        get {
            return _currentScore
        }
    }
    
    /** The timer for the current game session. */
    private var timer: Timer!
    
    /** Provides information on the amount of time that has elapsed within the current game session. */
    private var _timeElapsed: Double
    var timeElapsed: Double {
        get {
            return _timeElapsed
        }
    }
    
    /** The high score of the user */
    static var highScore: Int {
        get {
            if ScoreboardData.topScores.count > 0 {
                return ScoreboardData.topScores.max()!
            } else {
                return 0
            }
        }
    }
    
    /** Stores the top scores */
    private static var _topScores: [Int] = []
    static var topScores: [Int] {
        get {
            return _topScores.sorted()
        }
    }
    
    /** An array of top scores that listed in descending order */
    static var topScoresDescending: [Int] {
        get {
            return _topScores.sorted() { $0 > $1 }
        }
    }
    
    /** Initializes the game data. Ideally, there should be a ScoreboardData instance for every game session played. */
    override init() {
        self._currentScore = 0
        self._timeElapsed = 0
        super.init()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.updateTimeStatus(timer:))
    }
    
    /** Updates the score of the current game session to the desired amount. */
    func updateScore(to score: Int) {
        self._currentScore = score
    }
    
    /** Increment the score of the current game session by one. */
    func incrementScoreByOne() {
        self._currentScore += 1
    }
    
    /** Updates the top scores if necessary with the selected score and indicates whether it succeeds. */
    static func updateTopScore(score: Int) -> Bool {
        if ScoreboardData.topScores.count < 10 {
            _topScores.append(score)
            return true
        }
        for topScore in ScoreboardData.topScores {
            if topScore == score {
                return false
            }
        }
        let minimumScoreOnBoard = ScoreboardData.topScores.min()!
        if score > minimumScoreOnBoard  {
            _topScores.remove(at: ScoreboardData.topScores.index(of: minimumScoreOnBoard)!)
            _topScores.append(score)
            return true
        }
        return false
    }
    
    @objc func updateTimeStatus(timer: Timer) {
        self._timeElapsed += 1
        print("Amount of Time That Has Elapsed in the Current Game Session: \(self.timeElapsed)")
    }
    
    /** Stops the ScoreboardData#timer */
    func stopTimer() {
        timer.invalidate()
    }
    
    /** Resumes the ScoreboardData#timer */
    func resumeTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.updateTimeStatus(timer:))
    }
    
    /** Resets the ScoreboardData#timer */
    func resetTimer() {
        self._timeElapsed = 0
        stopTimer()
    }
}
