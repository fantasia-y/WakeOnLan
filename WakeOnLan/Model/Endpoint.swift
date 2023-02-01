//
//  Endpoint.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import Foundation

struct Endpoint: Hashable, Codable, Identifiable {
    var id: UUID
    var name: String
    var host: String
    var mac: String
    var isLoading: Bool = false
    var isReachable: Bool = false
}
