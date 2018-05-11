//
//  Games.swift
//  RO-SHAM-BILL
//
//  Created by Jason Stanley on 12/10/17.
//  Copyright © 2017 Jason Stanley. All rights reserved.
//

import Foundation

class Game: NSObject, NSCoding {
    
    struct PropertyKeys {
        static let highNum = "highNum"
        static let lowNum = "lowNum"
        
    }
    
    let highNum: Int
    let lowNum: Int
    
    
    override var description: String {
        return " Server please choose a number between  \(lowNum) - \(highNum)"
    }
    
    init(highNum: Int, lowNum: Int) {
        self.highNum = highNum
        self.lowNum = lowNum
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let highNum = aDecoder.decodeObject(forKey: PropertyKeys.highNum) as? Int,
            let lowNum = aDecoder.decodeObject(forKey: PropertyKeys.lowNum) as? Int
            else {return nil}
        
        self.init(highNum: highNum, lowNum: lowNum)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(highNum, forKey: PropertyKeys.highNum)
        aCoder.encode(lowNum, forKey: PropertyKeys.lowNum)
        
    }
    
}
