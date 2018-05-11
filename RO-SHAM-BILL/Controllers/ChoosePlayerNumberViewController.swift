//
//  ChoosePlayerNumberViewController.swift
//  RO-SHAM-BILL
//
//  Created by Jason Stanley on 12/11/17.
//  Copyright © 2017 Jason Stanley. All rights reserved.
//

import UIKit
import CoreData

class ChoosePlayerNumberViewController: UIViewController, UITextFieldDelegate {
    
    
    var chosenNum: Int?
    var lowNum: Int?
    var highNum: Int?
    var numOfPlayers: Int?
    var arrayOfNumbers: [NSManagedObject] = [];
    var recievedGameNumber: Int = 0;
    

    @IBOutlet weak var enterPlayerNum: UITextField!
    
    @IBOutlet weak var enterButtonClicked: UIButton!
    
    @IBAction func enterButtonClicked(_ sender: Any) {
         insertIntoGamesTable()
        
        if Int(enterPlayerNum.text!)! > 50 || Int(enterPlayerNum.text!)! <= 1 && enterPlayerNum.text == ""{
            let alertController = UIAlertController(title: "Alert", message: "The amount of players you can enter is from 2 - 50, and cannot be left blank. Please try again.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            } else {
           
             self.performSegue(withIdentifier: "playerPick", sender: self)
        }
        
       
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
         self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        
}
    
    func retrieveLastGameNumberInDBs() -> Int {
        //2
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var gameNumber = 0;
        
        //3
        let context = appDelegate.persistentContainer.viewContext;
        
        //4
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Games");
        
        //5
        
        do {
            arrayOfNumbers = try context.fetch(fetchRequest)
            
            let intRow = arrayOfNumbers.last;
            if(arrayOfNumbers.count > 0) {
                
                
                gameNumber = intRow?.value(forKey: "gameNum") as! Int
                
                print("Last game Number in DB is \(gameNumber)")
            }
            
            
            
        } catch let error as NSError {
            print("display error - \(error)")
        }
        
        return gameNumber
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
        
        
        numberDemo.setValue((chosenNum!), forKeyPath: "chooseNumber");
        numberDemo.setValue(Date(), forKeyPath: "date")
        numberDemo.setValue((lowNum!), forKeyPath: "lowNum")
        numberDemo.setValue((highNum!), forKeyPath: "highNum")
        numberDemo.setValue(Int(enterPlayerNum.text!), forKeyPath: "playerNum")
        
        
        let gameID = Int(arc4random_uniform(UInt32(Int(100000000))))
        
        
        numberDemo.setValue(Int(gameID), forKeyPath: "gameNum")
        
        do {
            //6
            try context.save()
        } catch let error as NSError {
            print("Display Error - \(error)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterPlayerNum.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "playerPick") {
            let destinationVC = segue.destination as! GuessPlayerViewController
            destinationVC.numOfPlayers = Int(enterPlayerNum.text!)!
            destinationVC.lowNum = self.lowNum!
            destinationVC.highNum = self.highNum!
            destinationVC.chosenNum = self.chosenNum!
            destinationVC.gameNumber = recievedGameNumber
            print("gameNumber is \(recievedGameNumber)");
        }
        
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
