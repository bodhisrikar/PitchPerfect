//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Srikar Thottempudi on 11/22/18.
//  Copyright © 2018 Srikar Thottempudi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordStatusLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: The view is going to appear and stop button should be disabled as nothing is being played
    override func viewWillAppear(_ animated: Bool) {
        stopRecordingButton.isEnabled = false
    }

    // MARK: Recording the audio
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(recordingState: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recordingState: false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // Only if the audio has finished recording succesfully the segue is performed.
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            let recordingErrorAlert = UIAlertController(title:"Recording Error", message: "Audio was not recorded. Please record again", preferredStyle: .alert)
            recordingErrorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(recordingErrorAlert, animated: true, completion: nil)
            configureUI(recordingState: false)
        }
    }
    
    //MARK: Preparing for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: configuring the UI in Record Sounds
    func configureUI(recordingState isRecording:Bool) {
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        recordStatusLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
    }
}

