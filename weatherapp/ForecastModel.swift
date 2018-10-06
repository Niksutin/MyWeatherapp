//
//  ForecastModel.swift
//  weatherapp
//
//  Created by Niko Mattila on 04/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import Foundation

struct ForecastModel : Decodable {
    
    var list: [WeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
    
    init() {
        self.list = []
    }
}
