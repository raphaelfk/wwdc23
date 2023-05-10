//
//  AppModel.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 02/04/23.
//

import SwiftUI
import AVFoundation

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskName: String
    var taskDescrip: String
    var taskTime: Float = 0
    var taskCoins: Int
    var totalTaskTime: Float
    var taskDone: Bool = false
    var taskIndex: Int
    var breakSugestion: Bool = false
    var highlited: Bool = false
    var taskParts: [Int] = [0,0] // first number shows the current part, second shows total number or parts
    var inToday: Bool = false

    
    mutating func toogleDone() {
        taskDone.toggle()
        highlited.toggle()
    }
    
    mutating func setTaskName(_ taskName: String) {
        self.taskName = taskName
    }
    
    mutating func setTaskDescrip(_ taskDescrip: String) {
        self.taskDescrip = taskDescrip
    }
    
    mutating func setBreakSugestion(_ breakSugestion: Bool) {
        self.breakSugestion = breakSugestion
    }
    
    mutating func setHighlighted(_ highlighted: Bool) {
        self.highlited = highlighted
    }
    
    mutating func toogleHighlight() {
        self.highlited.toggle()
    }
    
    mutating func setTaskParts(taskParts: [Int]) {
        self.taskParts = taskParts
    }
    
    mutating func setTaskTime(taskTime: Float) {
        self.taskTime = taskTime
    }
    
    mutating func setTotalTaskTime(_ totalTaskTime: Float) {
        self.totalTaskTime = totalTaskTime
    }
    
    mutating func isInToday() {
        inToday = true
    }
    
    mutating func isNotInToday() {
        inToday = false
    }
    
    mutating func setTaskIndex(_ taskIndex: Int) {
        self.taskIndex = taskIndex
    }
}

enum ItemType {
    case hat, collar, clothes
}

struct Item: Identifiable {
    var id = UUID().uuidString
    var name: String
    var price: Int
    var image: Image = Image("")
    var owned: Bool = false
    var selected: Bool = false
    var itemNumber: Int
    var itemType: ItemType
}

class AppModel: ObservableObject {
    @Published var allTasks: [Task] = []
    
    var nTodayTasks = 0
    var nTodayCompletedTasks = 0
    @Published var congratulate: Bool = false
    @Published var sliderValue: Float = 0.0
    var todaysTime: Float = 0
    @Published var showOnboarding: Bool = true
    @Published var explanations: Bool = true
    @Published var explanationPart: Int = 0
    @Published var noClick: Bool = true
    @Published var blockLeftView: Bool = true
    @Published var blockRightView: Bool = false
    @Published var indicatePet: Bool = true
    
    // items
    @Published var userCoins: Int = 50
    @Published var hats: [Item] = [Item(name: "None", price: 0, owned: true, selected: true, itemNumber: 0, itemType: .hat),
                                   Item(name: "Cap", price: 45, image: Image("cap"), itemNumber: 1, itemType: .hat),
                                   Item(name: "Sorcerer hat", price: 95, image: Image("sorcerer-hat"), itemNumber: 2, itemType: .hat)]
    @Published var collars: [Item] = [Item(name: "None", price: 0, owned: true, selected: true, itemNumber: 0, itemType: .collar),
                                   Item(name: "Yellow", price: 30, image: Image("yellow-collar"), itemNumber: 1, itemType: .collar),
                                      Item(name: "White", price: 30, image: Image("white-collar"), itemNumber: 2, itemType: .collar),
                                      Item(name: "Red", price: 30, image: Image("red-collar"), itemNumber: 3, itemType: .collar)]

    
    // sounds
    var player: AVAudioPlayer!
    
    // functions related to items
    func selectHat(itemNumber: Int) {
        hats[itemNumber].selected = true
        for i in 0 ... hats.count - 1 {
            if i != itemNumber {
                hats[i].selected = false
            }
        }
    }
    
    func selectCollar(itemNumber: Int) {
        collars[itemNumber].selected = true
        for i in 0 ... collars.count - 1 {
            if i != itemNumber {
                collars[i].selected = false
            }
        }
    }
    
