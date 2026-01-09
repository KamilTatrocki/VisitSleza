//
//  DeviceActivityMonitorExtension.swift
//  SlezaMonitorExtension
//
//  Created by Kamil Tatrocki on 09/01/2026.
//

import Foundation
import DeviceActivity
import FamilyControls
import Combine

class SlezaMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
    }
}
