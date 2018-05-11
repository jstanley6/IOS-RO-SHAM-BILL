//
//  PromptServerViewController.swift
//  RO-SHAM-BILL
//
//  Created by Jason Stanley on 12/21/17.
//  Copyright © 2017 Jason Stanley. All rights reserved.
//

import UIKit

class PromptServerViewController: UIViewController {

    @IBAction func okButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "promptServerIdentifier", sender: self)
    }
    var lowNum: Int?
    var highNum: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "promptServerIdentifier") {
            let destinationVC = segue.destination as! ServerViewController
            destinationVC.lowNum = self.lowNum!
            destinationVC.highNum = self.highNum!
            
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
