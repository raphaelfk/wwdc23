//
//  TodayView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 02/04/23.
//

import SwiftUI

struct TodayView: View {
    @StateObject var appModel: AppModel
    @State var remainingTime: Float = 0.0
    @State var alertOpen: Bool = false
    @State var sliderOpen: Bool = false
    @State var showOnboarding: Bool = true
    @State var petImage: String = "dog-still-facing-left"
    let petTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var petImageCounter: Int = 0
    @State var petSheetOpen: Bool = false
    @State var coinsSheetOpen: Bool = false
    @State var editSheetOpen: Bool = false

    
    var body: some View {
        
        ZStack {
            // ------ page content ------
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(
                            Date.now,
                            format: Date.FormatStyle()
                                .day(.defaultDigits)
                                .month(.wide)
                                .year()
                        )
                        Text("Today")
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding()
                    
                    Spacer()
                    
                        
                }
                
                if appModel.explanationPart != 2 {
                    // time available
                    TimeAvailableView(appModel: appModel, sliderOpen: $sliderOpen)
                    
                    // slider
                    if sliderOpen || appModel.nTodayTasks == 0 {
                        SliderView(appModel: appModel, sliderOpen: $sliderOpen, alertOpen: $alertOpen, showButton: true)
                            .onAppear() {
                                appModel.congratulate = false
                                alertOpen = false
                            }
                    }
                }
                
                
                // remaining tasks alert
                if alertOpen {
                    VStack {
                        VStack {
                            HStack {
                                Text("Looks like you haven't finished all of your tasks from before, so they were automatically moved to today ;)")
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        alertOpen.toggle()
                                    }
                                    
                                    }) {
                                        Image(systemName: "x.circle")
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    }
                                
                            }
                        
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.995, green: 0.886, blue: 0.897))
                                
                        }
                    }.padding(.horizontal)
                        .padding(.top)
                }
                
                if appModel.congratulate {
                    VStack {
                        VStack {
                            HStack {
                                Text("Congrats! You've finished all of the tasks you planned! :)")
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        appModel.congratulate.toggle()
                                    }
                                    
                                    }) {
                                        Image(systemName: "x.circle")
                                            .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    }
                                
                            }
                        
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.995, green: 0.886, blue: 0.897))
                                
                        }
                    }.padding(.horizontal)
                        .padding(.top)
                }
                
                Spacer()
                
                // tasks
                ScrollView {
                    
                    LazyVStack(spacing: 7.5) {
                        ForEach(appModel.allTasks) { task in
                            if task.inToday {
                                TaskView(task: task, appModel: appModel, completeTask: true, editTaskSheetOpen: $editSheetOpen)
                            }
                        }
                    }

                } .padding()
                
                

            }
            
            // pet
            HStack(alignment: .top) {
                Spacer()
                
                if appModel.indicatePet && !appModel.explanations {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(red: 1.014, green: 0.501, blue: 0.543))
                        .frame(width: 40, height: 40)
                        .padding(.top, 35)
                }
                
                VStack(alignment: .trailing) {
                    VStack {
                        // cooper
                        ZStack {
                            Image(petImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding()
                                .onReceive(petTimer) { _ in
                                    if 7 < petImageCounter && petImageCounter < 12 {
                                        petImage = "dog-sleeping-facing-left"
                                        petImageCounter += 1
                                    }
                                    else if (petImage == "dog-still-facing-left" || petImageCounter == 0) && petImageCounter % 4 == 0 {
                                        petImage = "dog-still-facing-left-blinking"
                                        petImageCounter += 1
                                    } else if petImage == "dog-still-facing-left-blinking" {
                                        petImage = "dog-still-facing-left"
                                        petImageCounter += 1
                                    } else {
                                        if petImageCounter >= 12 {
                                            petImageCounter = 0
                                        } else {
                                            petImageCounter += 1
                                        }
                                        
                                    }
                            }
                            
                            // adding hat
                            ForEach(appModel.hats) { hat in
                                if hat.selected {
                                    hat.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .padding()
                                }
                            }
                            
                            // adding collar
                            ForEach(appModel.collars) { collar in
                                if collar.selected {
                                    collar.image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .padding()
                                }
                            }
                        }
                    }
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 0.995, green: 0.886, blue: 0.897))
                        }
                        .onTapGesture {
                            petSheetOpen.toggle()
                        }
                        .sheet(isPresented: $petSheetOpen) {
                            PetView(appModel: appModel)
                        }
                    
                    
                    HStack {
                        Image("coin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.leading, 5)
                        
                        
                        Text("\(appModel.userCoins)")
                            .font(.subheadline)
                            .bold()
                            .padding(.vertical, 6)
                            .padding(.trailing, 7.5)
                    }.foregroundColor(Color.black)
                        .background(Color(red: 1.0, green: 0.9, blue: 0.728))
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                petSheetOpen.toggle()
                            }
                        }
                    
                    
                    Spacer()
                }.padding()
            }
            
            // ------ explanation ------
            if appModel.explanations {
                ZStack {
                    Rectangle()
                        .background(Color("Background"))
                        .opacity(0.2)
                        .ignoresSafeArea(edges: .top)
                        .onTapGesture {
                            
                        }
                    
                    if appModel.allTasks.count == 0 {
                        VStack {
                            Spacer()
                            
                            TextFrameView(text: "First, you human need to add some tasks. Let's change to the tasks view!")
                            
                            HStack {
                                Spacer()
                                
                                Image(systemName: "arrow.down")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.size.width/2, height: 50)
                                    .padding(.leading)
                                    .padding(.vertical)
                            }
                            
                        }
                    } else if appModel.explanationPart == 2 {
                        VStack {
                            VStack{
                                // heading
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(
                                            Date.now,
                                            format: Date.FormatStyle()
                                                .day(.defaultDigits)
                                                .month(.wide)
                                                .year()
                                        )
                                        Text("Today")
                                            .font(.largeTitle)
                                            .bold()
                                    }
                                    .padding()
                                    
                                    Spacer()
                                    
                                        
                                }
                                
                                VStack{
                                    // time available
                                    TimeAvailableView(appModel: appModel, sliderOpen: $sliderOpen)
                                    
                                    // slider
                                    if sliderOpen || appModel.nTodayTasks == 0 {
                                        SliderView(appModel: appModel, sliderOpen: $sliderOpen, alertOpen: $alertOpen, showButton: true)
                                            .onAppear() {
                                                sliderOpen = true
                                                appModel.congratulate = false
                                                alertOpen = false
                                            }
                                    }
                                }
                                .padding(.top)
                                .background(Color("Background"))
                                .cornerRadius(20)
                                
                                Image(systemName: "arrow.up")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .padding(.leading)
                                    .padding(.vertical)
                                
                            }
                            
                            
                            Spacer()
                            
                            TextFrameView(text: "Try adjusting the slider for the time you might have today and press \"Plan my day\"!")
                        }
                    } else {
                        // text
                        VStack {
                            TextFrameView(text: "Now my system has planned what tasks you'll be able to do today, and I will let you explore it all for yourself!\n\nWe've learned more about how to have better organization skills, and I hope this app can help you have more peace of mind each day!\n\nKnow that I will always be right here to cheer you up, and to help you complete all of your tasks!\n\n🧡\n\n(Bonus tip: try tapping on me for some fun stuff!)")
                            
                            Button(action: {
                                appModel.explanations = false
                                appModel.blockRightView = false
                                appModel.blockLeftView = false
                                appModel.noClick = false
                                }) {
                                    Text("Complete")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color(red: 1.014, green: 0.501, blue: 0.543))
                                        .cornerRadius(10)
                                        .padding()
                                }
                        }
                    }
                    
                    
                }
            }
            
        }
        .fullScreenCover(isPresented: $appModel.showOnboarding, content: {
            OnboardingView(appModel: appModel)
        })
        
    }
        
}
