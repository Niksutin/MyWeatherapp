//
//  WeatherController.swift
//  weatherapp
//
//  Created by Niko Mattila on 05/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import Foundation
import UIKit

class WeatherController {
    
    var model: WeatherModel {
        set(newModel) {
            self.model = newModel
        }
        get {
            return self.model
        }
    }
    
    init(model: WeatherModel) {
        self.model = model
    }
    
    func fetchWeather(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        guard let fetchedWeather = try? JSONDecoder().decode(WeatherModel.self, from: data!) else {
            print("Error during fetching")
            return
        }
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            NSLog(resstr!)
            self.model = fetchedWeather
        })
    }
    
    func fetchImage() {
        
        let url = "https://openweathermap.org/img/w/" + self.model.weather[0].icon + ".png"
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url2 : URL? = URL(string: url)
        
        let task = session.dataTask(with: url2!, completionHandler: doneFetchingImage)
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetchingImage(data: Data?, response: URLResponse?, error: Error?) {
        guard let image = data else {
            print("Data was not found!")
            return
        }
        
        DispatchQueue.main.async(execute: {() in
            self.model.image = UIImage(data: image)
        })
    }
}
