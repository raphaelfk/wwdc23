//
//  PetView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 12/04/23.
//

import SwiftUI

struct PetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var appModel: AppModel
    @State var petImage: String = "dog-still-facing-left"
    let petTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var petImageCounter: Int = 0
    
    var body: some View {
        VStack (alignment: .leading) {
            ZStack {
                HStack {
                    Button("Return") {
                        dismiss()
                    }
                    
                    Spacer()
                }
                
                Text("Cooper")
                    .multilineTextAlignment(.center)
                    .bold()
                
                
            } .padding()
            
            HStack {
                Spacer()
                // cooper
                ZStack {
                    Image(petImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
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
                        .background(Color(red: 0.914, green: 0.914, blue: 0.914))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                    
                    // adding hat
                    ForEach(appModel.hats) { hat in
                        if hat.selected {
                            hat.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .padding()
                        }
                    }
                    
                    // adding collar
                    ForEach(appModel.collars) { collar in
                        if collar.selected {
                            collar.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .padding()
                        }
                    }
                }
                
                Spacer()
                
                // current coins
                HStack {
                    VStack {
                        Text("CURRENT COINS:")
                            .font(.footnote)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)

                        HStack {
                            Image("coin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(.bottom)
                            Text("\(appModel.userCoins)")
                                .bold()
                                .padding(.bottom)
                        }
                    }
                    
                }.foregroundColor(Color.black)
                .background(Color(red: 1.0, green: 0.9, blue: 0.728))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                Spacer()
            }
            
            
            
            ScrollView {
                // hats section
                VStack(alignment: .leading) {
                    Text("HATS:")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(appModel.hats) { hat in
                                ItemView(appModel: appModel, item: hat)
                            }
                        }
                    }
                    
                } .padding()
                
                // collar section
                VStack(alignment: .leading) {
                    Text("COLLARS:")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(appModel.collars) { collar in
                                ItemView(appModel: appModel, item: collar)
                            }
                        }
                    }
                    
                } .padding()
                
                // coins explanation
                Text("You can use coins to customize Cooper! You can earn more coins by completing your tasks!")
                    .font(.body)
                    .padding(25)
                    .multilineTextAlignment(.center)
                    .background {
                        Rectangle()
                            .foregroundColor(Color(red: 0.975, green: 0.884, blue: 0.77))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .padding()
            }
        }
        .onAppear() {
            withAnimation(.spring()) {
                appModel.indicatePet = false
            }
        }
    }
}

struct PetView_Previews: PreviewProvider {
    static var previews: some View {
        PetView(appModel: AppModel())
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        let appModel = AppModel()
        ItemView(appModel: appModel, item: appModel.hats[2])
    }
}

struct ItemView: View {
    var appModel: AppModel
    var item: Item
    @State var showBuyAlert: Bool = false
    @State var showUnableToBuyAlert: Bool = false
    var body: some View {
        VStack {
            ZStack{
                if item.selected {
                    Image("dog-still-facing-left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(item.selected ? Color(red: 0.995, green: 0.886, blue: 0.897) : Color(red: 0.914, green: 0.914, blue: 0.914))
                        }

                } else {
                    Image("dog-opaque-facing-left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(item.selected ? Color(red: 0.995, green: 0.886, blue: 0.897) : Color(red: 0.914, green: 0.914, blue: 0.914))
                        }

                }
                
                item.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding()
            }
            .alert("Not enough coins!", isPresented: $showUnableToBuyAlert, actions: {}, message: {
                Text("You do not have enough coins to buy this :(")
            })
            
            if item.owned {
                HStack {
                    Text("Owned")
                        .font(.footnote)
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                }
                .background(Color(red: 0.789, green: 0.926, blue: 0.807))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
            } else {
                HStack {
                    Image("coin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .padding(.leading, 7)
                    
                    Text("\(item.price)")
                        .font(.footnote)
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.trailing, 7)
                }
                .background(Color(red: 1.0, green: 0.9, blue: 0.728))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            
        }
        .alert("Buy item?", isPresented: $showBuyAlert, actions: {
            Button("Buy", role: .destructive, action: {
                appModel.userCoins -= item.price
                if item.itemType == .hat {
                    appModel.hats[item.itemNumber].owned = true
                    appModel.selectHat(itemNumber: item.itemNumber)
                } else if item.itemType == .collar {
                    appModel.collars[item.itemNumber].owned = true
                    appModel.selectCollar(itemNumber: item.itemNumber)
                }
            })
        }, message: {
            Text("Do you want to buy \(item.name) for \(item.price) coins?\nYou currently have \(appModel.userCoins) coins.")
        })
        
        .onTapGesture {
            if item.owned {
                withAnimation(.spring()) {
                    if item.itemType == .hat {
                        appModel.selectHat(itemNumber: item.itemNumber)
                    } else if item.itemType == .collar {
                        appModel.selectCollar(itemNumber: item.itemNumber)
                    }
                }
            } else {
                if item.price <= appModel.userCoins {
                    showBuyAlert = true
                } else {
                    showUnableToBuyAlert = true
                }
                
            }
            
            
        }
    }
}
