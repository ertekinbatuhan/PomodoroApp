//
//  PomodoroModel.swift
//  Pomodoro
//
//  Created by Batuhan Berk Ertekin on 13.07.2024.
//

import Foundation

class PomodoroModel {
    var hours: Int
    var minutes: Int
    var seconds: Int
    var totalSeconds: Int
    var staticTotalSeconds: Int
    
    init(hours: Int = 0, minutes: Int = 0, seconds: Int = 0) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.totalSeconds = (hours * 3600) + (minutes * 60) + seconds
        self.staticTotalSeconds = self.totalSeconds
    }
}

