//
//  NetStatus.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/19.
//

import Foundation
import Network

class NetStatus {
    static let shared = NetStatus()
    private init(){  }
    deinit {
        stopMonitoring()
    }
    var monitor : NWPathMonitor?
    var isMonitoring = false
    
    var didStartMonitoringHandler: (() -> Void)?
    var didStopMonitoringHandler: (() -> Void)?
    var netStatusChangeHandler: (() -> Void)?
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
    
}
