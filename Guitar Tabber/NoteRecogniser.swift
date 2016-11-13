//
//  NoteRecogniser.swift
//  Guitar Tabber
//
//  Created by David Ivorra on 18/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import Foundation
import TuningFork

class NoteRecogniser: TunerDelegate {
    var song: Song
    var currentNote: RawNote?

    // The thresholds for detecting end and begining of note
    let lowerThreshold: Float = 10.0 // we'll have to test it and modify
    let upperThreshold: Float = 2.0 // same
    
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        let pitch = output.pitch
        let octave = output.octave
        let amplitude = output.amplitude

        // If the upper threshold is surpassed, finishes the last note and create a new one
        if amplitude > upperThreshold {
            if let note = currentNote {
                note.finish()
                song.insertRawNote(noteToInsert: note)
            }
            currentNote = RawNote(pitch: pitch, octave: octave)
        }

        // If the lower threshold is surpassed, finishes the current note and create a new silence
        if amplitude < lowerThreshold {
            if let note = currentNote {
                note.finish()
                song.insertRawNote(noteToInsert: note)
            }
            currentNote = RawNote(pitch: "", octave: 0)
        }
    }

    init(song: Song) {
        self.song = song
        let tuner = Tuner()
        tuner.delegate = self
        tuner.start()
    }
    
    public func getSong() -> Song {
        return song;
    }
}
