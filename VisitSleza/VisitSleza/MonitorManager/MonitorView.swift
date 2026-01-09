
import SwiftUI
import Foundation
import DeviceActivity
import FamilyControls
import Combine

struct MonitorView: View {
    @StateObject private var manager = DeviceMonitorManager()

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: manager.isMonitoring ? "timer" : "timer.slash")
                .font(.system(size: 60))
                .foregroundColor(manager.isMonitoring ? .green : .red)

            Text(manager.isMonitoring ? "Monitoring aktywny" : "Monitoring wyłączony")
                .font(.headline)

            Button(action: {
                Task {
                    await manager.requestAuthorization()
                    manager.startMonitoring()
                }
            }) {
                Text("Włącz limit zwiedzania")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                manager.stopMonitoring()
            }) {
                Text("Wyłącz limit")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
