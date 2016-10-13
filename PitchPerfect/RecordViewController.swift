//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Chris Amanse on 10/11/2016.
//  Copyright © 2016 Chris Amanse. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    
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
        
        // Update UI
        
        recordingLabel.text = "Recording in Progress..."
        
        recordButton.isEnabled = false
        stopRecordingButton.isEnabled = true
        
        // Record
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("recordedVoice.wav")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            let audioRecorder = try AVAudioRecorder(url: fileURL, settings: [:])
            
            self.audioRecorder = audioRecorder
            
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch let error {
            print("Failed to record audio: \(error)")
        }
    }
    
    @IBAction func didPressStopRecordingButton(_ sender: UIButton) {
        print("Stop recording pressed")
        
        recordingLabel.text = "Tap to Record"
        
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        
        // Stop recording
        
        audioRecorder?.stop()
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            print("Failed to set audio session to inactive: \(error)")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording finished!")
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: recorder.url)
        } else {
            print("Failed to save audio recording")
        }
    }
}
