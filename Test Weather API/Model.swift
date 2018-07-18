//
//  Model.swift
//  Test Weather API
//
//  Created by Максим Вильданов on 16.07.2018.
//  Copyright © 2018 Максим Вильданов. All rights reserved.
//

import Foundation


struct Model: Decodable {
    
    var coord: Coord
    var weather: [Weather]
    var base : String?
    var main : Main
    var visibility: Int?
    var wind: Wind
    var clouds: Clouds
    var dt: Double?
    var sys: Sys
    var id: Int?
    var name: String?
    var cod: Int?
}

struct Coord: Decodable {
    var lon : Double?
    var lat : Double?
}

struct Weather: Decodable {
    var id : Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Main: Decodable {
    var temp : Double?
    var pressure: Int?
    var humidity: Int?
    var temp_min: Int?
    var temp_max: Int?
    
}

struct Wind: Decodable {
    var speed: Double?
    var deg: Int?
}

struct Clouds: Decodable {
    var all : Int
}

struct Sys: Decodable {
    var type: Int?
    var id: Int?
    var message: Double?
    var country: String?
    var sunrise: Double?
    var sunset: Double?
}
