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
        
        navigationController?.navigationBar.isHidden = true
        
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        UIApplication.shared.statusBarStyle = .default
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
            try session.overrideOutputAudioPort(.speaker)
            
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
            // Show error alert
            
            let alertController = UIAlertController(title: "Error Recording", message: "Failed to save audio recording to file.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(alertController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording",
            let destinationVC = segue.destination as? PlayViewController,
            let url = sender as? URL {
            
            // Pass recorded audio URL
            destinationVC.recordedAudioURL = url
        }
    }
}
