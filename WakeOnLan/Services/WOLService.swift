//
//  WOLService.swift
//  WakeOnLan
//
//  Created by Gordon on 01.02.23.
//

import Foundation
import Network

class WOLService {
    private func createMagicPacket(mac: String) -> [CUnsignedChar] {
            var buffer = [CUnsignedChar]()
            
            // Create header
            for _ in 1...6 {
                buffer.append(0xFF)
            }
            
            let components = mac.components(separatedBy: ":")
            let numbers = components.map {
                return strtoul($0, nil, 16)
            }
            
            // Repeat MAC address 20 times
            for _ in 1...20 {
                for number in numbers {
                    buffer.append(CUnsignedChar(number))
                }
            }
            
            return buffer
    }

    func sendMagicPacket(mac: String) {
        let data = Data(createMagicPacket(mac: mac))
        
        let queue = DispatchQueue(label: "connection")
        let client = NWConnection(host: NWEndpoint.Host("255.255.255.255"), port: NWEndpoint.Port(integerLiteral: 9), using: .udp)
        client.start(queue: queue)
        client.send(content: data, completion: .idempotent)
        // client.cancel()
    }
}
