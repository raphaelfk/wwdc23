import SwiftUI

@main
struct MyApp: App {
    @StateObject var appModel = AppModel()
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView {
                    TodayView(appModel: appModel).tabItem {
                        Image(systemName: "house")
                        Text("Today") }.tag(1)
                    
                    TasksView(appModel: appModel).tabItem {
                        Image(systemName: "calendar")
                        Text("Tasks") }.tag(2)
                }
                .environmentObject(appModel)
                
    
                VStack{
                    Spacer()
                    
                    if appModel.blockLeftView {
                        HStack {
                            Rectangle()
                                .background(Color("Background"))
                                .opacity(0.2)
                                .ignoresSafeArea()
                                .frame(width: UIScreen.main.bounds.size.width/2, height: 50)
                                .onTapGesture {}
                            Spacer()
                        }
                        
                    } else if appModel.blockRightView {
                        HStack {
                            Spacer()
                            Rectangle()
                                .background(Color("Background"))
                                .opacity(0.2)
                                .ignoresSafeArea()
                                .frame(width: UIScreen.main.bounds.size.width/2, height: 50)
                                .onTapGesture {}
                        }
                    } else if appModel.noClick {
                        Rectangle()
                            .background(Color("Background"))
                            .opacity(0.2)
                            .ignoresSafeArea()
                            .frame(width: UIScreen.main.bounds.size.width, height: 50)
                            .onTapGesture {}
                        
                    }
                }
            }.preferredColorScheme(.light)
        }
    }
}
