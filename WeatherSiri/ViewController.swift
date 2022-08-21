//
//  ViewController.swift
//  WeatherSiri
//
//  Created by Artem Serebriakov on 20.08.2022.
//

import UIKit
import RecastAI
import JSQMessagesViewController

class ViewController: UIViewController
{
    //Vars
    var bot : RecastAIClient?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.bot = RecastAIClient(token : "YOUR_TOKEN")
        self.bot = RecastAIClient(token : "YOUR_TOKEN", language: "YOUR_LANGUAGE")
    }
}
