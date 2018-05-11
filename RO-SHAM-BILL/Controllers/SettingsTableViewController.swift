//
//  SettingsTableViewController.swift
//  RO-SHAM-BILL
//
//  Created by Jason Stanley on 12/6/17.
//  Copyright © 2017 Jason Stanley. All rights reserved.
//


import UIKit
import CoreData

class SettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    var lowNum: Int = 1
    var highNum: Int = 1
    
    var startingPickerHidden = true
    var endingPickerHidden = true
    
    var startingPickerData = Array(1...1000)
    var endingPickerData = Array(1...1000)
    
    @IBOutlet weak var startingLabel: UILabel!
    
    @IBOutlet weak var endingLabel: UILabel!
    
    @IBOutlet weak var startingPicker: UIPickerView!
    
    @IBOutlet weak var endingPicker: UIPickerView!
    
    var settings:[NSManagedObject] = []
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Display Error")
            
            return;
        }
        
         let context = appDelegate.persistentContainer.viewContext;
        
        if ErrorCheckNumbers() == true {
            
           // self.performSegue(withIdentifier: "unwindToMain", sender: self)
//            print("Your starting point is \(lowNum) and your ending point is \(highNum)")
            
            let entity = NSEntityDescription.entity(forEntityName: "Settings", in:context);
            
            //5
            let settings = NSManagedObject(entity:entity!, insertInto:context);
            
            settings.setValue(Int(startingLabel.text!), forKeyPath: "lowNum")
            settings.setValue(Int(endingLabel.text!), forKeyPath: "highNum")
            
            do {
                //6
                try context.save()
            } catch let error as NSError {
                print("Display Error - \(error)")
            }
            
            
            
            
        } else {
            
            // don't save;
        }
        }
    
 
    
    func ErrorCheckNumbers() -> Bool {
    
        if(lowNum > highNum) {
            let alertController = UIAlertController(title: "Alert", message: "Please Make Sure Your Ending Number is Greater than Your Starting Number.", preferredStyle: .alert)

            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return false
        }else if (lowNum == highNum){
            
                let alertController = UIAlertController(title: "Alert", message: "Please Make Sure Your Starting and Ending Numbers Aren't Equal.", preferredStyle: .alert)

                let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                 return false
        } else {
            return true
        }
    }
        
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView == startingPicker) {
            return startingPickerData.count
        } else {
            return endingPickerData.count
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
      
        
        if (pickerView == startingPicker) {
            
            return String(startingPickerData[row])
            
        } else {
            return String(endingPickerData[row])
        }
        
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {


        if (pickerView == startingPicker) {
            lowNum = startingPickerData[row]
        } else if pickerView == endingPicker
        {
            highNum = endingPickerData[row]
            startingPickerHidden = !startingPickerHidden
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        switch component {
        case 0:
            attributedString = NSAttributedString(string: String(startingPickerData[row]), attributes: [NSAttributedStringKey.foregroundColor : UIColor.yellow])
        case 1:
            attributedString = NSAttributedString(string: String(endingPickerData[row]), attributes: [NSAttributedStringKey.foregroundColor : UIColor.yellow])
        default:
            attributedString = nil
        }
        
        return attributedString
    }


    
    
   
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.startingPicker.delegate = self
        self.startingPicker.dataSource = self
        self.endingPicker.delegate = self
        self.endingPicker.dataSource = self
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
        case [0,0]:
            return startingPickerHidden ? normalCellHeight : largeCellHeight
          
        case [1,0]:
            return endingPickerHidden ? normalCellHeight : largeCellHeight
            
        default: return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        switch (indexPath) {
        case [0,0]:
            startingLabel.text = String(lowNum)
            startingPicker.backgroundColor = .black
            startingPickerHidden = !startingPickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
        case [1,0]:
            endingLabel.text = String(highNum)
            endingPicker.backgroundColor = .black
            endingPickerHidden = !endingPickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            
            default: break
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        destinationVC.lowNum = self.lowNum
        destinationVC.highNum = self.highNum
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "unwindToMain" {
           
            return ErrorCheckNumbers()
            
        }
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
        return true
    }
    

    
}

