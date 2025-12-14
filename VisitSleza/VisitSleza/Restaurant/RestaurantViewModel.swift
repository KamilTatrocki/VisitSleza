//
//  RestaurantViewModel.swift
//  VisitSleza
//
//  Created by Assistant on 04/12/2025.
//


import Foundation
import MapKit
import Combine


final class RestaurantViewModel: ObservableObject {
    @Published var restaurant: RestaurantModel
    @Published var region: MKCoordinateRegion


    // Annotation for the restaurant location
    @Published var annotations: [MKPointAnnotation] = []


    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        let coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
        // Reasonable default span for a small map view
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        self.region = MKCoordinateRegion(center: coordinate, span: span)


        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = restaurant.name
        self.annotations = [pin]
    }


    func updateLocation(latitude: Double, longitude: Double) {
        restaurant.latitude = latitude
        restaurant.longitude = longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        region.center = coordinate
        annotations.first?.coordinate = coordinate
    }
}
