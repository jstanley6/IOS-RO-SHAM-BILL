//
//  PlayViewController.swift
//  RO-SHAM-BILL
//
//  Created by Jason Stanley on 12/8/17.
//  Copyright © 2017 Jason Stanley. All rights reserved.
//

import CoreData
import UIKit

class ServerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {

    @IBOutlet weak var lowNumLabel: UILabel!
    
    @IBOutlet weak var highNumLabel: UILabel!
    
    @IBOutlet weak var serverPicker: UIPickerView!
    
    
    var arrayOfNumbers: [NSManagedObject] = [];
    var  serverPick: [Int] = []
    
    
     var chosenNum: Int = 0;
    var lowNum: Int = 1
    var highNum: Int = 1000
     var gameNumber: Int = 0;
   
   
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
         self.navigationController?.popToRootViewController(animated: true)
    }
    
 
    
    @IBAction func startButtonClicked(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Display Error")
            
            return;
        }
        
        let context = appDelegate.persistentContainer.viewContext;
        
        let entity = NSEntityDescription.entity(forEntityName: "Games", in:context);
        
        let numberDemo = NSManagedObject(entity:entity!, insertInto:context);
        
        numberDemo.setValue(chosenNum, forKeyPath: "chooseNumber");
        numberDemo.setValue(Date(), forKeyPath: "date")
        numberDemo.setValue(highNum, forKeyPath: "highNum")
        numberDemo.setValue(lowNum, forKeyPath: "lowNum")
        
        do {
            //6
            try context.save()
        } catch let error as NSError {
            print("Display Error - \(error)")
        }
        self.performSegue(withIdentifier: "startIdentifier", sender: self)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return serverPick[row].description;
        
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        return serverPick.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if(pickerView == serverPicker)
        {
            chosenNum = Int(serverPick[row]);
        }
        
    }
    
    func insertIntoGamesTable()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Display Error")
            
            return;
        }
        
        let context = appDelegate.persistentContainer.viewContext;
        
        let entity = NSEntityDescription.entity(forEntityName: "Games", in:context);
        
        let numberDemo = NSManagedObject(entity:entity!, insertInto:context);
        
        
        numberDemo.setValue((chosenNum), forKeyPath: "chooseNumber");
        numberDemo.setValue(Date(), forKeyPath: "date")
        numberDemo.setValue((lowNum), forKeyPath: "lowNum")
        numberDemo.setValue((highNum), forKeyPath: "highNum")
        
        
        let gameID = Int(arc4random_uniform(UInt32(Int(100000000))))
        
        
        numberDemo.setValue(Int(gameID), forKeyPath: "gameNum")
        
        do {
            //6
            try context.save()
        } catch let error as NSError {
            print("Display Error - \(error)")
        }
        
    }
   
    
    func retrieveNumbers() {
        //2
     guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Display Error");
            return;
        }
        //3
        let context = appDelegate.persistentContainer.viewContext;
        
        //4
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Settings");
        
        //5
        
        do {
            arrayOfNumbers = try context.fetch(fetchRequest)
            
//          let intRow = arrayOfNumbers.last;
            
                let lowNum = arrayOfNumbers.last?.value(forKey: "lowNum") as! Int
                let highNum = arrayOfNumbers.last?.value(forKey: "highNum") as! Int
                
                highNumLabel.text! = String(describing:highNum).description
                lowNumLabel.text! = String(describing:lowNum).description
            
            
        } catch let error as NSError {
            print("display error - \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "startIdentifier") {
          let destinationVC = segue.destination as! ChoosePlayerNumberViewController
            destinationVC.lowNum = self.lowNum
            destinationVC.highNum = self.highNum
            destinationVC.chosenNum = self.chosenNum
            destinationVC.recievedGameNumber = gameNumber
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "startIdentifier" {
            if chosenNum < lowNum || chosenNum > highNum {
                return false
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        insertIntoGamesTable()
        retrieveNumbers();
        lowNum = Int(lowNumLabel.text!)!
        highNum = Int(highNumLabel.text!)!
        
       serverPick = Array(lowNum...highNum)
        serverPicker?.dataSource = self;
        serverPicker?.delegate = self;
        
        
        //Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
