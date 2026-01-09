//
//  DeviceMonitorManager.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 09/01/2026.
//

import Foundation
import DeviceActivity
import FamilyControls
import Combine

class DeviceMonitorManager: ObservableObject {
    @Published var isMonitoring = false
    let center = DeviceActivityCenter()

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        } catch {
            print(error)
        }
    }

    func startMonitoring() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        let activity = DeviceActivityName("VisitSleza.Limit")

        do {
            try center.startMonitoring(activity, during: schedule)
            isMonitoring = true
        } catch {
            print(error)
        }
    }

    func stopMonitoring() {
        center.stopMonitoring([DeviceActivityName("VisitSleza.Limit")])
        isMonitoring = false
    }
}
