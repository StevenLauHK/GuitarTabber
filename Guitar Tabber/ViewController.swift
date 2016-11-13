//
//  ViewController.swift
//  Guitar Tabber
//
//  Created by Lau Kin Wai on 7/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.

import AudioKit
import TuningFork
import UIKit

class ViewController: UIViewController, TunerDelegate {
    public var tuner: Tuner = Tuner()
    private var pitch: String = ""
    private var octave: Int = 0
    public private(set) var distance: Float = 0.0
    
    private let amplitudeThreshold: Float = 0.009

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var amplitudeLabel: UILabel!
    
    @IBAction func startButton(_ sender: AnyObject) {
        tuner.start()
    }
    
    @IBAction func stopButton(_ sender: AnyObject) {
        tuner.stop()
        noteLabel.text = "--"
    }
    
    @IBOutlet var noteLabel: UILabel!
    
    public var note: String { get { return pitch + String(octave) } }
    
    internal func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        pitch = output.pitch
        octave = output.octave
        distance = output.distance
        
        let amplitude = output.amplitude
        let frequency = output.frequency
        
        if amplitude > amplitudeThreshold {
            let display = output.pitch + String(output.octave)
            noteLabel.text = display
        } else {
            let display = "--"
            noteLabel.text = display
        }
        
        print(output.pitch, output.octave, amplitude, frequency)
    }

    func setupPlot() {
        let mic = tuner.getMicrophone()
        let plot = AKAudioFFTPlot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tuner.delegate = self
        noteLabel.text = "--"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}


