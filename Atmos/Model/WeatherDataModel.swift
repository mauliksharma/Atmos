//
//  WeatherDataModel.swift
//  Atmos
//
//  Created by Maulik Sharma on 23/11/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import Foundation

struct WeatherDataModel {
    
    var currTemp : Int = 0
    var minTemp: Int = 0
    var maxTemp: Int = 0
    var pressure: Int = 0
    var humidity: Int = 0
    var locationName : String = ""
    var weatherKeyword: String = ""
    
    static func getWeatherKeyword(condition: Int) -> String {
        switch (condition) {
            
        case 0...300 :
            return "T"
            
        case 301...500 :
            return "R"
            
        case 501...600 :
            return "S"
            
        case 601...700 :
            return "W"
            
        case 701...771 :
            return "E"
            
        case 772...799 :
            return "V"
            
        case 800 :
            return "A"
            
        case 801...804 :
            return "C"
            
        case 900...902 :
            return "Y"
            
        case 903 :
            return "o"
            
        case 904 :
            return "H"
            
        case 905...1000 :
            return "Q"
            
        default :
            return "p"
        }
    }
}
