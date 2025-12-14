//
//  RestaurantModel.swift
//  VisitSleza
//
//  Created by stud on 04/12/2025.
//




import Foundation


struct RestaurantModel {
    var name: String
    var description: String
    var rating: Double
    var longitude: Double
    var latitude: Double
    
    var menu: [itemMenu]
    
}




struct itemMenu {
    var name: String
    var price: Double
}


