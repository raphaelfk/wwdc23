//
//  CreateTaskView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 08/04/23.
//

import SwiftUI

struct CreateTaskView: View {
    @StateObject var appModel: AppModel
    @State var taskName: String = ""
    @State var taskDescrip: String = ""
    @State var sliderValue: Float = 0
    @State var totalTaskTime: Float = 0.25
    @State var taskCoins: Int = 1
    @State var nextIndex: Int
    @State var showCancel: Bool = true
    @State var saveButtonDisabled: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack (alignment: .leading) {
            
            // top bar
            ZStack {
                HStack {
                    if showCancel {
                        // cancel button
                        Button("Cancel") {
                            dismiss()
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // save button
                    Button(action: {
                        appModel.allTasks.append(Task(taskName: taskName, taskDescrip: taskDescrip, taskTime: totalTaskTime, taskCoins: taskCoins, totalTaskTime: totalTaskTime, taskIndex: nextIndex))
                        dismiss()
                        
                    }) {
                        Text("Save")
                            .foregroundColor(saveButtonDisabled ? Color(red: 0.914, green: 0.914, blue: 0.914) : Color(red: 1.014, green: 0.501, blue: 0.543))
                    }
                    .padding()
                    .disabled(saveButtonDisabled)
                    
                }
                
                HStack {
                    Spacer()
                    
                    // title
                    Text("New Task")
                        .multilineTextAlignment(.center)
                        .bold()
                    
                    Spacer()
                }
                
                
                
                
            }
            
            // task name input
            VStack (alignment: .leading) {
                Text("TASK NAME:")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color("Text"))
                
                RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.914, green: 0.914, blue: 0.914))
                                .frame(height: 50)
                                .overlay(
                                    ZStack {
                                        HStack {
                                            TextField("Enter task name", text: $taskName)
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                .frame(height: 50)
                                                .padding(.horizontal)
                                        }.padding(.trailing)
                                        
                                        
                                        HStack {
                                            Spacer()
                                            if taskName != "" {
                                                Image(systemName: "x.circle")
                                                    .foregroundColor(.white)
                                                    .padding(.trailing)
                                                    .onTapGesture() {
                                                        taskName = ""
                                                    }
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                )
            } .padding()
                .onTapGesture {
                    saveButtonDisabled = false
                }
                .onAppear() {
                    if appModel.explanations && appModel.allTasks.count == 0 {
                        taskName = "This is a sample task"
                        taskDescrip = "Try adjusting the slider to set an estimate time for this task!"
                    } else if appModel.explanations && appModel.allTasks.count == 1 {
                        taskName = "This is another sample task"
                        taskDescrip = "You already know what to do!"
                    }
                }
            
                
            // task description input
            VStack (alignment: .leading) {
                Text("TASK DESCRIPTION:")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(Color("Text"))
                
                RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.914, green: 0.914, blue: 0.914))
                                .frame(height: 80)
                                .overlay(
                                    ZStack {
                                        HStack {
                                            TextField("Enter description (Optional)", text: $taskDescrip, axis: .vertical)
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                .frame(height: 80)
                                                .lineLimit(2)
                                            .padding(.horizontal)
                                        }.padding(.trailing)
                                        
                                        HStack {
                                            Spacer()
                                            if taskDescrip != "" {
                                                Image(systemName: "x.circle")
                                                    .foregroundColor(.white)
                                                    .padding(.trailing)
                                                    .onTapGesture() {
                                                        taskDescrip = ""
                                                    }
                                            }
                                            
                                        }
                                    }
                                    
                                        
                                )
            } .padding()
            
            
            HStack {
                // time
                let hours = Int(totalTaskTime)
                let minutes = Int(totalTaskTime.truncatingRemainder(dividingBy: 1) * 60)
                
                // if it only has hours
                HStack {
                    if minutes == 0 {
                        Text("Estimated Time: \(Int(totalTaskTime))h")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal)
                            
                        
                    // if it has hours and minutes
                    } else if hours != 0 && minutes != 0 {
                        
                        Text("Estimated Time: \(Int(totalTaskTime))h\(minutes)min")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal)
                        
                        
                        
                    // if it only has minutes
                    } else {
                        Text("Estimated Time: \(minutes)min")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.horizontal)

                        
                        
                    }
                }
                .foregroundColor(Color.white)
                .background(Color(red: 1.014, green: 0.501, blue: 0.543))
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                
            } .padding()
            
            VStack {
                // slider
                Slider(value: Binding(
                    get: {
                        self.sliderValue
                    }, set: {(updatedValue) in
                        self.sliderValue = updatedValue
                        if sliderValue == 0 {
                            totalTaskTime = 0.25
                            taskCoins = 1
                        } else if sliderValue == 1 {
                            totalTaskTime = 0.5
                            taskCoins = 2
                        } else if sliderValue == 2 {
                            totalTaskTime = 0.75
                            taskCoins = 3
                        } else if sliderValue == 3 {
                            totalTaskTime = 1
                            taskCoins = 5
                        } else if sliderValue == 4 {
                            totalTaskTime = 1.25
                            taskCoins = 6
                        } else if sliderValue == 5 {
                            totalTaskTime = 1.5
                            taskCoins = 7
                        } else if sliderValue == 6 {
                            totalTaskTime = 1.75
                            taskCoins = 8
                        } else if sliderValue == 7 {
                            totalTaskTime = 2
                            taskCoins = 10
                        } else if sliderValue == 8 {
                            totalTaskTime = 2.5
                            taskCoins = 12
                        } else {
                            totalTaskTime = 3
                            taskCoins = 15
                        }
                        
                    }), in: 0 ... 9, step: 1)
                .tint(Color(red: 1.014, green: 0.501, blue: 0.543))
                .padding(.horizontal)
                
                HStack {
                    Text("15min")
                        .padding(.horizontal)
                    Spacer()
                    Text("3h")
                        .padding(.horizontal)
                }
            } .padding(.horizontal)
            
            Spacer()
        }
    }
}
