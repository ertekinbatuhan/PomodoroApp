//
//  ContentView.swift
//  Pomodoro
//
//  Created by Batuhan Berk Ertekin on 12.07.2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel : PomodoroViewModel
    
    var body: some View {
        
        Home().environmentObject(viewModel)
    }
}

#Preview {
    ContentView().environmentObject(PomodoroViewModel())
}
