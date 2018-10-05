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
    
    var forecast = ForecastModel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecast.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let tempWeather = self.forecast.list[indexPath.row]
        cell.textLabel?.text = tempWeather.weather[0].main + " " + String(tempWeather.main.temp) + " °C"
        cell.detailTextLabel?.text = tempWeather.dt_txt
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast/?q=London,uk&units=metric&appid=4cba6b9833216c9b1ebc19387da17489")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUrl(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        guard let fetchedForecast = try? JSONDecoder().decode(ForecastModel.self, from: data!) else {
            print("Error during fetching")
            return
        }
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            NSLog(resstr!)
            self.forecast = fetchedForecast
            self.tableView.reloadData()
        })
    }
    
}

