//
//  GuessPlayerViewController.swift
//  RO-SHAM-BILL
//
//  Created by Jason Stanley on 12/11/17.
//  Copyright © 2017 Jason Stanley. All rights reserved.
//

import UIKit
import CoreData

class GuessPlayerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    
var arrayOfNumbers: [NSManagedObject] = [];
    
    var lowNum = 1
    var highNum = 1000
    var chosenNum = 0
    var numOfPlayers = 2
    var playerNum = 1
    var guessNum = 1
    var didWin: Bool = false
    var gameNumber: Int = 0;
    
    
    var window: UIWindow?
    
    var guessNumOptions: [Int] = []
    var game: NSManagedObject?
    
    @IBOutlet weak var playerNumLabel: UILabel!
    
    @IBOutlet weak var lowNumLabel: UILabel!
    
    @IBOutlet weak var guessPicker: UIPickerView!
    
    @IBOutlet weak var highNumLabel: UILabel!
    
    @IBOutlet weak var higherLabel: UILabel!
    
    @IBOutlet weak var upArrowImage: UIImageView!
    
    @IBOutlet weak var winnerLabel: UILabel!
    
    @IBOutlet weak var winnerImage: UIImageView!
    
    @IBOutlet weak var lowerLabel: UILabel!
    
    @IBOutlet weak var downArrowImage: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)

    }
    
    
    @IBAction func startButtonClicked(_ sender: Any) {
        
//         newGuess(gameObject: game!, guessNum: guessNum)
         let getLastGameNumber = retrieveGameNumber()
        
        if(guessNum < chosenNum && guessNum != chosenNum){
            lowNumLabel.text = "\(guessNum)"
            downArrowImage.isHidden = true
            upArrowImage.isHidden = false
           lowerLabel.text = "Higher!"
            lowNum = guessNum
            guessNumOptions = Array(lowNum...highNum)
           self.higherLabel.text = ""
        
            playerCounter()
            guessPicker.reloadAllComponents()
            guessPicker.selectRow(0, inComponent: 0, animated: false)
            insertIntoGuessesTable(didWin: false, playerNumber: playerNum, curGameNumber: Int(getLastGameNumber))
            
        } else if(guessNum > chosenNum) {
            highNumLabel.text = "\(guessNum)"
            higherLabel.text = "Lower!"
            downArrowImage.isHidden = false
            upArrowImage.isHidden = true
            highNum = guessNum
            guessNumOptions = Array(lowNum...highNum)
            self.lowerLabel.text = ""
            playerCounter()
            guessPicker.reloadAllComponents()
            let lastRowIndex = guessNumOptions.count - 1
            guessPicker.selectRow(lastRowIndex, inComponent: 0, animated: false)
              insertIntoGuessesTable(didWin: false, playerNumber: playerNum, curGameNumber: Int(getLastGameNumber))
        } else {
            winnerLabel.text = "\(guessNum) was correct. Player \(playerNum) Wins!"
            winnerImage.isHidden = false
            self.lowerLabel.text = ""
            self.higherLabel.text = ""
            
            upArrowImage.isHidden = true
            downArrowImage.isHidden = true
            startButton.isEnabled = false
            startButton.isHidden = true
            guessPicker.isHidden = true
              insertIntoGuessesTable(didWin: true, playerNumber: playerNum, curGameNumber: Int(getLastGameNumber))
        }
        
        
    }
    func playerCounter(){
        if(playerNum < numOfPlayers){
            playerNum += 1
            playerNumLabel.text = "\(playerNum)"
        }else{
            playerNum = 1
            playerNumLabel.text = "\(playerNum)"
        }
    }
    
    func insertIntoGuessesTable(didWin: Bool, playerNumber: Int, curGameNumber: Int )
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Display Error")
            
            return;
        }
        
        let context = appDelegate.persistentContainer.viewContext;
        
        let entity = NSEntityDescription.entity(forEntityName: "Guesses", in:context);
        
        let numberDemo = NSManagedObject(entity:entity!, insertInto:context);
        
        
        numberDemo.setValue(Int(curGameNumber), forKeyPath: "gameNum");
        
        numberDemo.setValue(Int(guessNum.description), forKeyPath: "guessNum")
        
        numberDemo.setValue(Int(playerNum.description), forKeyPath: "playerNum")
        
        numberDemo.setValue(Bool(didWin.description), forKeyPath: "win")
        
        
        do {
            //6
            try context.save()
        } catch let error as NSError {
            print("Display Error - \(error)")
        }
        
    }
    
    func retrieveGameNumber() -> Int {
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
               
            }
            
            
            
        } catch let error as NSError {
            print("display error - \(error)")
        }
        
        return gameNumber
    }

    
    func newGuess(gameObject:NSManagedObject, guessNum:Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            print("display error")
            
            return;
        }
        let context = appDelegate.persistentContainer.viewContext;
        
        let entity = NSEntityDescription.entity(forEntityName: "Guesses", in:context)
        
        let guess = NSManagedObject(entity:entity!, insertInto:context)
    
        
        guess.setValue(guessNum, forKey: "guessNum")
        guess.setValue(playerNum, forKey: "playerNum")
        
        do {
            try context.save()
            
        } catch let error  as NSError {
            print("Error \(error)")
        }
    }
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return guessNumOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == guessPicker)
        {
            guessNum = Int(guessNumOptions[row]);
        }
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return guessNumOptions[row].description
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
//            print("display error")
//
//            return;
//        }
//        let context = appDelegate.persistentContainer.viewContext;
//
//        let entity = NSEntityDescription.entity(forEntityName: "Games", in:context)
//
//        let newGame = NSManagedObject(entity:entity!, insertInto:context)
//
//        let gameID = Int(arc4random_uniform(UInt32(Int(500000))))
//
//        newGame.setValue(Date(),forKeyPath: "date")
//        newGame.setValue(gameID, forKey: "gameNum")
//        newGame.setValue(self.chosenNum,forKeyPath: "chooseNumber")
//        newGame.setValue(self.highNum, forKeyPath: "highNum")
//        newGame.setValue(self.lowNum, forKeyPath: "lowNum")
//        newGame.setValue(self.playerNum, forKeyPath: "playerNum")
//
//
//        
//
//        do {
//            try context.save()
//
//            game = newGame
//
//        } catch let error  as NSError {
//            print("Error \(error)")
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downArrowImage.isHidden = true
        upArrowImage.isHidden = true
        winnerImage.isHidden = true
        guessNumOptions = Array(lowNum...highNum)
        lowNumLabel.text = lowNum.description
        highNumLabel.text = highNum.description
        playerNumLabel.text = "\(playerNum.description)"
        self.lowerLabel.text = ""
        self.higherLabel.text = ""
        self.winnerLabel.text = ""
        guessPicker?.dataSource = self;
        guessPicker?.delegate = self;

        // Do any additional setup after loading the view.
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
