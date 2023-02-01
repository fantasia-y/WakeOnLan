//
//  OverviewListRow.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import SwiftUI

struct OverviewListRow: View {
    @EnvironmentObject var viewModel: OverviewViewModel
    
    var endpoint: Endpoint
    
    @State var isLoading = true
    @State var isReachable = false
    
    var body: some View {
        HStack {
            Text(endpoint.name.isEmpty ? endpoint.host : endpoint.name)
            
            Spacer()
            
            if viewModel.isEndpointLoading(endpoint) {
                ProgressView()
            } else {
                HStack {
                    Circle()
                        .fill(viewModel.isEndpointReachable(endpoint) ? .green : .gray)
                        .frame(maxWidth: 8)
                    
                    Text(viewModel.isEndpointReachable(endpoint) ? "Running" : "Not running")
                }
            }
        }
        .task {
            await viewModel.pingEndpoint(endpoint)
        }
        .swipeActions() {
            Button {
                Task {
                    await viewModel.wakeUpEndpoint(endpoint)
                }
            } label: {
                Image(systemName: "play")
            }
            .tint(.blue)
            
            Button {
                viewModel.selectedEndpoint = endpoint
                viewModel.showAdd = true
            } label: {
                Image(systemName: "pencil")
            }
            .tint(.yellow)
            
            Button {
                viewModel.remove(endpoint: endpoint)
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
        }
    }
}

struct OverviewListRow_Previews: PreviewProvider {
    static var previews: some View {
        OverviewListRow(endpoint: Endpoint(id: UUID(), name: "", host: "192.168.178.113", mac: ""))
            .environmentObject(OverviewViewModel())
    }
}
