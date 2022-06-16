//
//  SwiftUIDemoApp.swift
//  SwiftUIDemo
//
//  Created by Abdullah Kardas on 28.04.2022.
//

import SwiftUI

@main
struct SwiftUIDemoApp: App {
    
    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor:UIColor(Color.theme.accent)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor:UIColor(Color.theme.accent)]
    }
    @Environment(\.scenePhase) var scenePhase
    @StateObject  var homeModel:HomeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView().navigationBarHidden(true)
            }.environmentObject(homeModel)

        }.onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                print("Active")
            } else if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
}
