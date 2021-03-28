//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Adam Poustka on 2021-03-25.
//

import Foundation
import Alamofire
import SwiftyJSON


//MARK: - WeatherManagerDelegate protocol
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

//MARK: - WeatherManager struct
struct WeatherManager {
    
    let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    // The API key needs to be added here, otherwise performRequest function finds nil
    let APIKey: String = "ENTER_YOUR_API_KEY_HERE"
    var delegate: WeatherManagerDelegate?
    
    // Function to get weather for specific city
    func fetchWeather(for cityName: String) {
            if let city = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                // Creating URL String that is used to fetch the weather
                let urlString = weatherURL + "&appid=\(APIKey)&q=\(city)"
                performRequest(with: urlString) { (weatherModel) in
                    if let weather = weatherModel {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
        }
    
    // Function to perform request with URL String, using Alamofire for networking.
    func performRequest(with urlString: String, completion: @escaping (WeatherModel?) -> Void) {

            AF.request(urlString).responseJSON(completionHandler: { (response) in
                // Switching over response result, when the call was successful, parse json to WeatherModel struct
                switch response.result {
                case .success(let value):
                    let safeData = JSON(value)
                    
                    if let id = safeData["weather"][0]["id"].int, let name = safeData["name"].string, let temp = safeData["main"]["temp"].double {
                        
                        let weather = WeatherModel(conditionID: id, name: name, temperature: temp)
                        completion(weather)
                    } else {
                        print("Found nil")
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
}
    
//MARK: - Fetch weather on start up. Based on lat and long
// Function that is used to fetch weather on latitude and longitude. Works like func fetchWeather(for cityName). 
extension WeatherManager {
    func fetchWeather(lat: Double, lon: Double) {
        let lat = lat
        let lon = lon
        let urlString = weatherURL + "&appid=\(APIKey)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString) { (weatherModel) in
            if let weather = weatherModel {
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
        }
        
    }
}
