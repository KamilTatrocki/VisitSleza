import SwiftUI
import FamilyControls

struct MonitorView: View {
    @StateObject private var manager = DeviceMonitorManager()
    @State private var isPickerPresented = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: manager.isMonitoring ? "timer" : "timer.slash")
                .font(.system(size: 60))
                .foregroundColor(manager.isMonitoring ? .green : .red)

            Text(manager.isMonitoring ? "Monitoring aktywny" : "Monitoring wyłączony")
                .font(.headline)

            Button("Wybierz aplikacje do limitu") {
                isPickerPresented = true
            }
            .familyActivityPicker(isPresented: $isPickerPresented, selection: $manager.selection)
            .padding()

            Button(action: {
                Task {
                    await manager.requestAuthorization()
                    manager.startMonitoring()
                }
            }) {
                Text("Włącz limit 10s")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
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
