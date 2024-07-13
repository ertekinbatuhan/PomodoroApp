import SwiftUI

struct Home: View {
    
    @EnvironmentObject var viewModel: PomodoroViewModel
    @State private var showHourSheet = false
    @State private var showMinuteSheet = false
    @State private var showSecondSheet = false
    
    var body: some View {
        VStack {
            
            Text("Pomodoro Timer").font(.title2.bold()).foregroundColor(.white)
            
            GeometryReader { geometry in
                VStack(spacing: 15) {
                    
                    ZStack {
                        Circle().fill(Color.white.opacity(0.03))
                            .padding(-40)
                        
                        Circle().trim(from: 0, to: viewModel.progress)
                            .stroke(Color.white.opacity(0.03), lineWidth: 80)
                        
                        Circle().fill(Color(.systemGray6))
                        
                        Circle().trim(from: 0, to: viewModel.progress)
                            .stroke(Color(.systemRed).opacity(0.7), lineWidth: 10)
                        
                        GeometryReader { geometry in
                            let size = geometry.size
                            
                            Circle().fill(Color(.systemGray6))
                                .frame(width: 30, height: 30)
                                .frame(width: size.width, height: size.height, alignment: .center)
                                .offset(x: size.height / 2)
                                .rotationEffect(.init(degrees: viewModel.progress * 360))
                                .animation(.easeInOut, value: viewModel.progress)
                        }
                        
                        Text(viewModel.timerValue)
                            .foregroundColor(.blue)
                            .font(.system(size: 45, weight: .light))
                            .rotationEffect(.init(degrees: 90))
                            .animation(.easeInOut, value: viewModel.progress)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                    }.padding(60)
                        .frame(width: geometry.size.width)
                        .rotationEffect(.init(degrees: -90))
                        .animation(.easeInOut, value: viewModel.progress)
                    
                    Button {
                        if viewModel.isStarted {
                            viewModel.stopTimer()
                          
                        } else {
                            viewModel.addNewTimer = true
                          
                        }
                    } label: {
                        Image(systemName: !viewModel.isStarted ? "timer" : "pause")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background {
                                Circle().fill(Color.red)
                            }
                            .shadow(color: .red, radius: 8, x: 0, y: 0)
                    }
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
        }
        .padding()
        .background(Color(.systemGray6).ignoresSafeArea())
        .overlay(content: {
            ZStack {
                Color.black.opacity(viewModel.addNewTimer ? 0.25 : 0)
                    .onTapGesture {
                        viewModel.model = PomodoroModel()
                        viewModel.addNewTimer = false
                    }
                
                NewTimerView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: viewModel.addNewTimer ? 0 : 400)
                
            }.animation(.easeInOut, value: viewModel.addNewTimer)
        })
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
         
            if viewModel.isStarted {
                viewModel.updateTimer()
            }
        }
    }
    
    @ViewBuilder
    func NewTimerView() -> some View {
        VStack(spacing: 15) {
            Text("Add New Timer").font(.title2.bold()).foregroundColor(.white).padding(.top, 10)
            
            HStack(spacing: 15) {
                
                Text("\(viewModel.model.hours) hr")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule().fill(Color.white.opacity(0.07))
                    }
                    .onTapGesture {
                        showHourSheet = true
                    }
                    .actionSheet(isPresented: $showHourSheet) {
                        ActionSheet(title: Text("Select Hours"), buttons: actionSheetOptions(maxValue: 12, hint: "hr") { value in
                            viewModel.model.hours = value
                        })
                    }
                
                Text("\(viewModel.model.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule().fill(Color.white.opacity(0.07))
                    }
                    .onTapGesture {
                        showMinuteSheet = true
                    }
                    .actionSheet(isPresented: $showMinuteSheet) {
                        ActionSheet(title: Text("Select Minutes"), buttons: actionSheetOptions(maxValue: 60, hint: "min") { value in
                            viewModel.model.minutes = value
                        })
                    }
                
                Text("\(viewModel.model.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background {
                        Capsule().fill(Color.white.opacity(0.07))
                    }
                    .onTapGesture {
                        showSecondSheet = true
                    }
                    .actionSheet(isPresented: $showSecondSheet) {
                        ActionSheet(title: Text("Select Seconds"), buttons: actionSheetOptions(maxValue: 60, hint: "sec") { value in
                            viewModel.model.seconds = value
                        })
                    }
            }
            .padding(.top, 20)
            
            Button {
               
                viewModel.startTimer()
                
            } label: {
                Text("Save")
                    .font(.title3).fontWeight(.semibold).foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule().fill(Color.red)
                    }
            }
            .disabled(viewModel.model.seconds == 0)
            .opacity(viewModel.model.seconds == 0 ? 0.5 : 1)
            .padding(.top)
            
        }.padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.systemGray6)).ignoresSafeArea()
            }
    }
    
    func actionSheetOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = (0...maxValue).map { value in
            .default(Text("\(value) \(hint)")) {
                onClick(value)
            }
        }
        buttons.append(.cancel())
        return buttons
    }
}

#Preview {
    Home().environmentObject(PomodoroViewModel())
}

