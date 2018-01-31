//
//  TableViewController.swift
//  AidChain
//
//  Created by Arun Ramakani on 1/27/18.
//  Copyright © 2018 Arun Ramakani. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableViewController: UITableViewController {

    var count = 0
    public var weatherData:[String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = "Forcast"
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
        return count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell
        cell.fruitImageView?.image = UIImage(named: "Unknownw")
        
        var fullNameArr = Array(weatherData.keys)[indexPath.row].components(separatedBy: "T")
        cell.label.text = fullNameArr[0]
        
        var text = weatherData[Array(weatherData.keys)[indexPath.row]]
        
        print(text)
        
        cell.label2.text = "Temprature: " + text! + " F"
//        if(indexPath.row==0){
//
//            cell.label2.text = "500 Euro"
//            cell.fruitImageView?.image = UIImage(named: "nepal")
//        } else if(indexPath.row==1){
//            cell.label.text = "Science Research Fund"
//            cell.label2.text = "200 Euro"
//            cell.fruitImageView?.image = UIImage(named: "images")
//        } else {
//            cell.label.text = "Disaster Relief Fund"
//            cell.label2.text = "50 Euro"
//            cell.fruitImageView?.image = UIImage(named: "disaster-relief")
//        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        self.navigationController?.pushViewController(nextVC, animated: true)

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
