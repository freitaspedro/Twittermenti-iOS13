//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    private var swifter: Swifter!
    
    private var swifterSecrets: NSDictionary! {
        didSet {
            if let key = swifterSecrets?.object(forKey: "TWITTER_CONSUMER_KEY") as? String,
               let secret = swifterSecrets?.object(forKey: "TWITTER_CONSUMER_SECRET") as? String {
                self.swifter = Swifter(consumerKey: key, consumerSecret: secret)
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSecrets()
        
    }
    
    func getSecrets() {
        if let path = Bundle.main.path(forResource: "Swifter", ofType: "plist") {
            swifterSecrets = NSDictionary(contentsOfFile: path)
        }
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

