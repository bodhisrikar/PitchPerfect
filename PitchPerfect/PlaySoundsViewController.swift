//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Srikar Thottempudi on 11/23/18.
//  Copyright © 2018 Srikar Thottempudi. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var recordedAudioURL : URL!
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }

    // MARK: Setting up the audio as view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    // MARK: Playing different sounds for different buttons
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    // MARK: Handling the scenario when user stops the audio
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }

    // MARK: Configuring UI before the screen is shown to the user
    override func viewWillAppear(_ animated: Bool) {
        configureUI(.notPlaying)
    }
    
    // MARK: Need to stop playing the audio if the user navigates away from the current screen.
    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }
    
}
