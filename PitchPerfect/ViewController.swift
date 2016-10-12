//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Chris Amanse on 10/11/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressRecordButton(_ sender: UIButton) {
        print("Record button pressed")
        
        recordingLabel.text = "Recording in Progress..."
        
        recordButton.isEnabled = false
        stopRecordingButton.isEnabled = true
    }
    
    @IBAction func didPressStopRecordingButton(_ sender: UIButton) {
        print("Stop recording pressed")
        
        recordingLabel.text = "Tap to Record"
        
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
    }
}
