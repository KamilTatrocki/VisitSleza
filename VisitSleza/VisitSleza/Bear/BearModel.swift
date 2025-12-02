//
//  BearModel.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 02/12/2025.
//

import Foundation

struct BearModel {
    var progress: Double = 0.0
    var isRewardAvailable: Bool = false
    var accumulatedTime: TimeInterval = 0.0
    let requiredDuration: TimeInterval = 5.0
}
