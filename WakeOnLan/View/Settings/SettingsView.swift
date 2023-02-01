//
//  SettingsView.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("timeoutInterval") var timeoutInterval: Double = 30
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Timout Interval", selection: $timeoutInterval) {
                    ForEach(Settings.timeoutOptions, id: \.self) { option in
                        Text("\(String(format: "%.0f", option))s")
                            .tag(option)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
