//
//  RestaurantView.swift
//  VisitSleza
//
//  Created by Assistant on 04/12/2025.
//


import SwiftUI
import MapKit


struct RestaurantView: View {
    @StateObject var viewModel: RestaurantViewModel
    @State private var cameraPosition: MapCameraPosition


    init(restaurant: RestaurantModel) {
        _viewModel = StateObject(wrappedValue: RestaurantViewModel(restaurant: restaurant))


        _cameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.restaurant.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)


                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", viewModel.restaurant.rating))
                        .font(.headline)
                }


                Text(viewModel.restaurant.description)
                    .font(.body)
                    .foregroundStyle(.secondary)


                // Small map showing the restaurant location
                Map(position: $cameraPosition) {
                    // Single annotation for the restaurant location
                    Annotation(viewModel.restaurant.name, coordinate: CLLocationCoordinate2D(latitude: viewModel.restaurant.latitude, longitude: viewModel.restaurant.longitude)) {
                        ZStack {
                            Circle().fill(Color.red).frame(width: 12, height: 12)
                            Circle().stroke(Color.white, lineWidth: 2).frame(width: 12, height: 12)
                        }
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )


                if !viewModel.restaurant.menu.isEmpty {
                    Text("Menu")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)


                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(viewModel.restaurant.menu.enumerated()), id: \.offset) { _, item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 6)
                            Divider()
                        }
                    }
                }


                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationTitle("Restaurant")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    let sample = RestaurantModel(
        name: "Cafe Panorama",
        description: "Cozy place with a great view and fresh pastries.",
        rating: 4.6,
        longitude: 16.9300,
        latitude: 51.0300,
        menu: [
            itemMenu(name: "Espresso", price: 8.0),
            itemMenu(name: "Cappuccino", price: 12.0),
            itemMenu(name: "Croissant", price: 7.5)
        ]
    )
    return NavigationStack { RestaurantView(restaurant: sample) }
}
