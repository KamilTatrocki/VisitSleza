//
//  ContentView.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//

import SwiftUI

struct ContentView: View {
    // Track which tab is selected
    @State private var selectedTab: Int = 0

    var body: some View {
        // Główny kontener TabView
        TabView(selection: $selectedTab) {

            // Start screen tab (tag 0)
            StartView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Start")
                }
                .tag(0)

            // Map tab (tag 1)
            MapView()
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Mapka")
                }
                .tag(1)

            // Bear tab (tag 2)
            BearView()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Miś")
                }
                .tag(2)

            // Train tab (tag 3)
            TrainView()
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "train.side.rear.car")
                    Text("Pociagi")
                }
                .tag(3)

            // Profile tab (tag 4)
            Text("Trzeci ekran - Profil")
                .font(.largeTitle)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
}
