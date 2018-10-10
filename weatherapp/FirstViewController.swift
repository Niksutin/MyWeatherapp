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
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    var locationManager : CLLocationManager = CLLocationManager()
    let defaultDB = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingIcon.hidesWhenStopped = true
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
        self.defaultDB.set(lat, forKey: "lat")
        self.defaultDB.set(lon, forKey: "lon")
        
        CLGeocoder().reverseGeocodeLocation(locationManager.location!, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.defaultDB.set(pm.locality!, forKey: "selectedCity")
                Fetcher.fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?lat=" + String(lat) + "&lon=" + String(lon) + "&units=metric&appid=4cba6b9833216c9b1ebc19387da17489", callback: self.doneFetchingCurrentWeather)
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
        self.loadingIcon.startAnimating()
        if CLLocationManager.locationServicesEnabled() && defaultDB.integer(forKey: "selectedRow") == 0 {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            let utf8str = String(utf8String: (self.defaultDB.string(forKey: "selectedCity")?.cString(using: .utf8)!)!)
            Fetcher.fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=" + utf8str! + "&units=metric&appid=4cba6b9833216c9b1ebc19387da17489", callback: self.doneFetchingCurrentWeather)
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
            self.currentCity.text = self.defaultDB.string(forKey: "selectedCity")
            self.loadingIcon.stopAnimating()
        })
    }
}

