//
//  SliderView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 11/04/23.
//

import SwiftUI

struct SliderView: View {
    @State var appModel: AppModel
    @Binding var sliderOpen: Bool
    @Binding var alertOpen: Bool
    @State var showButton: Bool
    
    var body: some View {
        VStack {
            // slider
            Slider(value: Binding(
                get: {
                    appModel.sliderValue
                }, set: {(updatedValue) in
                    appModel.sliderValue = updatedValue
                    if appModel.sliderValue == 0 {
                        appModel.todaysTime = 0
                    } else if appModel.sliderValue == 1 {
                        appModel.todaysTime = 0.25
                    } else if appModel.sliderValue == 2 {
                        appModel.todaysTime = 0.5
                    } else if appModel.sliderValue == 3 {
                        appModel.todaysTime = 0.75
                    } else if appModel.sliderValue == 4 {
                        appModel.todaysTime = 1
                    } else if appModel.sliderValue == 5 {
                        appModel.todaysTime = 1.5
                    } else if appModel.sliderValue == 6 {
                        appModel.todaysTime = 2
                    } else if appModel.sliderValue == 7 {
                        appModel.todaysTime = 2.5
                    } else if appModel.sliderValue == 8 {
                        appModel.todaysTime = 3
                    } else {
                        appModel.todaysTime = 5
                    }
                }), in: 0 ... 9, step: 1)
                    .tint(Color(red: 1.014, green: 0.501, blue: 0.543))
                    .padding(.horizontal)
                    .padding(.top)
            
            HStack {
                Text("0min")
                    .padding(.horizontal)
                Spacer()
                Text("5h")
                    .padding(.horizontal)
            }
            if showButton {
                Button(action: {
                    withAnimation(.spring()) {
                        sliderOpen.toggle()
                        if appModel.nTodayTasks > appModel.nTodayCompletedTasks {
                            alertOpen = true
                        }
                        appModel.updateTodaysTasks()
                    }
                    
                    }) {
                        Text("Plan my day")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                    }
                    .background(Color(red: 1.014, green: 0.501, blue: 0.543))
                    .cornerRadius(10)
                    .padding()
            }
            
        }
    }
}
