//
//  TimeAvailableView.swift
//  PawTask
//
//  Created by Raphael Ferezin Kitahara on 11/04/23.
//

import SwiftUI

struct TimeAvailableView: View {
    @StateObject var appModel: AppModel
    @Binding var sliderOpen: Bool
    
    var body: some View {
        HStack {
            // today's time
            let hours = Int(appModel.todaysTime)
            let minutes = Int(appModel.todaysTime.truncatingRemainder(dividingBy: 1) * 60)
            
            // if it only has hours
            HStack {
                if minutes == 0 {
                    Text("Time available: \(Int(appModel.todaysTime))h")
                        .font(.subheadline)
                        .bold()
                        .padding(.vertical, 6)
                        .padding(.leading, 15)
                        
                        
                    if sliderOpen {
                        Image(systemName: "arrowtriangle.up.circle.fill")
                            .padding(.trailing, 5)
                    } else {
                        Image(systemName: "arrowtriangle.down.circle.fill")
                            .padding(.trailing, 5)
                    }
                    
                // if it has hours and minutes
                } else if hours != 0 && minutes != 0 {
                    
                    Text("Time available: \(Int(appModel.todaysTime))h\(minutes)min")
                        .font(.subheadline)
                        .bold()
                        .padding(.vertical, 6)
                        .padding(.leading, 15)
                    
                    if sliderOpen {
                        Image(systemName: "arrowtriangle.up.circle.fill")
                            .padding(.trailing, 5)
                    } else {
                        Image(systemName: "arrowtriangle.down.circle.fill")
                            .padding(.trailing, 5)
                    }
                    
                // if it only has minutes
                } else {
                    Text("Time available: \(minutes)min")
                        .font(.subheadline)
                        .bold()
                        .padding(.vertical, 6)
                        .padding(.leading, 15)
                    
                    if sliderOpen {
                        Image(systemName: "arrowtriangle.up.circle.fill")
                            .padding(.trailing, 5)
                    } else {
                        Image(systemName: "arrowtriangle.down.circle.fill")
                            .padding(.trailing, 5)
                    }
                    
                }
            }
            .foregroundColor(Color.white)
            .background(Color(red: 1.014, green: 0.501, blue: 0.543))
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .onTapGesture {
                withAnimation(.spring()) {
                    sliderOpen.toggle()
                }
            }
            
            
            Spacer()
        } .padding(.horizontal)
    }
}
