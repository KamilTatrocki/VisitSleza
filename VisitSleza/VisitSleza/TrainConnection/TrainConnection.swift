//
//  TrainConnection.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import Foundation

// Główny model dla pojedynczego połączenia
struct TrainConnection: Codable, Identifiable {
    let uuid: String
    let departure: Date
    let arrival: Date
    let duration: Int
    let changes: Int
    let legs: [TrainLeg]

    // Powiązanie 'id' z 'uuid' dla zgodności z Identifiable
    var id: String { uuid }
    
    // --- Pomocnicze właściwości dla View ---
    
    // Formatter jest 'static', aby nie tworzyć go za każdym razem
    private static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // np. "13:45"
        return formatter
    }()
    
    // Zwraca sformatowany czas odjazdu
    var departureTime: String {
        Self.timeFormatter.string(from: departure)
    }
    
    // Zwraca sformatowany czas przyjazdu
    var arrivalTime: String {
        Self.timeFormatter.string(from: arrival)
    }
    
    // Zwraca czas trwania w czytelnym formacie
    var durationFormatted: String {
        "\(duration) min"
    }
    
    // Zwraca nazwę pociągu (lub numer, jeśli nazwa jest pusta)
    var trainDescription: String {
        // Używamy 'first', bo to połączenia bezpośrednie lub pierwszy etap
        guard let firstLeg = legs.first else { return "Brak danych" }
        
        if !firstLeg.train_name.isEmpty {
            return firstLeg.train_name
        } else {
            return "Pociąg nr \(firstLeg.train_nr)"
        }
    }
}

// Model dla pojedynczego "etapu" podróży (w naszym przypadku jednego pociągu)
struct TrainLeg: Codable, Identifiable {
    let train_id: Int
    let train_nr: Int
    let train_name: String
    let departure_platform: String? // Platforma może być nullem
    let arrival_platform: String?

    // Powiązanie 'id' z 'train_id'
    var id: Int { train_id }
}
