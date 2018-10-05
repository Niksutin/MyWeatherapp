//
//  FirstViewController.swift
//  weatherapp
//
//  Created by Niko Mattila on 01/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentTemperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.currentCity.text = "Under construction"
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric&appid=4cba6b9833216c9b1ebc19387da17489")
    }
    
    func fetchUrl(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        // let resstr = String(data: data!, encoding: String.Encoding.utf8)
        guard let fetchedWeather = try? JSONDecoder().decode(WeatherModel.self, from: data!) else {
            print("Error during fetching")
            return
        }
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            self.currentTemperature.text = String(fetchedWeather.main.temp) + " °C"
            // NSLog(resstr!)
        })
    }

}

