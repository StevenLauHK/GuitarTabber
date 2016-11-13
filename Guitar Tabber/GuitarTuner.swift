//
//  Tuner.swift
//  Guitar Tabber
//
//  Created by Lau Kin Wai on 7/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import Foundation
import TuningFork

class GuitarTuner: TunerDelegate {
    public var tuner: Tuner

    private var pitch: String
    private var octave: Int
    public private(set) var distance: Float

    public var note: String { get { return pitch + String(octave) } }

    init() {
        
        tuner = Tuner()
        pitch = ""
        octave = 0
        distance = 0.0
        tuner.delegate = self
        tuner.start()
    }

    internal func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        pitch = output.pitch
        octave = output.octave
        distance = output.distance
        print(output.pitch, output.octave)
    }
    
    
    

    //
}
