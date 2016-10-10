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
    private var tuner: Tuner

    private var pitch: String
    private var octave: Int
    public private(set) var distance: Float

    public var note: String { get { return pitch + String(octave) } }

    init() {
        tuner = Tuner()
        tuner.delegate = self
        tuner.start()
    }

    internal func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        pitch = output.pitch
        octave = output.octave
        distance = output.distance
    }
}
