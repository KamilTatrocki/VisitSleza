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
    
    // Możemy dodać @State, aby pokazać np. okno (sheet) po kliknięciu
    @State private var selectedPlaceName: String?
    
    var body: some View {
        Map {
            
            // 1. Zamiast Marker, używamy Annotation
            Annotation("Ślęża", coordinate: slezaLocation) {
                
                // 2. W środku umieszczamy Button
                Button {
                    print("Kliknięto Ślężę!")
                    selectedPlaceName = "Ślęża" // Ustawiamy nazwę, aby pokazać sheet
                } label: {
                    // 3. Stylizujemy nasz przycisk, aby wyglądał jak pin
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "mountain.2.fill")
                            .foregroundStyle(.white)
                    }
                }
            }

            Annotation("Stacja Neapol", coordinate: stacjaneapollocation) {
                Button {
                    print("Kliknięto Stację Neapol!")
                    selectedPlaceName = "Stacja Neapol"
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.orange) // Inny kolor dla odróżnienia
                            .frame(width: 40, height: 40)
                            
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.white)
                        
                    }
                }
            }
        }
        // Constrain Dynamic Type for this view and its descendants (including the sheet)
        .dynamicTypeSize(.xSmall ... .accessibility5)
        
        // 4. Dodajemy .sheet, który zareaguje na zmianę @State
        .sheet(item: $selectedPlaceName) { placeName in
            // Ten widok pojawi się od dołu
            Text("Wybrano miejsce: \(placeName)")
                .presentationDetents([.fraction(0.7)]) // Ustawia wysokość okna
        }
    }
}

// Musimy dodać prostą implementację dla String: Identifiable,
// aby .sheet(item: ...) wiedział, jak unikalnie identyfikować elementy
extension String: Identifiable {
    public var id: String { self }
}

#Preview {
    MapView()
}
