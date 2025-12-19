import SwiftUI

struct TrainView: View {
    
    @StateObject private var viewModel = TrainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchSection
                resultsSection
            }
            .navigationTitle("Rozkład Jazdy")
            .background(Color(.systemGroupedBackground))
            .tint(.blue)
            .accessibilityLabel("Ekran wyszukiwania połączeń. Użyj formularza u góry, aby znaleźć pociąg.")
        }
        .dynamicTypeSize(.xSmall ... .accessibility5)
    }
    
    private var searchSection: some View {
        Form {
            DatePicker(
                "Data odjazdu",
                selection: $viewModel.searchDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .accessibilityLabel("Data odjazdu")
            .accessibilityHint("Kliknij dwukrotnie, aby zmienić datę i godzinę.")
            
            Button(action: {
                Task {
                    await viewModel.fetchConnections()
                }
            }) {
                Text("Szukaj połączeń")
                    .frame(maxWidth: .infinity)
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(.white)
            }
            .listRowBackground(Color.blue)
            .buttonStyle(.plain)
            .accessibilityHint("Rozpoczyna pobieranie listy pociągów.")
            .accessibilityAddTraits(.isButton)
        }
        .frame(height: 160)
        .dynamicTypeSize(.xSmall ... .accessibility5)
    }
    
    @ViewBuilder
    private var resultsSection: some View {
        switch viewModel.loadingState {
        case .idle:
            ContentUnavailableView(
                "Wyszukaj połączenia",
                systemImage: "tram.fill",
                description: Text("Wybierz datę i godzinę, aby zobaczyć pociągi.")
            )
            .dynamicTypeSize(.xSmall ... .accessibility5)
            .accessibilityElement(children: .combine)
            
        case .loading:
            Spacer()
            ProgressView("Ładowanie...")
                .dynamicTypeSize(.xSmall ... .accessibility5)
            Spacer()
            
        case .failed:
            ContentUnavailableView(
                "Brak wyników",
                systemImage: "magnifyingglass",
                description: Text("Nie znaleziono połączeń dla wybranej daty.")
            )
            .dynamicTypeSize(.xSmall ... .accessibility5)
            .accessibilityElement(children: .combine)
            
        case .success:
            if viewModel.connections.isEmpty {
                ContentUnavailableView(
                    "Brak wyników",
                    systemImage: "magnifyingglass",
                    description: Text("Nie znaleziono połączeń dla wybranej daty.")
                )
                .dynamicTypeSize(.xSmall ... .accessibility5)
                .accessibilityElement(children: .combine)
            } else {
                List(viewModel.connections) { connection in
                    ConnectionRowView(connection: connection)
                }
                .listStyle(.insetGrouped)
                .dynamicTypeSize(.xSmall ... .accessibility5)
            }
        }
    }
}

struct ConnectionRowView: View {
    let connection: TrainConnection
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(connection.departureTime)
                    .font(.title3.weight(.heavy))
                    .foregroundStyle(.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Text(connection.arrivalTime)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .accessibilityHidden(true)
            }
            .frame(minWidth: 70, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(connection.trainDescription)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                
                Text(connection.durationFormatted)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .dynamicTypeSize(.xSmall ... .accessibility5)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Pociąg \(connection.trainDescription). Odjazd \(connection.departureTime), przyjazd \(connection.arrivalTime). Czas podróży \(connection.durationFormatted)."
        )
        .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    TrainView()
}
