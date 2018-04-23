//
//  DexcomCGMTableViewController.swift
//  Loop
//
//  Created by Renee on 16/03/2018.
//  Copyright © 2018 LoopKit Authors. All rights reserved.
//

import UIKit
import HealthKit

class DexcomCGMTableViewController: UITableViewController, IdentifiableClass {
    
    
    @IBOutlet weak var sensorStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let sensorState = self.deviceManager.cgmManager?.sensorState {
            sensorStateLabel?.text = sensorState.stateDescription
        } else {
            sensorStateLabel?.text = "–"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calibrate(_ sender: UIButton) {
        let dialog = UIAlertController(title: "Enter BG", message: "Calibrate sensor.", preferredStyle: .alert)
        
        let unit = HKUnit.millimolesPerLiter()
        
        dialog.addTextField { (textField : UITextField!) in
            textField.placeholder = unit.glucoseUnitDisplayString
            textField.keyboardType = .decimalPad
        }
        
        dialog.addAction(UIAlertAction(title: "Calibrate", style: .default, handler: { (action: UIAlertAction!) in
            let textField = dialog.textFields![0] as UITextField
            let minGlucose = HKQuantity(unit: HKUnit.milligramsPerDeciliter(), doubleValue: 40)
            let maxGlucose = HKQuantity(unit: HKUnit.milligramsPerDeciliter(), doubleValue: 400)
            
            if let text = textField.text, let entry = Double(text) {
                guard entry >= minGlucose.doubleValue(for: unit) && entry <= maxGlucose.doubleValue(for: unit) else {
                    // TODO: notify the user if the glucose is not in range
                    return
                }
                let glucose = HKQuantity(unit: unit, doubleValue: Double(entry))
                guard let cgmManager = self.deviceManager.cgmManager as? G5CGMManager else {
                    return
                }
                cgmManager.calibrate(to: glucose)
            }
        }))
        
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(dialog, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
    //
    //        cell.textLabel?.text = "State"
    //
    //        if let sensorState = self.deviceManager.cgmManager?.sensorState {
    //            cell.detailTextLabel?.text = sensorState.stateDescription
    //        } else {
    //            cell.detailTextLabel?.text = "–"
    //        }
    //
    //        return cell
    //    }
    //
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Section \(section)"
    //    }
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
    
    weak var deviceManager: DeviceDataManager!
}
