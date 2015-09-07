//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ricardo Boccato Alves on 9/6/15.
//  Copyright (c) 2015 Ricardo Boccato Alves. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {

    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var receivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    private func playAudio(rate: Float = 1, pitch: Float = 1, timeDelay: NSTimeInterval = 0, wetDryMix: Float = 0) {
        // If there is any audion being played, stops it.
        audioEngine.stop()
        audioEngine.reset()
        
        // Creates the elements of the audio pipeline.
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        audioEngine.attachNode(changePitchEffect)
        
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = timeDelay
        audioEngine.attachNode(echoEffect)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = wetDryMix
        audioEngine.attachNode(reverbEffect)
        
        // Connects the elements: player -> pitch -> echo -> reverb -> output
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playAudioChipmunk(sender: UIButton) {
        playAudio(pitch: 1000)
    }
    
    @IBAction func playAudioDarthVader(sender: UIButton) {
        playAudio(pitch: -1000)
    }
    
    @IBAction func playAudioFast(sender: UIButton) {
        playAudio(rate: 1.5)
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        playAudio(rate: 0.5)
    }

    @IBAction func playAudioEcho(sender: UIButton) {
        playAudio(timeDelay: 1)
    }
    
    @IBAction func playAudioReverb(sender: UIButton) {
        playAudio(wetDryMix: 50)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
    }
}
