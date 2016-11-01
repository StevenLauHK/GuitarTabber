//
//  NoteRecogniser.swift
//  Guitar Tabber
//
//  Created by David Ivorra on 18/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import Foundation
import TuningFork

/*class NoteRecogniser: TunerDelegate {
    var song: Song
    var currentNote: RawNote?

    // The thresholds for detecting end and begining of note
    let loweThreshold: Double = 10.0 // we'll have to test it and modify
    let upperThreshold: Double = 2.0 // same
    
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        let pitch = output.pitch
        let octave = output.octave
        let amplitude = output.amplitude
        let distance = output.distance

        // If the upper threshold is surpassed, finishes the last note and create a new one
        if amplitude > upperThreshold {
            if let note = currentNote {
                note.finish()
                song.insertRawNote(note)
            }
            currentNote = RawNote(pitch, octave, distance)
        }

        // If the lower threshold is surpassed, finishes the current note and create a new silence
        if amplitude < lowerThrewhold {
            if let note = currentNote {
                note.finish()
                song.insertRawNote(note)
            }
            currentNote = RawNote("", 0, 0)
        }
    }

    init() {
       let tuner = Tuner()
       let delegate = MyTunerDelegate()
       tuner.delegate = delegate
       tuner.start()
    }
}*/
