//
//  ThirdViewController.swift
//  weatherapp
//
//  Created by Niko Mattila on 01/10/2018.
//  Copyright © 2018 Niko Mattila. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = ["Use GPS", "Tampere", "Helsinki", "Turku"]
        
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        cell.textLabel?.text = self.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.data.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.data[sourceIndexPath.row]
        data.remove(at: sourceIndexPath.row)
        data.insert(movedObject, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if(proposedDestinationIndexPath.row == 0) {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        let popup = UIAlertController(title: "Add new city", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Add new City", style: .default) { (alertAction) in
        let textField = popup.textFields![0] as UITextField
            if textField.text != "" {
                self.data.append(textField.text!)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.data.count-1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
        
        popup.addTextField { (textField) in
            textField.placeholder = "Enter city"
        }
        
        popup.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        popup.addAction(cancelAction)
        
        self.present(popup, animated: false)
    }
    
    @IBAction func editPressed(_ sender: Any) {
        let button = sender as! UIBarButtonItem
        if self.tableView.isEditing {
            button.title = "Edit"
            self.tableView.setEditing(false, animated: true)
        } else {
            button.title = "Done"
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
