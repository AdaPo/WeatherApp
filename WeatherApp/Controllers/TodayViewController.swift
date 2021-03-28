//
//  ViewController.swift
//  WeatherApp
//
//  Created by Adam Poustka on 2021-03-25.
//

import UIKit
import CoreLocation

class TodayViewController: UIViewController {

   // IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var degreeSymbol: UILabel!
    @IBOutlet weak var degreeScaleSymbol: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    
    
    // Instantiating weather and location managers
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpLabels()
        
        // Setting up location manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // Setting up textfield delegate
        searchTextField.delegate = self
        // Setting up manager delegate
        weatherManager.delegate = self

//        weatherManager.fetchWeather(for: "Prague")
//        weatherManager.fetchWeather(lat: 50.073658, lon: 14.418540)
    }
    
    
    // When location button is pressed, location manager requests current location. For simulater location needs to be set manually.
    @IBAction func locationButtonPressed(_ sender: UIButton) {
            locationManager.requestLocation()
        }

}
//MARK: - Textfield delegate methods
// Extension that takes care of textfield behaviour.
extension TodayViewController: UITextFieldDelegate {
  
    // SearchTextField ends editing when user presses search button
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
       }
    
    // Calling fetchWeather(for: city) when textfields ends editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(for: city)
        }
        searchTextField.text = ""
    }
    
    // What happens when user returns from keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
        
    }
    
    // Checking if user entered something
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }

}

//MARK: - WeatherManager delegate methods

extension TodayViewController: WeatherManagerDelegate {
    
    // This delegate method is called whenever the weather is updated. It also displays the weather conditions
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("didUpdateWeather called")
//        cityLabel.isHidden = false
//        temperatureLabel.isHidden = false
//        degreeSymbol.isHidden = false
//        degreeScaleSymbol.isHidden = false
        
        // Going to the main thread to show current weather
          DispatchQueue.main.async {
           
            self.cityLabel.text = weather.name
            self.temperatureLabel.text = weather.tempAsAString
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
          }
    }
    
    // Printing error
    func didFailWithError(error: Error) {
        print("Failed with error: \(error)")
    }
    
    
}

//MARK: - CLLocationDelegate

extension TodayViewController: CLLocationManagerDelegate {
    // Prints error when the request for current location was unsuccessful
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
    
    /* This is called when the current location us updated by locationManager. Fetches weather for current location
    based on lat and lon
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
        }
    }
    
    
}

//MARK: - Label setup
extension TodayViewController {
    // Method to set visibility of labels
    func setUpLabels() {
        cityLabel.sizeToFit()
//        cityLabel.isHidden = true
//        temperatureLabel.isHidden = true
//        degreeSymbol.isHidden = true
//        degreeScaleSymbol.isHidden = true
    }
}
