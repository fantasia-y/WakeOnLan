//
//  ContentView.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        TabView {
            OverviewList()
                .tabItem() {
                    Label("Overview", systemImage: "server.rack")
                }
            
            SettingsView()
                .tabItem() {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
