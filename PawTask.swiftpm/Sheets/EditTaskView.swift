//
//  EditTaskView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 08/04/23.
//

import SwiftUI

struct EditTaskView: View {
    @StateObject var appModel: AppModel
    @State var taskName: String = ""
    @State var taskDescrip: String = ""
    @State var sliderValue: Float = 0
    @State var totalTaskTime: Float = 0.25
    @State var taskIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Text("Edit Task")
                    .multilineTextAlignment(.center)
                    .bold()
                
                Spacer()
                
                Button("Save") {
                    
                    appModel.allTasks[taskIndex].setTaskName(taskName)
                    appModel.allTasks[taskIndex].setTaskDescrip(taskDescrip)
                    appModel.allTasks[taskIndex].setTaskTime(taskTime: totalTaskTime)
                    appModel.allTasks[taskIndex].setTotalTaskTime(totalTaskTime)
                    
                    dismiss()
                }
                
            } .padding()
                .onAppear {
                    taskName = appModel.allTasks[taskIndex].taskName
                    taskDescrip = appModel.allTasks[taskIndex].taskDescrip
                    totalTaskTime = appModel.allTasks[taskIndex].totalTaskTime
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
                                        TextField("Enter task name", text: $taskName)
                                            .frame(height: 50)
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .padding(.horizontal)
                                        
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
                                            
                                        }                                    }
                                    
                                    
                                )
            } .padding()
            
                
            // task description input
            VStack (alignment: .leading) {
                Text("TASK DESCRIPTION:")
                    .font(.footnote)
                    .foregroundColor(Color("Text"))
                    .bold()
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                
                RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.914, green: 0.914, blue: 0.914))
                                .frame(height: 80)
                                .overlay(
                                    ZStack {
                                        HStack {
                                            TextField("Enter description", text: $taskDescrip, axis: .vertical)
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                .lineLimit(5)
                                                .padding(.horizontal)
                                            .frame(height: 80)
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
                        } else if sliderValue == 1 {
                            totalTaskTime = 0.5
                        } else if sliderValue == 2 {
                            totalTaskTime = 0.75
                        } else if sliderValue == 3 {
                            totalTaskTime = 1
                        } else if sliderValue == 4 {
                            totalTaskTime = 1.25
                        } else if sliderValue == 5 {
                            totalTaskTime = 1.5
                        } else if sliderValue == 6 {
                            totalTaskTime = 1.75
                        } else if sliderValue == 7 {
                            totalTaskTime = 2
                        } else if sliderValue == 8 {
                            totalTaskTime = 2.5
                        } else {
                            totalTaskTime = 3
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
            
            HStack (alignment: .center) {
                Spacer()
                
                Image(systemName: "trash.circle")
                    .resizable()
                    .foregroundColor(Color(red: 1.014, green: 0.501, blue: 0.543))
                    .padding()
                    .frame(width: 75, height: 75)
                    .onTapGesture {
                        appModel.allTasks.remove(at: taskIndex)
                        appModel.updateIndexes()
                        dismiss()
                    }
                
                Spacer()
            }
            
            
            Spacer()
        }
    }
}
