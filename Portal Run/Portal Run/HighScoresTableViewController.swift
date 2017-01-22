//
//  HighScoresTableViewController.swift
//  Portal Run
//
//  Created by Phat Pham on 12/6/16.
//  Copyright © 2016 Portal Run Team. All rights reserved.
//

import UIKit
import CoreData

class HighScoresTableViewController: UITableViewController {
    
    static var highScores: [Int]!
    
    var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "High Scores"
        self.view.backgroundColor = UIColor.yellow
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "highScoreCell")
        
        self.segmentedControl = UISegmentedControl.init(items: ["Personal", "Global"])
        self.segmentedControl.frame = CGRect.init(x: 35, y: 200, width: 250, height: 50)
        self.segmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.view.addSubview(segmentedControl)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HighScoresTableViewController.highScores = ScoreboardData.topScoresDescending
        HighScoresTableViewController.savePersonalHighScores()
    }
    
    @objc private func segmentAction() {
        switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            print("Personal high score are desired.")
            HighScoresTableViewController.highScores = ScoreboardData.topScoresDescending
        case 1:
            print("Global high scores are desired.")
            HighScoresTableViewController.highScores = []
        default: break
        }
        self.tableView.reloadData()
    }
    
    class func savePersonalHighScores() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDHighScores1", in: managedContext)
        if #available(iOS 10.0, *) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDHighScores1")
            do {
                let dataRecords = try managedContext.fetch(fetchRequest)
                for shownItems in dataRecords {
                    managedContext.delete(shownItems as! NSManagedObject)
                }
                
            } catch {
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        for i in 0..<HighScoresTableViewController.highScores.count {
            let highScoresInCoreData = NSManagedObject(entity: entity!, insertInto: managedContext) // Creates a new record for the table
            highScoresInCoreData.setValue(ScoreboardData.topScoresDescending[i], forKey: "score") // Fills the new record with data
            
            do {
                try managedContext.save()
            } catch {
                
            }
        }
        
        appDelegate.saveContext()

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return HighScoresTableViewController.highScores.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScoreCell", for: indexPath)
        cell.textLabel?.text = "\(1 + indexPath.row). \(HighScoresTableViewController.highScores[indexPath.row]) seconds"
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
