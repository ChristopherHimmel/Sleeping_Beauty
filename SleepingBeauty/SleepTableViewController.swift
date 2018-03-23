//
//  SleepTableViewController.swift
//  SleepingBeauty
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class SleepTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var sleeps = [Sleep]()
    var totalOverUnder = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize header over/under
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
        let defaults = UserDefaults.standard
        totalOverUnder = Double(defaults.string(forKey: "startingHours") ?? "0")!
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved sleeps, otherwise load sample data.
        if let savedSleeps = loadSleeps() {
            sleeps += savedSleeps
        }
        else {
        // Load the sample data.
            loadSampleSleeps()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleeps.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SleepTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SleepTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SleepTableViewCell.")
        }
        
        // Fetches the appropriate sleep for the data source layout.
        let sleep = sleeps[indexPath.row]
        
        cell.hoursOverUnderLabel.text = sleep.hoursOverUnder
        //cell.photoImageView.image = sleep.photo
        //cell.ratingControl.rating = sleep.rating
        cell.entryTimeStamp.text = sleep.entryTimeStamp

        totalOverUnder += Double(sleep.hoursOverUnder)!
        self.title = "Your Sleep (Over/Under \(String(totalOverUnder)))"
        
        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            sleeps.remove(at: indexPath.row)
            saveSleeps()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
        
        case "AddItem":
            os_log("Adding a new sleep.", log: OSLog.default, type: .debug)
        
        case "ShowDetail":
            guard let sleepDetailViewController = segue.destination as? SleepViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedSleepCell = sender as? SleepTableViewCell else {
                fatalError("Expected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedSleepCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedSleep = sleeps[indexPath.row]
            sleepDetailViewController.sleep = selectedSleep
        
        default:
            fatalError("Expected Segue Identifier; \(segue.identifier)")
        
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToSleepList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SleepViewController, let sleep = sourceViewController.sleep {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing sleep.
                sleeps[selectedIndexPath.row] = sleep
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }

            else {
                // Add a new sleep.
                let newIndexPath = IndexPath(row: sleeps.count, section: 0)
                sleeps.append(sleep)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the sleeps.
            saveSleeps()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleSleeps() {
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")

        guard let sleep1 = Sleep(hoursOverUnder: "1", photo: photo1, rating: 4, entryTimeStamp: "") else {
            fatalError("Unable to instantiate sleep1")
        }

        guard let sleep2 = Sleep(hoursOverUnder: "-1", photo: photo2, rating: 5, entryTimeStamp: "") else {
            fatalError("Unable to instantiate sleep2")
        }

        guard let sleep3 = Sleep(hoursOverUnder: "-1.5", photo: photo3, rating: 3, entryTimeStamp: "") else {
            fatalError("Unable to instantiate sleep3")
        }

        sleeps += [sleep1, sleep2, sleep3]
    }

    private func saveSleeps() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(sleeps, toFile: Sleep.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Sleeps successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Sleeps...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadSleeps() -> [Sleep]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Sleep.ArchiveURL.path) as? [Sleep]
    }
}
