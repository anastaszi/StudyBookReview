//
//  ListTableViewController.swift
//  StudyBookReview
//
//  Created by Anastasia Zimina on 3/22/21.
//

import UIKit
import os.log

class ListTableViewController: UITableViewController {
    var myData = [ReviewData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myData = ReviewData.defaultData

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myData.count
    }
    
 
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DataTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DataTableViewCell else {
            fatalError("The dequed cell is not and instance of TableViewCell")
        }
        
        let currentData = myData[indexPath.row]
        cell.title.text = currentData.title
        cell.author.text = currentData.author
        cell.review.text = currentData.review
        cell.bookPic.image = currentData.photo
        if (currentData.attitude == "like") {
            cell.attitudeImg.image = UIImage(named: "emoji-heart-eyes-fill")
        } else if (currentData.attitude == "dislike") {
            cell.attitudeImg.image = UIImage(named: "emoji-frown-fill")
        } else {
            cell.attitudeImg.image = nil
        }
        
        
        // Configure the cell...
        print("Book: ")
        print(currentData.author!)
        print(currentData.attitude!)
        return cell
    }
 

 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ReviewViewController, let prevdata=sourceViewController.newReview {
            let newIndexPath = IndexPath(row: myData.count, section: 0)
            myData.append(prevdata)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        if let sourceViewController = sender.source as? ReviewDetailsViewController, let prevdata=sourceViewController.reviewData {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //This code checks whether a row in the table view is selected.
                myData[selectedIndexPath.row] = prevdata
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
        //ReviewData.saveMyData(mydata: myData)
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
            case "addItem":
                os_log("Adding a new data.", log: OSLog.default, type: .debug)
            
            case "ShowDetails":
                guard let detailViewController = segue.destination as? ReviewDetailsViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }

                guard let selectedCell = sender as? DataTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }

                guard let indexPath = tableView.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                let selectedData = myData[indexPath.row]
                detailViewController.reviewData = selectedData
            
        default:
            print("Unknow Segue Identifier")
    }

    }
}
