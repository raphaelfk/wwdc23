//
//  OnboardingView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 11/04/23.
//

import SwiftUI

// in this view, there will be an onboarding for the user to get familiar and learn about some organization concepts, that will also be used on the app afterwards
struct OnboardingView: View {
    @StateObject var appModel: AppModel
    @State var storyPart: Int = 0 // tracks the story part to control what will be displayed on the view
    @State var createTaskSheetOpen: Bool = false
    @State var continueButtonDisabled: Bool = false
    let animationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect() // timer for the "animations" that are displayed
    @State var animationCounter = 1
    @State var prioritAnimationName = "prioritizing-animation-1"
    @State var sliderAnimationName = "slider-animation-1"
    
    var body: some View {
        VStack {
            
            Spacer()
            // ------ content ------
            
            // parts 1 to 3
            if storyPart < 3 {
                // image
                if storyPart == 0 || storyPart == 2 {
                    Image("dog-happy-facing-right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .padding()
                } else {
                    Image("dog-still-facing-right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .padding()
                }
                
                // text
                if storyPart == 0 {
                    TextFrameView(text: "**Welcome!**\nI'm Cooper, and I'm a dog :P")
                } else if storyPart == 1 {
                    TextFrameView(text: "Throughout my life, I’ve always seen my humans struggle with organization.\nEspecially when it comes to task and time management.")
                } else if storyPart == 2 {
                    TextFrameView(text: "I’ve gathered some info I learned about the topic, so if you also need to organize some things, I think I can help you out!")
                }
                
                
            // part 4 - prioritization
            } else if storyPart < 5 {
                // text
                TextFrameView(text: "The first principle I’d like to share is **prioritization**.")
                
                // images
                HStack {
                    
                    Image(prioritAnimationName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 175)
                        .padding()
                        .onReceive(animationTimer) { _ in
                            withAnimation(.spring()) {
                                if animationCounter > 8 {
                                    animationCounter = 1
                                } else {
                                    if animationCounter < 5 {
                                        prioritAnimationName = "prioritizing-animation-\(animationCounter)"
                                        animationCounter += 1
                                    } else {
                                        prioritAnimationName = "prioritizing-animation-1"
                                        animationCounter += 1
                                    }
                                    
                                }
                            }
                            
                        }
                    
                    if storyPart > 3 {
                        Image("dog-still-facing-left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .padding()
                    } else {
                        Image("dog-paw-up-facing-left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .padding()
                    }
                    
                }
                
                if storyPart > 3 {
                    // text
                    TextFrameView(text: "It is really important to identify which tasks matter the most to you, right now, and concisely organize them.")
                }

            // parts 5 to 7 - time management
            } else if storyPart < 8 {
                // text
                TextFrameView(text: "Secondly, it is important to have good **time management**.")
                
                // images
                HStack {
                    if storyPart > 5 {
                        Image("dog-still-facing-right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .padding()
                    } else {
                        Image("dog-paw-up-facing-right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .padding()
                    }
                    
                    Image(sliderAnimationName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 175)
                        .padding()
                        .onAppear(){
                            sliderAnimationName = "slider-animation-1"
                            animationCounter = 1
                        }
                        .onReceive(animationTimer) { _ in
                            withAnimation(.spring()) {
                                if animationCounter > 8 {
                                    animationCounter = 1
                                } else {
                                    if animationCounter < 5 {
                                        sliderAnimationName = "slider-animation-\(animationCounter)"
                                        animationCounter += 1
                                    } else {
                                        sliderAnimationName = "slider-animation-1"
                                        animationCounter += 1
                                    }
                                    
                                }
                            }
                            
                        }
                    
                    
                }
                
                if storyPart > 5 {
                    // text
                    TextFrameView(text: "I know this is especially hard for humans to do, as they have a lot of obligations :P\n\nBut I made a system that can surely help you with this! I called it **PawTask**!")
                }
            }
            
            Spacer()
            
            // ------ buttons ------
            
            // back button
            HStack {
                if storyPart != 0 {
                    Button(action: {
                        let lightImpact = UIImpactFeedbackGenerator(style: .light)
                        lightImpact.impactOccurred()
                        
                        withAnimation(.spring()) {
                            if storyPart != 0 {
                                storyPart -= 1
                            }
                        }
                        
                    }) {
                        Text("Back")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.black)
                    }
                    .background(Color(red: 0.914, green: 0.914, blue: 0.914))
                    .cornerRadius(10)
                    .padding()
                }
                
                if storyPart == 8 || storyPart == 9 {
                    // add new task button
                    Button(action: {
                        let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
                        mediumImpact.impactOccurred()
                        
                        withAnimation(.spring()) {
                            createTaskSheetOpen.toggle()
                            if storyPart == 8 {
                                storyPart += 1
                                continueButtonDisabled = false
                            }
                        }
                    }) {
                        HStack {
                            Text("New Task")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(red: 1.014, green: 0.501, blue: 0.543))
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $createTaskSheetOpen) {
                        CreateTaskView(appModel: appModel, nextIndex: appModel.allTasks.count, showCancel: false, saveButtonDisabled: true)
                    }
                }
                
                // continue button
                Button(action: {
                    if storyPart != 8 {
                        let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
                        mediumImpact.impactOccurred()
                    }
                    
                    withAnimation(.spring()) {
                        storyPart += 1
                    }
                    
                    if storyPart == 7 { // end onboarding and enter tutorial
                        appModel.showOnboarding = false
                    }
                    
                    }) {
                        Text(storyPart == 6 ? "Let's go!" : "Continue")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(storyPart == 8 ? Color(red: 0.914, green: 0.914, blue: 0.914): Color(red: 1.014, green: 0.501, blue: 0.543))
                            .cornerRadius(10)
                            .padding()
                    }
                
            }
            
        }
        .sheet(isPresented: $createTaskSheetOpen) {
            CreateTaskView(appModel: appModel, nextIndex: appModel.allTasks.count)
        }
    }
}
