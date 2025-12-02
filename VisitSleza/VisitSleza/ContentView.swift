//
//  ContentView.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // 1. Tworzysz główny kontener TabView
        TabView {
            
            // 2. Definiujesz pierwszy ekran (zakładkę)
            MapView()
                .font(.largeTitle)
                .tabItem {
                    // 3. Ustawiasz ikonę i etykietę dla zakładki
                    Image(systemName: "house.fill") // Ikona z biblioteki Apple (SF Symbols)
                    Text("Mapka")
                }
            BearView()
                            .tabItem {
                                Image(systemName: "pawprint.fill")
                                Text("Miś")
                            }

            // 4. Definiujesz drugi ekran (zakładkę)
            TrainView()
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "train.side.rear.car")
                    Text("Pociagi")
                }
            
            // Możesz dodać więcej widoków
            Text("Trzeci ekran - Profil")
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
        }
    }
}
#Preview {
    ContentView()
}



