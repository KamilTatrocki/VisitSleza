import DeviceActivity
import FamilyControls
import UserNotifications

class SlezaMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        sendNotification(body: "Monitoring wystartował!")
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        sendNotification(body: "Przekroczono 10 sekund aktywności!")
    }

    private func sendNotification(body: String) {
        let content = UNMutableNotificationContent()
        content.title = "Visit Ślęża"
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }
}
