import SwiftUI
import FamilyControls

struct MonitorView: View {
    @StateObject private var manager = DeviceMonitorManager()
    @State private var isPickerPresented = false

    var body: some View {
        VStack(spacing: 20) {
            // Zmieniono timer.slash na clock, który jest dostępny wszędzie
            Image(systemName: manager.isMonitoring ? "timer" : "clock")
                .font(.system(size: 60))
                .foregroundColor(manager.isMonitoring ? .green : .orange)

            Text(manager.isMonitoring ? "Monitoring aktywny" : "Wybierz aplikacje i włącz")
                .font(.headline)

            // WAŻNE: Musisz tu kliknąć i wybrać "VisitSleza" na liście!
            Button("1. Wybierz aplikacje (WYMAGANE)") {
                isPickerPresented = true
            }
            .familyActivityPicker(isPresented: $isPickerPresented, selection: $manager.selection)
            .buttonStyle(.bordered)

            Button(action: {
                Task {
                    await manager.requestAuthorization()
                    manager.startMonitoring()
                }
            }) {
                Text("2. Włącz limit 10s")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            // TRYB TESTOWY DLA SYMULATORA
            Button(action: {
                manager.simulateNotification()
            }) {
                Text("Testuj powiadomienie (Symulator)")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }

            Button(action: {
                manager.stopMonitoring()
            }) {
                Text("Wyłącz wszystko")
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}
