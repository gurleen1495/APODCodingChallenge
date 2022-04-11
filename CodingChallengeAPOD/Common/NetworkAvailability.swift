//
//  NetworkAvailability.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 11/4/22.
//

import Foundation
import Network

class Network {
    static let shared = Network()
    
    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
    }
    let backgroudQueue = DispatchQueue.global(qos: .background)
    
    init() {
        initialize()
    }
    
    func initialize() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }
    
    func isAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}
