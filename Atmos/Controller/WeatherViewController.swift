//
//  WeatherViewController.swift
//  Atmos
//
//  Created by Maulik Sharma on 22/11/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

//MARK: - Constants

struct weatherAPIConstants {
    static let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
    static let apiID = "157e330ee04468899e6487c542beea2a"
}

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeLocationDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    //MARK: - Instance Variables
    
    let locationManager = CLLocationManager()
    var weatherDataModel = WeatherDataModel()
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    //MARK: - Networking
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            [weak self] response in
            if response.result.isSuccess {
                
                if let resultValue = response.result.value {
                    let weatherInfo: JSON = JSON(resultValue)
                    print(weatherInfo)
                    self?.updateWeatherDataModel(json: weatherInfo)
                }
            }
            else {
                print(String(describing: response.result.error))
            }
        }
    }
    
    //MARK: - Parsing
    
    func updateWeatherDataModel(json: JSON) {
        
        let locationName = json["name"].stringValue
        let currTempResult = json["main"]["temp"].doubleValue
        let minTempResult = json["main"]["temp_min"].doubleValue
        let maxTempResult = json["main"]["temp_max"].doubleValue
        let pressureResult = json["main"]["pressure"].doubleValue
        let humidityResult = json["main"]["humidity"].doubleValue
        let weatherCode = json["weather"][0]["id"].intValue
        
        weatherDataModel.locationName = locationName
        weatherDataModel.currTemp = Int(currTempResult - 273.15)
        weatherDataModel.minTemp = Int(minTempResult - 273.15)
        weatherDataModel.maxTemp = Int(maxTempResult - 273.15)
        weatherDataModel.pressure = Int(pressureResult)
        weatherDataModel.humidity = Int(humidityResult)
        weatherDataModel.weatherKeyword = WeatherDataModel.getWeatherKeyword(condition: weatherCode)
        updateViewFromModel()
    }
    
    
    
    //MARK: - Update View from Model
    
    func updateViewFromModel() {
        
        locationLabel.text = weatherDataModel.locationName
        temperatureLabel.text = "\(weatherDataModel.currTemp)°C"
        minLabel.text = "Min: \(weatherDataModel.minTemp)°C"
        maxLabel.text = "Max: \(weatherDataModel.maxTemp)°C"
        pressureLabel.text = "Pressure: \(weatherDataModel.pressure) hpa"
        humidityLabel.text = "Humidity: \(weatherDataModel.humidity) %"
        weatherConditionLabel.text = weatherDataModel.weatherKeyword
        
    }
    
    //MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy >= 0 {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String: String] = ["lat": latitude, "lon": longitude, "appid": weatherAPIConstants.apiID]
            getWeatherData(url: weatherAPIConstants.weatherURL, parameters: params)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        locationLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change Location Delegate methods
    
    func didEnterNewLocationName(locationName: String) {
        
        let params: [String: String] = ["q": locationName, "appid": weatherAPIConstants.apiID]
        getWeatherData(url: weatherAPIConstants.weatherURL, parameters: params)
    }
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeLocation" {
            if let changeLocationVC = segue.destination as? ChangeLocationViewController {
                changeLocationVC.delegate = self
            }
        }
    }
    
    
}