    func highlight(index: Int) {
        if allTasks[index].highlited {
            highlightFirst()
        } else {
            for i in 0 ... allTasks.count - 1 {
                if i != index {
                    allTasks[i].setHighlighted(false)
                }
            }
            allTasks[index].setHighlighted(true)
        }
    }
    
    // functions related to tasks
    func highlightFirst() {
        var highlited = false
        if allTasks.count > 0 {
            for i in 0 ... allTasks.count - 1 {
                allTasks[i].setBreakSugestion(false)
                if !allTasks[i].taskDone && allTasks[i].inToday && !highlited {
                    allTasks[i].setHighlighted(true)
                    highlited = true
                } else {
                    allTasks[i].setHighlighted(false)
                }
            }
        }
        
    }
    
    func updateIndexes() {
        // updating task indices
        var index = 0
        while index < allTasks.count {
            allTasks[index].setTaskIndex(index)
            index += 1
        }
    }
    
    func TaskDone(taskIndex: Int) {
        if allTasks[taskIndex].taskDone == false {
            playTune(tune: "done-sound", type: "m4a")
        }
            
        allTasks[taskIndex].toogleDone()
        userCoins += allTasks[taskIndex].taskCoins
        highlightFirst()
        nTodayCompletedTasks += 1
        
        if(allTasks[taskIndex].taskTime > 1) {
            allTasks[taskIndex].setBreakSugestion(true)
        }
        
        if(allTasks[taskIndex].taskParts[0] != 0 && allTasks[taskIndex].taskParts[0] == 1) {
            allTasks[taskIndex + 1].setTotalTaskTime(allTasks[taskIndex].totalTaskTime - allTasks[taskIndex].taskTime)
        }
        
        let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
            mediumImpact.impactOccurred()
    }
    
    func updateTodaysTasks() {
        // reseting tasks and removing separations
        var index = 0
        var nTasks = allTasks.count
        nTodayTasks = 0
        nTodayCompletedTasks = 0
        
        while index < nTasks {
            allTasks[index].isNotInToday()
            allTasks[index].setHighlighted(false)
            if allTasks[index].taskParts[0] != 0 {
                for _ in 0 ... allTasks[index].taskParts[1] - 2 {
                    allTasks.remove(at: index)
                    nTasks -= 1
                }
                allTasks[index].setTaskParts(taskParts: [0,0])
            } else {
                index += 1
            }
        }
        
        
        // setting today's tasks
        var remainingTime = todaysTime
        index = 0
        
        while(remainingTime > 0 && index < allTasks.count) {
            // if the task isn't completed
            if !allTasks[index].taskDone {
                // if the task can be entirely done today
                if allTasks[index].totalTaskTime <= remainingTime {
                    allTasks[index].isInToday()
                    nTodayTasks += 1
                    
                    allTasks[index].setTaskTime(taskTime: allTasks[index].totalTaskTime)
                    remainingTime -= allTasks[index].taskTime
                    index += 1
                    
                } else {
                    // adding first part of task
                    let originalTask = allTasks[index]
                    var newTask = Task(taskName: originalTask.taskName, taskDescrip: originalTask.taskDescrip, taskTime: remainingTime, taskCoins: originalTask.taskCoins / 2, totalTaskTime: originalTask.totalTaskTime, taskIndex: index, taskParts: [1,2], inToday: true)
                    
                    nTodayTasks += 1

                    allTasks.remove(at: index)
                    allTasks.insert(newTask, at: index)
                    
                    // adding second part of task
                    newTask = Task(taskName: originalTask.taskName, taskDescrip: originalTask.taskDescrip, taskTime: originalTask.totalTaskTime - remainingTime, taskCoins: originalTask.taskCoins / 2, totalTaskTime: originalTask.totalTaskTime, taskIndex: index + 1, taskParts: [2,2])

                    allTasks.insert(newTask, at: index + 1)
                    remainingTime = 0
                }
            } else {
                index += 1
            }
            
        }
        
        updateIndexes()
        
        highlightFirst()
        
        if explanations && todaysTime != 0 {
            explanationPart += 1
            blockRightView = false
            noClick = true
        }
    }
    
    // sound function
    func playTune(tune: String, type: String) {
        if let path = Bundle.main.path(forResource: tune, ofType: type) {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.play()
            } catch {
                print("ERROR")
            }
        }
    }
}
