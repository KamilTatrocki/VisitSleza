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
            print("Błąd autoryzacji: \(error)")
        }
    }

    // Ta funkcja pozwala przetestować powiadomienie na symulatorze
    func simulateNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Visit Ślęża (TEST)"
        content.body = "To jest testowe powiadomienie działające na symulatorze!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )

        UNUserNotificationCenter.current().add(request)
    }

    func startMonitoring() {
        // Jeśli selection jest puste, monitoring nie zadziała
        guard !selection.applicationTokens.isEmpty else {
            print("BŁĄD: Nie wybrano żadnej aplikacji!")
            return
        }

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            threshold: DateComponents(second: 10)
        )

        do {
            try center.startMonitoring(DeviceActivityName("VisitSleza.Limit"), during: schedule, events: [
                DeviceActivityEvent.Name("VisitSleza.10SecEvent"): event
            ])
            isMonitoring = true
        } catch {
            print("Błąd startu: \(error)")
        }
    }

    func stopMonitoring() {
        center.stopMonitoring([DeviceActivityName("VisitSleza.Limit")])
        isMonitoring = false
    }
}
