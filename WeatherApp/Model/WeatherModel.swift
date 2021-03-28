//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Adam Poustka on 2021-03-25.
//

import Foundation

// WeatherModel struct in which the weather data for certain location are stored.

struct  WeatherModel {
    var conditionID: Int = 0
    var name: String = ""
    var temperature: Double = 0.0
    
    var tempAsAString: String {
        return String(format: "%1.f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
