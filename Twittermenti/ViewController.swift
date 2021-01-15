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
        
    }
    
    func getSecrets() {
        if let path = Bundle.main.path(forResource: "Swifter", ofType: "plist") {
            swifterSecrets = NSDictionary(contentsOfFile: path)
        }
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text {
        
            swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<100 {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                do {
                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    
                    var sentimentScore = 0
                    
                    for pred in predictions {
                        let sentiment = pred.label
                        
                        if sentiment == "Pos" {
                            sentimentScore += 1
                        } else if sentiment == "Neg" {
                            sentimentScore -= 1
                        }
                    }
                    
                    if sentimentScore > 20 {
                        self.sentimentLabel.text = "😍"
                    } else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😄"
                    } else if sentimentScore > 0 {
                        self.sentimentLabel.text = "😐"
                    } else if sentimentScore == 0 {
                        self.sentimentLabel.text = "😕"
                    } else if sentimentScore > -10 {
                        self.sentimentLabel.text = "☹️"
                    } else if sentimentScore > -20 {
                        self.sentimentLabel.text = "😡"
                    } else {
                        self.sentimentLabel.text = "🤮"
                    }
                    
                } catch {
                    print("There was an error with making a prediction, \(error)")
                }
                
                
            } failure: { (error) in
                print("There was an error with the Twitter API Request, \(error)")
            }
            
        }
    
    }
    
}

