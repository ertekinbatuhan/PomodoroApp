
//  Created by Batuhan Berk Ertekin on 13.07.2024.
//

import Foundation
import SwiftUI

class PomodoroViewModel: ObservableObject {
    
    @Published var progress: CGFloat = 1
    @Published var timerValue: String = "00:00"
    @Published var isStarted: Bool = false
    @Published var addNewTimer: Bool = false
    @Published var model: PomodoroModel
    
    var timer: Timer? = nil
    
    init() {
        self.model = PomodoroModel()
        NotificationManager.shared 
    }
    
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isStarted = true
        }
        
        timerValue = "\(model.hours == 0 ? "" : "\(model.hours):")\(model.minutes >= 10 ? "\(model.minutes)" : "0\(model.minutes)"):\(model.seconds >= 10 ? "\(model.seconds)" : "0\(model.seconds)")"
        
        updateTotalSeconds()
        addNewTimer = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isStarted = false
        progress = 1
        timerValue = "00:00" 
        reset()
        
    }
    
    func updateTimer() {
        if model.totalSeconds > 0 {
            decrementTime()
            
            timerValue = "\(model.hours == 0 ? "" : "\(model.hours):")\(model.minutes >= 10 ? "\(model.minutes)" : "0\(model.minutes)"):\(model.seconds >= 10 ? "\(model.seconds)" : "0\(model.seconds)")"
            progress = CGFloat(model.totalSeconds) / CGFloat(model.staticTotalSeconds)
        } else {
            stopTimer()
            NotificationManager.shared.sendNotification()
        }
    }
    
    func updateTotalSeconds() {
        model.totalSeconds = (model.hours * 3600) + (model.minutes * 60) + model.seconds
        model.staticTotalSeconds = model.totalSeconds
    }
    
    func decrementTime() {
        model.totalSeconds -= 1
        model.hours = model.totalSeconds / 3600
        model.minutes = (model.totalSeconds / 60) % 60
        model.seconds = model.totalSeconds % 60
    }
    
    func reset() {
        model.hours = 0
        model.minutes = 0
        model.seconds = 0
        model.totalSeconds = 0
        model.staticTotalSeconds = 0
    }
    
}

