//
//  FirstViewController.swift
//  weatherapp
//
//  Created by Niko Mattila on 01/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentTemperature: UILabel!
    
    var locationManager : CLLocationManager = CLLocationManager()

    
    struct GlobalVariable {
        static var isGPSOn: Bool = true
        static var city: String = "Not found"
        static var lat: Double = 0.0
        static var lon: Double = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        FirstViewController.GlobalVariable.lat = locations[0].coordinate.latitude
        FirstViewController.GlobalVariable.lon = locations[0].coordinate.longitude
        CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0] as CLPlacemark
                FirstViewController.GlobalVariable.city = pm.locality!
                print(FirstViewController.GlobalVariable.lat, FirstViewController.GlobalVariable.lon)
                let lat = String(FirstViewController.GlobalVariable.lat)
                let lon = String(FirstViewController.GlobalVariable.lon)
                Fetcher.fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&units=metric&appid=4cba6b9833216c9b1ebc19387da17489", callback: self.doneFetchingCurrentWeather)
            } else {
                print("Problem with the data received from geocoder")
            }
            self.locationManager.stopUpdatingLocation()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() && FirstViewController.GlobalVariable.isGPSOn {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            Fetcher.fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=" + FirstViewController.GlobalVariable.city + "&units=metric&appid=4cba6b9833216c9b1ebc19387da17489", callback: self.doneFetchingCurrentWeather)
        }
    }
    
    func doneFetchingCurrentWeather(data: Data?, response: URLResponse?, error: Error?) {
        guard let fetchedWeather = try? JSONDecoder().decode(WeatherModel.self, from: data!) else {
            print("Error during fetching")
            return
        }
        
        DispatchQueue.main.async(execute: {() in
            self.currentTemperature.text = String(fetchedWeather.main.temp) + " °C"
            self.currentWeatherImage.image = UIImage(named: fetchedWeather.weather[0].icon)
            self.currentCity.text = FirstViewController.GlobalVariable.city
        })
    }
}

