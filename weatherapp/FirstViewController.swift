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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.currentCity.text = "Under construction"
        Fetcher.fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric&appid=4cba6b9833216c9b1ebc19387da17489", callback: self.doneFetchingCurrentWeather)
    }
    
    func doneFetchingCurrentWeather(data: Data?, response: URLResponse?, error: Error?) {
        guard let fetchedWeather = try? JSONDecoder().decode(WeatherModel.self, from: data!) else {
            print("Error during fetching")
            return
        }
        DispatchQueue.main.async(execute: {() in
            self.currentTemperature.text = String(fetchedWeather.main.temp) + " °C"
            self.currentWeatherImage.image = UIImage(named: fetchedWeather.weather[0].icon)
        })
    }
}

