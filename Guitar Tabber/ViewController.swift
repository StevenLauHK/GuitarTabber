//
//  ViewController.swift
//  Guitar Tabber
//
//  Created by Lau Kin Wai on 7/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.

import AudioKit
import TuningFork
import UIKit
import SFGaugeView

class ViewController: UIViewController, TunerDelegate {
    public var tuner: Tuner = Tuner()
    private var pitch: String = ""
    private var octave: Int = 0
    public private(set) var distance: Float = 0.0
    
    private let amplitudeThreshold: Float = 0.009
    
    @IBOutlet var saugeView: SFGaugeView!
    
    @IBAction func startButton(_ sender: AnyObject) {
        tuner.start()
    }
    
    @IBAction func stopButton(_ sender: AnyObject) {
        tuner.stop()
        noteLabel.text = "--"
        saugeView.currentLevel = 50
    }
    
    @IBOutlet var noteLabel: UILabel!
    
    public var note: String { get { return pitch + String(octave) } }
    
    internal func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        pitch = output.pitch
        octave = output.octave
        
        let amplitude = output.amplitude
        let frequency = output.frequency
        
        if amplitude > amplitudeThreshold {
            let display = output.pitch + String(output.octave)
            noteLabel.text = display
            let a: Float = pow(2.0, (1.0 / 12.0))
            
            if output.distance < 0 {
                distance = output.distance / (output.frequency - output.frequency / a)
            } else {
                distance = output.distance / (output.frequency * a - output.frequency)
            }
            distance += 0.5
            distance *= 100
        } else {
            let display = "--"
            noteLabel.text = display
            distance = 50
        }
        
        saugeView.currentLevel = Int(distance)
        
        print(output.pitch, output.octave, amplitude, frequency, distance)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tuner.delegate = self
        noteLabel.text = "--"
        
        saugeView.maxlevel = 100
        saugeView.minlevel = 0
        saugeView.hideLevel = true
        
        saugeView.bgColor = UIColor.black
        
        saugeView.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}


