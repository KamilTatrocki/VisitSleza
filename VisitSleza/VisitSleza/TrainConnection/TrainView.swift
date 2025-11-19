//
//  TrainView.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import SwiftUI

struct TrainView: View {
    
    // 1. Tworzy i obserwuje ViewModel
    @StateObject private var viewModel = TrainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // 2. Sekcja wyszukiwania (DatePicker i Przycisk)
                searchSection
                
                // 3. Sekcja wyników (Loading, Błąd, Lista)
                resultsSection
            }
            .navigationTitle("Rozkład Jazdy")
            .background(Color(.systemGroupedBackground)) // Tło dla całego widoku
            .tint(.blue) // Ustawia główny kolor (dla DatePicker, ProgressView itp.)
        }
        // Opt into full Dynamic Type range by default.
        // If you want to limit extremes, use .dynamicTypeSize(.xSmall ... .accessibility5)
        .dynamicTypeSize(.xSmall ... .accessibility5)
    }
    
    // Prywatna właściwość dla sekcji wyszukiwania (dla czystości kodu)
    private var searchSection: some View {
        Form {
            DatePicker(
                "Data odjazdu",
                selection: $viewModel.searchDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            // Labels and pickers scale automatically with Dynamic Type.
            
            Button(action: {
                // Wywołuje akcję w ViewModelu wewnątrz Taska (dla async)
                Task {
                    await viewModel.fetchConnections()
                }
            }) {
                Text("Szukaj połączeń")
                    .frame(maxWidth: .infinity)
                    // Use semantic font to ensure scaling
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent) // Niebieski przycisk
        }
        .frame(height: 160) // Stała wysokość dla formularza
        // Allow the form to scale fully as well
        .dynamicTypeSize(.xSmall ... .accessibility5)
    }
    
    // Prywatna właściwość dla sekcji wyników
    @ViewBuilder
    private var resultsSection: some View {
        // Używamy 'switch' na stanie ViewModelu, aby pokazać odpowiedni widok
        switch viewModel.loadingState {
        case .idle:
            // Stan początkowy
            ContentUnavailableView(
                "Wyszukaj połączenia",
                systemImage: "tram.fill",
                description: Text("Wybierz datę i godzinę, aby zobaczyć pociągi.")
            )
            .dynamicTypeSize(.xSmall ... .accessibility5)
            
        case .loading:
            // Stan ładowania
            Spacer()
            ProgressView("Ładowanie...")
                .dynamicTypeSize(.xSmall ... .accessibility5)
            Spacer()
            
        case .failed(let error):
            // Stan błędu
            ContentUnavailableView(
                "Błąd",
                systemImage: "exclamationmark.triangle",
                description: Text(error.localizedDescription)
            )
            .dynamicTypeSize(.xSmall ... .accessibility5)
            
        case .success:
            // Sukces - lista wyników
            if viewModel.connections.isEmpty {
                // Sukces, ale brak wyników
                ContentUnavailableView(
                    "Brak wyników",
                    systemImage: "magnifyingglass",
                    description: Text("Nie znaleziono połączeń dla wybranej daty.")
                )
                .dynamicTypeSize(.xSmall ... .accessibility5)
            } else {
                // Sukces, mamy wyniki
                List(viewModel.connections) { connection in
                    ConnectionRowView(connection: connection)
                }
                .listStyle(.insetGrouped) // Styl listy
                .dynamicTypeSize(.xSmall ... .accessibility5)
            }
        }
    }
}

// Sub-view dla pojedynczego wiersza na liście (dla czystości)
struct ConnectionRowView: View {
    let connection: TrainConnection
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            // Kolumna z czasami
            VStack(alignment: .leading, spacing: 4) {
                Text(connection.departureTime)
                    .font(.title3.weight(.bold)) // Scales with Dynamic Type
                    .minimumScaleFactor(0.8) // Avoid clipping at slightly larger sizes
                    .lineLimit(1)
                Text(connection.arrivalTime)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            // Fixed width can cause truncation at very large sizes.
            // Allow it to grow a bit with Dynamic Type by using a minimum width instead.
            .frame(minWidth: 60, alignment: .leading)
            
            // Kolumna z nazwą pociągu i czasem trwania
            VStack(alignment: .leading, spacing: 4) {
                Text(connection.trainDescription)
                    .font(.headline)
                    .foregroundStyle(.blue) // Niebieski akcent
                    .lineLimit(2) // Allow wrapping for long names at large sizes
                    .minimumScaleFactor(0.8)
                Text(connection.durationFormatted)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .dynamicTypeSize(.xSmall ... .accessibility5)
    }
}


#Preview {
    TrainView()
}
