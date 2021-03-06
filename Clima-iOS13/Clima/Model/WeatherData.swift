//
//  WeatherData.swift
//  Clima
//
//  Created by Aleksa Novcic on 25.2.22..
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Double
}

struct Weather: Decodable{
    let id: Int
    let description: String
    
}
