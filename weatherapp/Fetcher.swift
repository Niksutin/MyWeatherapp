//
//  Fetcher.swift
//  weatherapp
//
//  Created by Niko Mattila on 06/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import Foundation

class Fetcher {
    static func fetchUrl(url : String, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: callback);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
}
