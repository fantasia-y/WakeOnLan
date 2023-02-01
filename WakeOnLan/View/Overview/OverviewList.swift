//
//  OverviewList.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import SwiftUI

struct OverviewList: View {
    @StateObject var viewModel = OverviewViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.endpoints) { endpoint in
                    OverviewListRow(endpoint: endpoint)
                        .environmentObject(viewModel)
                }
            }
            .navigationTitle("Overview")
            .onAppear() {
                viewModel.loadEndpoints()
            }
            .toolbar() {
                Button {
                    Task {
                        await viewModel.pingAll()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                
                Button {
                    viewModel.showAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .refreshable {
                await viewModel.pingAll()
            }
            .sheet(isPresented: $viewModel.showAdd) {
                OverviewAddView()
                    .environmentObject(viewModel)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

struct OverviewList_Previews: PreviewProvider {
    static var previews: some View {
        OverviewList()
    }
}
