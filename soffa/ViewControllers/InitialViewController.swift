//
//  ViewController.swift
//  soffa
//
//  Created by MR.CHEMALY on 11/19/17.
//  Copyright © 2017 we-devapp. All rights reserved.
//

import UIKit

class InitialViewController: BaseViewController {

    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var buttonBegin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonBeginTapped(_ sender: Any) {
        self.redirectToVC(storyboardId: StoryboardIds.LoginViewController, type: .Push)
    }
    
}

