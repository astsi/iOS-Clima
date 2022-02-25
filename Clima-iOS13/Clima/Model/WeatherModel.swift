//
//  WeatherModel.swift
//  Clima
//
//  Created by Aleksa Novcic on 25.2.22..
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    func temperatureString() -> String {
        return String(format: "%.1f", temperature)
    }
    
    func conditionName() -> String {
        switch conditionId {
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
        default:
            return "cloud"
        }
    }
}
