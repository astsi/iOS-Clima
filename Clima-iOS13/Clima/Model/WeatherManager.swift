//
//  WeatherManager.swift
//  Clima
//
//  Created by Aleksa Novcic on 25.2.22..
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=c2c10ccf986b6e4c22dcccc8a09b4f26&units=metric"
    let weatherURL2 = "api.openweathermap.org/data/2.5/weather?&appid=c2c10ccf986b6e4c22dcccc8a09b4f26&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //1.Create a URL
        let components = transformURLString(urlString)
        if let url = components?.url{
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            //3.Give the session a task
            let task = session.dataTask(with: url) {(data, urlResponse, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print (dataString!)
                    if let weather = parseJSON(safeData){
                        delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            //4.Start the task
            task.resume()
            //NOT: task.start() - tasks start in a suspended state
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let city = decodedData.name
            let temperature = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: city, temperature: temperature)
            return weather
//            print(weather.conditionName())
//            print(weather.temperatureString())
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //aditional code - from StackOverflow, reason: URL(string: ) not always working
    func transformURLString(_ string: String) -> URLComponents? {
        guard let urlPath = string.components(separatedBy: "?").first else {
            return nil
        }
        var components = URLComponents(string: urlPath)
        if let queryString = string.components(separatedBy: "?").last {
            components?.queryItems = []
            let queryItems = queryString.components(separatedBy: "&")
            for queryItem in queryItems {
                guard let itemName = queryItem.components(separatedBy: "=").first,
                      let itemValue = queryItem.components(separatedBy: "=").last else {
                          continue
                      }
                components?.queryItems?.append(URLQueryItem(name: itemName, value: itemValue))
            }
        }
        return components!
    }
}


