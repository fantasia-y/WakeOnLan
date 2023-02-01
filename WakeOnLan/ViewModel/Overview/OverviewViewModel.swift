//
//  OverviewViewModel.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import Foundation

@MainActor class OverviewViewModel: ObservableObject {    
    let pingService = PingService()
    let wolService = WOLService()
    let defaults = UserDefaults.standard
    
    @Published var endpoints = [Endpoint]()
    @Published var loadingStatus = [UUID:Bool]()
    @Published var reachableStatus = [UUID:Bool]()
    
    @Published var showAdd = false
    
    @Published var selectedEndpoint: Endpoint? = nil
    @Published var name = ""
    @Published var host = ""
    @Published var mac = ""
    
    func loadEndpoints() {
        if let endpointsData = defaults.object(forKey: "Endpoints") as? Data {
            let decoder = JSONDecoder()
            if let endpoints = try? decoder.decode([Endpoint].self, from: endpointsData) {
                self.endpoints = endpoints
                
                for endpoint in endpoints {
                    loadingStatus[endpoint.id] = true
                    reachableStatus[endpoint.id] = false
                }
            }
        }
    }
    
    func saveEndpoints() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(endpoints) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "Endpoints")
        }
    }
    
    func addEndpoint() {
        let endpoint = Endpoint(id: UUID(), name: name, host: host, mac: mac)
        endpoints.append(endpoint)
        saveEndpoints()
        
        name = ""
        host = ""
        mac = ""
    }
    
    func editEnpoint() {
        if let selectedEndpoint {
            let updated = Endpoint(id: selectedEndpoint.id, name: name, host: host, mac: mac)
            
            if let index = endpoints.firstIndex(of: selectedEndpoint) {
                endpoints[index] = updated
            }
            
            saveEndpoints()
        }
    }
    
    func remove(endpoint: Endpoint) {
        endpoints.removeAll(where: { $0 == endpoint })
        saveEndpoints()
    }
    
    func wakeUpEndpoint(_ endpoint: Endpoint) async {
        wolService.sendMagicPacket(mac: endpoint.mac)
        await pingEndpoint(endpoint)
    }
    
    func pingEndpoint(_ endpoint: Endpoint) async {
        loadingStatus[endpoint.id] = true
        reachableStatus[endpoint.id] = await pingService.ping(ip: "http://\(endpoint.host)", timeout: defaults.double(forKey: "timeoutInterval"))
        loadingStatus[endpoint.id] = false
    }
    
    func pingAll() async {
        await withTaskGroup(of: Void.self) { taskGroup in
            for endpoint in endpoints {
                taskGroup.addTask {
                    await self.pingEndpoint(endpoint)
                }
            }
        }
    }
    
    func isEndpointLoading(_ endpoint: Endpoint) -> Bool {
        return loadingStatus[endpoint.id] ?? true
    }
    
    func isEndpointReachable(_ endpoint: Endpoint) -> Bool {
        return reachableStatus[endpoint.id] ?? false
    }
}
