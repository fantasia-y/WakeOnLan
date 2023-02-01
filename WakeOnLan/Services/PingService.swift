//
//  PingService.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import Foundation

class PingService {
    func ping(ip: String, timeout: Double?) async -> Bool {
        var request = URLRequest(url: .init(string: ip)!)
        request.httpMethod = "HEAD"
        request.timeoutInterval = timeout ?? 30
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            return (response as? HTTPURLResponse)?.statusCode ?? 0 == 200
        } catch {
            return false
        }
    }
}
