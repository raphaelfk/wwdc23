//
//  TasksView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 02/04/23.
//

import SwiftUI

struct TasksView: View {
    @StateObject var appModel: AppModel
    @State var sliderValue: Float = 0.0
    @State var createTaskSheetOpen: Bool = false
    @State var editTaskSheetOpen: Bool = false
    @State var editing: Bool = false
    @State var editButtonText: String = "Edit"
    @State var currentIndex: Int = 0
    @State var editReplacer = false
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading) {
                // ------ header and edit button ------
                HStack {
                    // header and date
                    VStack(alignment: .leading) {
                        Text(
                            Date.now,
                            format: Date.FormatStyle()
                                .day(.defaultDigits)
                                .month(.wide)
                                .year()
                        )
                        Text("All Tasks")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Spacer()
                    
                    
                    // edit button
                    Button(editButtonText) {
                        withAnimation(.spring()) {
                            editing.toggle()
                            appModel.todaysTime = 0
                            appModel.updateTodaysTasks()
                        }
                        
                        if editing {
                            editButtonText = "Done"
                        } else {
                            editButtonText = "Edit"
                        }
                        
                        
                    }
                    
                } .padding()
                
                
                // ------ tasks ------
                if editing {
                    // if editing, collapse all split tasks into one and show only essential information
                    if !appModel.explanations {
                        List {
                            ForEach(appModel.allTasks) { task in
                                TaskView(task: task, appModel: appModel, completeTask: false, editTaskSheetOpen: $editTaskSheetOpen, editing: true, showSliderHandle: true)
                                    .id(task.id)
                            }
                            .onMove { (indexSet, index) in
                                appModel.allTasks.move(fromOffsets: indexSet, toOffset: index)
                                appModel.updateIndexes()
                            }
                            .sheet(isPresented: $editTaskSheetOpen) {
                                EditTaskView(appModel: appModel, taskIndex: currentIndex)
                            }
                            
                            
                        }
                        .listStyle(PlainListStyle())
                    } else {
                        Spacer()
                    }
                    
                } else {
                    // show all tasks in full detail
                    ScrollView {
                        LazyVStack {
                            if appModel.allTasks.count != 0 {
                                ForEach((0...appModel.allTasks.count-1), id: \.self) { i in
                                    let opacity: Double = 1.0 - (1.0 / Double(appModel.allTasks.count + 1)  * Double(i + 1))
                                    TaskView(task: appModel.allTasks[i], appModel: appModel, completeTask: true, editTaskSheetOpen: $editTaskSheetOpen, backgroundColor: Color(red: 0.995, green: 0.886, blue: 0.897).opacity(opacity))
                                }
                            }
                            
                        }
                    } .padding(.horizontal)
                }
            }
                // add task button
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    if !appModel.explanations && !editing { // only show button after the tutorial and when not editing
                        Button(action: {
                            withAnimation(.spring()) {
                                createTaskSheetOpen.toggle()
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.headline)
                                .padding()
                                .foregroundColor(.white)
                        }
                        .background(Color(red: 1.014, green: 0.501, blue: 0.543))
                        .cornerRadius(10)
                        .padding()
                        .sheet(isPresented: $createTaskSheetOpen) {
                            CreateTaskView(appModel: appModel, nextIndex: appModel.allTasks.count)
                        }
                    }
                    
                }
            
            // ------ tutorial ------
            if appModel.explanations {
                ZStack(alignment: .top) {
                    Rectangle()
                        .background(Color("Background"))
                        .opacity(0.2)
                        .ignoresSafeArea(edges: .top)
                        .onTapGesture {}
                
                
                    if appModel.allTasks.count < 2 {
                        VStack {
                            Spacer()
                            
                            TextFrameView(text: appModel.allTasks.count == 1 ? "Add just another one, before continuing!" : "Hit the \"**+**\" button and try adding two tasks.\n\nAlso, remember to set a time estimate for each one!")
                        }
                        .safeAreaInset(edge: .bottom, alignment: .trailing) {
                            HStack {
                                // indicative arrow
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .padding(.leading)
                                    .padding(.vertical)
                                
                                // add task button
                                Button(action: {
                                    withAnimation(.spring()) {
                                        createTaskSheetOpen.toggle()
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(.white)
                                }
                                .background(Color(red: 1.014, green: 0.501, blue: 0.543))
                                .cornerRadius(10)
                                .padding()
                                .sheet(isPresented: $createTaskSheetOpen) {
                                    CreateTaskView(appModel: appModel, nextIndex: appModel.allTasks.count)
                                }
                                .onAppear() {
                                    appModel.blockRightView = false
                                    appModel.blockLeftView = false
                                    appModel.noClick = true
                                }
                            }
                            
                            
                            
                        }
                        
                        
                    } else if appModel.explanationPart == 0 {
                        VStack() {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(
                                        Date.now,
                                        format: Date.FormatStyle()
                                            .day(.defaultDigits)
                                            .month(.wide)
                                            .year()
                                    )
                                    Text("All Tasks")
                                        .font(.largeTitle)
                                        .bold()
                                }
                                
                                Spacer()
                                
                                Button(editButtonText) {
                                    withAnimation(.spring()) {
                                        editing.toggle()
                                        appModel.todaysTime = 0
                                        appModel.updateTodaysTasks()
                                        appModel.explanationPart += 1
                                    }
                                    
                                    if editing {
                                        editButtonText = "Done"
                                    } else {
                                        editButtonText = "Edit"
                                    }
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                            }
                            .padding()
                            
                            // indicative arrow
                            HStack {
                                Spacer()
                                
                                Image(systemName: "arrow.up")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .padding(.horizontal)
                            }
                            
                            
                            Spacer()
                            
                            TextFrameView(text: "The tasks are colored based on priority. The highest the priority, the redder they are!\nLets change their order by clicking the \"**Edit**\" button.")
                            
                        }
                    } else if appModel.explanationPart == 1 {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(
                                        Date.now,
                                        format: Date.FormatStyle()
                                            .day(.defaultDigits)
                                            .month(.wide)
                                            .year()
                                    )
                                    Text("All Tasks")
                                        .font(.largeTitle)
                                        .bold()
                                }
                                
                                Spacer()
                                
                                Button(editButtonText) {
                                    withAnimation(.spring()) {
                                        editing.toggle()
                                        appModel.todaysTime = 0
                                        appModel.updateTodaysTasks()
                                        appModel.explanationPart += 1
                                        appModel.noClick = false
                                        appModel.blockRightView = true
                                    }
                                    
                                    if editing {
                                        editButtonText = "Done"
                                    } else {
                                        editButtonText = "Edit"
                                    }
                                }
                                .padding()
                                .background(.white)
                                .cornerRadius(10)
                            }
                            .padding()
                            
                            Spacer()
                            
                            List {
                                ForEach(appModel.allTasks) { task in
                                    TaskView(task: task, appModel: appModel, completeTask: false, editTaskSheetOpen: $editReplacer, editing: true, showSliderHandle: true)
                                        .id(task.id)
                                }
                                .onMove { (indexSet, index) in
                                    appModel.allTasks.move(fromOffsets: indexSet, toOffset: index)
                                    appModel.updateIndexes()
                                }
                                .sheet(isPresented: $editTaskSheetOpen) {
                                    EditTaskView(appModel: appModel, taskIndex: currentIndex)
                                }
                                
                                
                            }
                            .listStyle(PlainListStyle())
                            
                            Spacer()
                            
                            TextFrameView(text: "Try pressing, holding and dragging a task, and repositioning it!\nClick \"**Done**\" when finished.")
                        }
                        
                    } else {
                        VStack {
                            Spacer()
                            
                            TextFrameView(text: "Now we can return to our \"**Today**\" page, to really plan our day!")
                            
                            HStack {
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.size.width/2, height: 50)
                                    .padding(.trailing)
                                    .padding(.vertical)
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
}

