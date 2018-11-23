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

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeLocationDelegate {
    
    //MARK: - Constants
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "157e330ee04468899e6487c542beea2a"
    
    //MARK: - Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
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
        
        let tempResult = json["main"]["temp"].doubleValue
        let locationName = json["name"].stringValue
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.locationName = locationName
        
        updateViewFromModel()
    }
    
    
    
    //MARK: - Update View from Model
    
    func updateViewFromModel() {
        
        locationLabel.text = weatherDataModel.locationName
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
    }
    
    //MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy >= 0 {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        locationLabel.text = "Location Unavailable"
    }
    
    //MARK: - Change Location Delegate methods
    
    func didEnterNewLocationName(locationName: String) {
        
        let params: [String: String] = ["q": locationName, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
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

