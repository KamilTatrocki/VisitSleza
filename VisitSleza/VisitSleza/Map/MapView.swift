//
//  MapView.swift
//  VisitSleza
//
//  Created by Kamil Tatrocki on 01/11/2025.
//
import SwiftUI
import MapKit

struct MapView: View {
    let slezaLocation = CLLocationCoordinate2D(latitude: 50.864392043553856, longitude: 16.707083861588398)
    let stacjaneapollocation = CLLocationCoordinate2D(latitude: 50.93395694250308, longitude: 16.758895440420595)
    
    var body: some View {
        Map {
            Marker("Sleza",systemImage: "mountain.2.fill", coordinate: slezaLocation )
            Marker("Stacja Neapol", systemImage: "fork.knife", coordinate: stacjaneapollocation)
        }
    }
}

#Preview {
    MapView()
}
