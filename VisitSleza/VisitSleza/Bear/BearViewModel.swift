//
//  BearViewModel.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 02/12/2025.
//

import Foundation
import SwiftUI
import Combine

class BearViewModel: ObservableObject {
    @Published var bear = BearModel()
    
    private var lastStrokeTime: Date?
    
    func handleStroking() {
        guard !bear.isRewardAvailable else { return }
        
        let now = Date()
        
        if let lastTime = lastStrokeTime {
            let timeDelta = now.timeIntervalSince(lastTime)
            
            if timeDelta < 0.5 {
                bear.accumulatedTime += timeDelta
                bear.progress = min(bear.accumulatedTime / bear.requiredDuration, 1.0)
                
                if bear.progress >= 1.0 {
                    bear.isRewardAvailable = true
                }
            }
        }
        
        lastStrokeTime = now
    }
    
    func resetInterruption() {
        lastStrokeTime = nil
    }
}
