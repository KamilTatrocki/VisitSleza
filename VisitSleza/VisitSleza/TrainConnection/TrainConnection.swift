//
//  TrainConnection.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import Foundation


struct TrainConnection: Codable, Identifiable {
    let uuid: String
    let departure: Date
    let arrival: Date
    let duration: Int
    let changes: Int
    let legs: [TrainLeg]


    var id: String { uuid }
    
   
    private static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    
    var departureTime: String {
        Self.timeFormatter.string(from: departure)
    }
    

    var arrivalTime: String {
        Self.timeFormatter.string(from: arrival)
    }
    
  
    var durationFormatted: String {
        "\(duration) min"
    }
    
    
    var trainDescription: String {
    
        guard let firstLeg = legs.first else { return "Brak danych" }
        
        if !firstLeg.train_name.isEmpty {
            return firstLeg.train_name
        } else {
            return "Pociąg nr \(firstLeg.train_nr)"
        }
    }
}


struct TrainLeg: Codable, Identifiable {
    let train_id: Int
    let train_nr: Int
    let train_name: String
    let departure_platform: String?
    let arrival_platform: String?

    
    var id: Int { train_id }
}
