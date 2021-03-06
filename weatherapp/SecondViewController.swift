//
//  SecondViewController.swift
//  weatherapp
//
//  Created by Niko Mattila on 01/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    var forecast = ForecastModel()
    var currentImageInArray = 0
    let defaultDB = UserDefaults.standard
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecast.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ForecastTableViewCell
        let tempWeather = self.forecast.list[indexPath.row]
        currentImageInArray = indexPath.row
        cell.mainLabel?.text = tempWeather.weather[0].main + " " + String(tempWeather.main.temp) + " °C"
        cell.subLabel?.text = tempWeather.dt_txt
        cell.weatherImage?.image = UIImage(named: tempWeather.weather[0].icon)
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadingIcon.startAnimating()
        if self.defaultDB.integer(forKey: "selectedRow") == 0 {
            let lat = String(self.defaultDB.double(forKey: "lat"))
            let lon = String(self.defaultDB.double(forKey: "lon"))
            Fetcher.fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast/?lat=" + lat + "&lon=" + lon + "&units=metric&appid=4cba6b9833216c9b1ebc19387da17489", callback: self.doneFetchingForecast)
        } else {
            let utf8str = String(utf8String: (defaultDB.string(forKey: "selectedCity")?.cString(using: .utf8)!)!)
            Fetcher.fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast/?q=" + utf8str! + "&units=metric&appid=4cba6b9833216c9b1ebc19387da17489", callback: self.doneFetchingForecast)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadingIcon.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doneFetchingForecast(data: Data?, response: URLResponse?, error: Error?) {
        //let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        guard let fetchedWeather = try? JSONDecoder().decode(ForecastModel.self, from: data!) else {
            print("Error during fetching")
            return
        }
        self.forecast = fetchedWeather
        DispatchQueue.main.async(execute: {() in
            self.tableView.reloadData()
            self.loadingIcon.stopAnimating()
        })
    }
}

