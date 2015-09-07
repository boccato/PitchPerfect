//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ricardo Boccato Alves on 9/5/15.
//  Copyright (c) 2015 Ricardo Boccato Alves. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var btnPauseResume: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var lblRecording: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    var paused: Bool = false
    
    let msgPaused: String = "Paused!"
    let msgRecording: String = "Recording..."
    let msgTapToRecord: String = "Tap to Record"
    
    private func reset() {
        paused = false
        btnPauseResume.hidden = true
        btnStop.hidden = true
        btnRecord.enabled = true
        lblRecording.text = msgTapToRecord
        btnPauseResume.setImage(UIImage(named: "pause"), forState: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // Save the recorded audio info.
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            // Move to the next scene.
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful.")
            reset()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Pass the recorded audio to the Play Sounds view.
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        btnPauseResume.hidden = false
        btnStop.hidden = false
        btnRecord.enabled = false
        lblRecording.text = msgRecording
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func pauseOrResumeRecording(sender: UIButton) {
        if (paused) {
            audioRecorder.record()
            btnPauseResume.setImage(UIImage(named: "pause"), forState: nil)
            lblRecording.text = msgRecording
            paused = false
        }
        else {
            audioRecorder.pause()
            btnPauseResume.setImage(UIImage(named: "resume"), forState: nil)
            lblRecording.text = msgPaused
            paused = true
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        reset()
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        reset()
    }
}
