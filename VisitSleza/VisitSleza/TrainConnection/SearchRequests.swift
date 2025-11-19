//
//  SearchRequests.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import Foundation

// Struktura dla body zapytania POST
struct SearchRequest: Codable {
    let departure_after: String // Format "yyyy-MM-dd'T'HH:mm:ss"
    let start_id: Int
    let end_id: Int
    let only_direct: Bool
}
