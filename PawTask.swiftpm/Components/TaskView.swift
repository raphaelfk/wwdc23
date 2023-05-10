//
//  TaskView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 08/04/23.
//

import SwiftUI

struct TaskView: View {
    var task: Task
    @State var appModel: AppModel
    @State var completeTask: Bool
    @Binding var editTaskSheetOpen: Bool
    @State var backgroundColor: Color = Color(red: 0.948, green: 0.953, blue: 0.979)
    @State var editing: Bool = false
    @State var showCoins: Bool = true
    @State var showSliderHandle: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                if completeTask {
                    // Timeline elements
                    VStack(spacing: 10) {
                        Button(action: {
                            withAnimation(.spring()) {
                                appModel.TaskDone(taskIndex: task.taskIndex)
                                if appModel.nTodayTasks == appModel.nTodayCompletedTasks {
                                    appModel.congratulate = true
                                }
                            }
                            
                            }) {
                                if self.appModel.allTasks[task.taskIndex].taskDone {
                                    RoundedRectangle(cornerRadius: 50)
                                        .foregroundColor(Color(red: 0.914, green: 0.914, blue: 0.914))
                                        .frame(width: 25, height: 25)
                                } else {
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(lineWidth: 3)
                                        .foregroundColor(Color(red: 1.014, green: 0.501, blue: 0.543))
                                        .frame(width: 25, height: 25)
                                }
                                

                            }
                            .padding(.horizontal, 3)
                            .padding(.top, 10)
                        
                        
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 3)
                            .foregroundColor(
                                self.appModel.allTasks[task.taskIndex].taskDone ? Color(red: 0.914, green: 0.914, blue: 0.914) : Color(red: 1.014, green: 0.501, blue: 0.543)
                                )

                    }
                }
                
                // Task
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                // task title
                                Text(task.taskName)
                                    .font(.body)
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .bold()
                                
                                // task count
                                if task.taskParts[0] != 0 {
                                    Text("\(task.taskParts[0]) / \(task.taskParts[1])")
                                        .font(.footnote)
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        .bold()
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 6)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                }
                                
                                Spacer()
                                
                                // task coins
                                if showCoins {
                                    if !task.taskDone {
                                        HStack {
                                            Image("coin")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 12, height: 12)
                                                .padding(.leading, 6)
                                            
                                            Text("\(task.taskCoins)")
                                                .font(.footnote)
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                .bold()
                                                .padding(.vertical, 2)
                                                .padding(.trailing, 6)
                                        }
                                        .background(Color(red: 1.0, green: 0.9, blue: 0.728))
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    }
                                }
                                
                                // task time or done status
                                // if task is not done, show time
                                if !task.taskDone {
                                    let hours = Int(task.taskTime)
                                    let minutes = Int(task.taskTime.truncatingRemainder(dividingBy: 1) * 60)
                                    
                                    // if it only has hours
                                    if minutes == 0 {
                                        Text("\(Int(task.taskTime))h")
                                            .font(.footnote)
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .bold()
                                            .padding(.vertical, 2)
                                            .padding(.horizontal, 6)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        
                                    // if it has hours and minutes
                                    } else if hours != 0 && minutes != 0 {
                                        
                                        Text("\(Int(task.taskTime))h\(minutes)min")
                                            .font(.footnote)
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .bold()
                                            .padding(.vertical, 2)
                                            .padding(.horizontal, 6)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        
                                    // if it only has minutes
                                    } else {
                                        Text("\(minutes)min")
                                            .font(.footnote)
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                            .bold()
                                            .padding(.vertical, 2)
                                            .padding(.horizontal, 6)
                                            .background(Color.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    }
                                    
                                // if task is done, show done
                                } else {
                                    Text("Done!")
                                        .font(.footnote)
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        .bold()
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 6)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                appModel.allTasks[task.taskIndex].toogleDone()
                                            }
                                        }
                                }
                                
                            }

                            // task description
                            if !appModel.allTasks[task.taskIndex].taskDone {
                                if task.taskDescrip != "" {
                                    Text(task.taskDescrip)
                                        .font(.subheadline)
                                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                }
                            }
                            
                            // done button
                            if completeTask && appModel.allTasks[task.taskIndex].highlited && !appModel.allTasks[task.taskIndex].taskDone {
                                
                                // done button
                                Button(action: {
                                    withAnimation(.spring()) {
                                        appModel.TaskDone(taskIndex: task.taskIndex)
                                        
                                        if appModel.nTodayTasks == appModel.nTodayCompletedTasks {
                                            appModel.congratulate = true
                                        }
                                        
                                    }
                                    
                                    }) {
                                        Text("Done")
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .padding()
                                            .foregroundColor(.white)
                                    }
                                    .background(Color(red: 1.014, green: 0.501, blue: 0.543))
                                    .cornerRadius(15)
                            }
                            
                        }
                        .padding(25)
                        
                        if showSliderHandle {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(Color("Text"))
                                .padding()
                        }
                    }
                    
                    
                    // background
                    .background {
                        Rectangle()
                            .foregroundColor(appModel.allTasks[task.taskIndex].taskDone ? Color(red: 0.914, green: 0.914, blue: 0.914) : backgroundColor)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                    // break sugestions
                    if completeTask && appModel.allTasks[task.taskIndex].taskDone && appModel.allTasks[task.taskIndex].breakSugestion {
                        VStack {
                            HStack {
                                Text("Remember to always take some breaks between long tasks!")
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                VStack {
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            self.appModel.allTasks[task.taskIndex].setBreakSugestion(false)
                                        }
                                        
                                        }) {
                                            Image(systemName: "x.circle.fill")
                                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                                .padding()
                                        }
                                    
                                    Spacer()
                                }
                                
                            }
                        }
                        .padding()
                        .background {
                            Rectangle()
                                .foregroundColor(Color(red: 0.864, green: 0.959, blue: 0.876))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        
                    }
                }
                
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    if editing {
                        editTaskSheetOpen = true
                    }
                    if completeTask {
                        appModel.highlight(index: task.taskIndex)
                    }
                    
                }
            }
        }
    }
}
