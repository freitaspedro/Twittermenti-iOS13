//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
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
        
//        let prediction = try! sentimentClassifier.prediction(text: "@Apple is a terrible company!")
//
//        print(prediction.label)
        
        swifter.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
            
            var tweets = [String]()
            
            for i in 0..<100 {
                if let tweet = results[i]["full_text"].string {
                    tweets.append(tweet)
                }
            }
            
            print(tweets)
            
            
        } failure: { (error) in
            print("There was an error with the Twitter API Request, \(error)")
        }

        
    }
    
    func getSecrets() {
        if let path = Bundle.main.path(forResource: "Swifter", ofType: "plist") {
            swifterSecrets = NSDictionary(contentsOfFile: path)
        }
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

