import SwiftUI

@main
struct PomodoroApp: App {
    
    @StateObject var viewModel: PomodoroViewModel = .init()
    @Environment(\.scenePhase) var phase
    @State var backgroundTaskId: UIBackgroundTaskIdentifier?
    @State var lastActiveTime: Date = Date()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
            case .active:
                if let backgroundTaskID = backgroundTaskId {
                    UIApplication.shared.endBackgroundTask(backgroundTaskID)
                    self.backgroundTaskId = UIBackgroundTaskIdentifier.invalid
                }
                
                let currentTime = Date().timeIntervalSince(lastActiveTime)
                if viewModel.isStarted && viewModel.model.totalSeconds - Int(currentTime) <= 0 {
                    viewModel.stopTimer()
                }
                
            case .background:
                backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "PomodoroBackgroundTask") {
                    if let backgroundTaskId = self.backgroundTaskId {
                        UIApplication.shared.endBackgroundTask(backgroundTaskId)
                        self.backgroundTaskId = UIBackgroundTaskIdentifier.invalid
                    }
                }
                
                lastActiveTime = Date()
                
            default:
                break
            }
        }
    }
}

