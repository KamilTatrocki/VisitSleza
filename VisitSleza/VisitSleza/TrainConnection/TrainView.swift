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
                
             
                searchSection
                
          
                resultsSection
            }
            .navigationTitle("Rozkład Jazdy")
            .background(Color(.systemGroupedBackground))
            .tint(.blue)
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
      
            
            Button(action: {
   
                Task {
                    await viewModel.fetchConnections()
                }
            }) {
                Text("Szukaj połączeń")
                    .frame(maxWidth: .infinity)
                
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(height: 160)
      
        .dynamicTypeSize(.xSmall ... .accessibility5)
    }
    
    // Prywatna właściwość dla sekcji wyników
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
            
        case .loading:
            
            Spacer()
            ProgressView("Ładowanie...")
                .dynamicTypeSize(.xSmall ... .accessibility5)
            Spacer()
            
        case .failed(let error):
            ContentUnavailableView(
                "Brak wyników",
                systemImage: "magnifyingglass",
                description: Text("Nie znaleziono połączeń dla wybranej daty.")
            )
            .dynamicTypeSize(.xSmall ... .accessibility5)
            
            //ContentUnavailableView(
              //  "Błąd",
                //systemImage: "exclamationmark.triangle",
                //description: Text(error.localizedDescription)
            //)
            //.dynamicTypeSize(.xSmall ... .accessibility5)
            
        case .success:
            
            if viewModel.connections.isEmpty {
               
                ContentUnavailableView(
                    "Brak wyników",
                    systemImage: "magnifyingglass",
                    description: Text("Nie znaleziono połączeń dla wybranej daty.")
                )
                .dynamicTypeSize(.xSmall ... .accessibility5)
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
                    .font(.title3.weight(.bold))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                Text(connection.arrivalTime)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            

            .frame(minWidth: 60, alignment: .leading)
            

            VStack(alignment: .leading, spacing: 4) {
                Text(connection.trainDescription)
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .lineLimit(2)
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
