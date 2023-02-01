//
//  OverviewAddView.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import SwiftUI

struct OverviewAddView: View {
    @EnvironmentObject var viewModel: OverviewViewModel
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.name)
            
            Section {
                TextField("Host", text: $viewModel.host)
                
                TextField("MAC Address", text: $viewModel.mac)
            }
            
            Button("Save") {
                if let _ = viewModel.selectedEndpoint {
                    viewModel.editEnpoint()
                } else {
                    viewModel.addEndpoint()
                }
                
                viewModel.selectedEndpoint = nil
                viewModel.showAdd = false
            }
        }
        .onAppear() {
            viewModel.name = viewModel.selectedEndpoint?.name ?? ""
            viewModel.host = viewModel.selectedEndpoint?.host ?? ""
            viewModel.mac = viewModel.selectedEndpoint?.mac ?? ""
        }
    }
}

struct OverviewAddView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewAddView()
            .environmentObject(OverviewViewModel())
    }
}
