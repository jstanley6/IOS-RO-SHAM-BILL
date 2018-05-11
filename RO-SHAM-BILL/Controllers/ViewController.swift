//
//  ViewController.swift
//  RO-SHAM-BILL
//
//  Created by Jason Stanley on 12/6/17.
//  Copyright © 2017 Jason Stanley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   var lowNum: Int?
var highNum: Int?
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playButtonClicked(_ sender: Any) {
        
        
//                let alertController = UIAlertController(title: "Alert", message: "Please Hand Screen To Server.", preferredStyle: .alert)
//
//                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in self.performSegue(withIdentifier: "playIdentifier", sender: nil)}))
//        
//         self.present(alertController, animated: true)
//        print("Starting number is \(lowNum!) and ending number is \(highNum!)")
        
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
        if let settingsViewController = segue.source as? SettingsTableViewController {
            settingsViewController.lowNum = self.lowNum!
            settingsViewController.highNum = self.highNum!
            playButton.isEnabled = true
            print("\(lowNum!) \(highNum!)")
        }
    }
    
//    @IBAction override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    
    
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false 
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "playIdentifier") {
            let destinationVC = segue.destination as! PromptServerViewController
            destinationVC.lowNum = self.lowNum!
            destinationVC.highNum = self.highNum!
        }
    }


}

