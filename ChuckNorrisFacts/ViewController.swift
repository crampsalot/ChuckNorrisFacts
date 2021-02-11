//
//  ViewController.swift
//  ChuckNorrisFacts
//
//  Created by Isa Hashim on 2/22/18.
//  Copyright © 2018 Crampsalot LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var factTextView: UITextView!
    @IBOutlet weak var getAnotherButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }

    @IBAction func getAnotherPressed(_ sender: Any) {
        getAnotherButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.bringSubview(toFront: activityIndicator)
        
        ChuckNorrisFactsService.sharedInstance.getFact { (fact, errorString) in
            DispatchQueue.main.async {
                self.getAnotherButton.isEnabled = true
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
            if let errorString = errorString {
                DispatchQueue.main.async {
                    self.factTextView.text = errorString
                }
                
                return
            }
            
            if let fact = fact {
                DispatchQueue.main.async {
                    self.factTextView.text = fact
                }
            }
        }
    }
}

