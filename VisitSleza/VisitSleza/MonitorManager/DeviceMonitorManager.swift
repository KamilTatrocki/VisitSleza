import Foundation
import DeviceActivity
import FamilyControls
import Combine
import UserNotifications

class DeviceMonitorManager: ObservableObject {
    @Published var isMonitoring = false
    @Published var selection = FamilyActivitySelection()
    let center = DeviceActivityCenter()

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            _ = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
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

        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: DateComponents(second: 2)
        )

        let activity = DeviceActivityName("VisitSleza.Limit")
        let eventName = DeviceActivityEvent.Name("VisitSleza.10SecEvent")

        do {
            try center.startMonitoring(activity, during: schedule, events: [
                eventName: event
            ])
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
