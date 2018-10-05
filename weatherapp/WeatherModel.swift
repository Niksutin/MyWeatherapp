//
//  WeatherModel.swift
//  weatherapp
//
//  Created by Niko Mattila on 01/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import Foundation
import UIKit

struct WeatherModel: Decodable {
    
    let main: WeatherMain
    let weather: [WeatherInfo]
    let dt_txt: String?
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
        case weather = "weather"
        case dt_txt = "dt_txt"
    }
}

struct WeatherMain : Decodable {
    
    let temp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
    }
}

struct WeatherInfo : Decodable {
    
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}
