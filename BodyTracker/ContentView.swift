//
//  ContentView.swift
//  BodyTracker
//
//  Created by Administrator on 18/01/20.
//  Copyright © 2020 RafaelCM. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State var tabIndex:Int = 0
    
    var body: some View {
        TabView(selection: $tabIndex) {
            Dashboard()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
            }
                .tag(0)
                .onTapGesture {
                    HapticFeedback.playSelection()
                    self.endEditing(true)
                    
            }
            NewMedida(tabIndex: self.$tabIndex)
                .tabItem {
                    Image(systemName: "gauge.badge.plus")
                    Text("Nova Medida")
            }
                .tag(1)
                .onTapGesture {
                    HapticFeedback.playSelection()
                    self.endEditing(true)
                    
            }
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Histórico")
            }
                .tag(2)
                .onTapGesture {
                    HapticFeedback.playSelection()
                    self.endEditing(true)
                    
            }
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Perfil")
            }
                .tag(3)
                .onTapGesture {
                    HapticFeedback.playSelection()
                    self.endEditing(true)
                    
            }
        }
        .foregroundColor(getMyColor())
        //.statusBar(hidden: true)
        .colorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

