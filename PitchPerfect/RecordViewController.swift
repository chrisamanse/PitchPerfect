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
        
        // Hide navigation bar and set status bar color to white
        
        navigationController?.navigationBar.isHidden = true
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show navigation bar and set status bar color to default
        
        navigationController?.navigationBar.isHidden = false
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    
    @IBAction func didPressRecordButton(_ sender: UIButton) {
        print("Record button pressed")
        
        // Update UI
        
        configureUI(forState: .recording)
        
        // Record
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("recordedVoice.wav")
        
        let session = AVAudioSession.sharedInstance()
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try session.overrideOutputAudioPort(.speaker)
                
                let audioRecorder = try AVAudioRecorder(url: fileURL, settings: [:])
                
                self.audioRecorder = audioRecorder
                
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
                
                print("Successfully started recording")
            } catch let error {
                print("Failed to record audio: \(error)")
                
                // Update UI in main thread if start recording failed
                
                DispatchQueue.main.async {
                    self.showErrorAlert(title: "Error Recording", message: "Failed to start recording.")
                    
                    self.configureUI(forState: .stoppedRecording)
                }
            }
        }
    }
    
    @IBAction func didPressStopRecordingButton(_ sender: UIButton) {
        print("Stop recording pressed")
        
        // Update UI
        
        configureUI(forState: .stoppedRecording)
        
        // Stop recording
        
        audioRecorder?.stop()
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            print("Failed to set audio session to inactive: \(error)")
        }
    }
    
    // MARK: Functions
    
    func configureUI(forState state: RecordingState) {
        let recordingText: String
        let enableRecordingButton: Bool
        
        switch state {
        case .recording:
            recordingText = "Recording in Progress..."
            enableRecordingButton = false
        case .stoppedRecording:
            recordingText = "Tap to Record"
            enableRecordingButton = true
        }
        
        recordingLabel.text = recordingText
        recordButton.isEnabled = enableRecordingButton
        stopRecordingButton.isEnabled = !enableRecordingButton
    }
    
    func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording finished!")
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: recorder.url)
        } else {
            showErrorAlert(title: "Error Recording", message: "Failed to save audio recording to file.")
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording",
            let destinationVC = segue.destination as? PlayViewController,
            let url = sender as? URL {
            
            // Pass recorded audio URL
            destinationVC.recordedAudioURL = url
        }
    }
}

extension RecordViewController {
    enum RecordingState {
        case recording
        case stoppedRecording
    }
}
