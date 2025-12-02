//
//  SearchRequests.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import Foundation


struct SearchRequest: Codable {
    let departure_after: String
    let start_id: Int
    let end_id: Int
    let only_direct: Bool
}
