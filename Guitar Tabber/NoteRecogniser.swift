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
    var currentNoteFrequencies: [(String):Int]
    
    var lastFrequencies: [Float] = []

    // The thresholds for detecting end and begining of note
    let lowerThreshold: Float = 0.003 // we'll have to test it and modify
    let upperThreshold: Float = 0.3 // same
    
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        let amplitude = output.amplitude

        // If the upper threshold is surpassed, finishes the last note and create a new one
        if amplitude > upperThreshold && lastFrequencies.reduce(true, { $0 && ($1 < upperThreshold) }) {
            if let note = currentNote {
                var myArr = Array(currentNoteFrequencies.keys)
                
                for (n, c) in currentNoteFrequencies {
                    print("\(n), \(c)")
                }
                
                myArr.sort() {
                    let obj1 = currentNoteFrequencies[$0]
                    let obj2 = currentNoteFrequencies[$1]
                    return obj1! > obj2!
                }
                
                if !myArr.isEmpty {
                    var pitch_octave = myArr[0].components(separatedBy: " ")
                    let pitch = pitch_octave[0]
                    let octave = Int(pitch_octave[1])!
                    note.setPitch(pitch: pitch)
                    note.octave = octave
                    
                    print("Note finished by start of another")
                    note.finish()
                    song.insertRawNote(noteToInsert: note)
                }
            }
            currentNoteFrequencies = [(String):Int]()
            
            currentNote = RawNote(pitch: output.pitch, octave: output.octave)
            
            print("Note started")
        }
        
        lastFrequencies.append(amplitude)
        if lastFrequencies.count > 5 {
            lastFrequencies.remove(at: 0)
        }

        // If the lower threshold is surpassed, finishes the current note and create a new silence
        
        if lastFrequencies.reduce(true, { $0 && ($1 < lowerThreshold) })  {
            if let note = currentNote {
                var myArr = Array(currentNoteFrequencies.keys)
                
                if myArr.count > 1 {
                    myArr.sort() {
                        let obj1 = currentNoteFrequencies[$0]
                        let obj2 = currentNoteFrequencies[$1]
                        return obj1! > obj2!
                    }
                    
                    var pitch_octave = myArr[0].components(separatedBy: " ")
                    let pitch = pitch_octave[0]
                    let octave = Int(pitch_octave[1])!
                    note.setPitch(pitch: pitch)
                    note.octave = octave
                    
                    print("Note finished by end of itself")
                    note.finish()
                    song.insertRawNote(noteToInsert: note)
                    currentNote = nil
                }
                
            }
            if !(song.compasses.count == 1 && song.compasses[0].notes.count == 0) {
                currentNote = RawNote(pitch: "", octave: 0)
            }
        }
 
        
        if let current = currentNote {
            if current.pitch != 0 {
                if let rep = currentNoteFrequencies[output.pitch + " " + String(output.octave)] {
                    currentNoteFrequencies[output.pitch + " " + String(output.octave)] = rep + 1
                } else {
                    currentNoteFrequencies[output.pitch + " " + String(output.octave)] = 1
                }
            }
        }
    }

    init(song: Song) {
        currentNoteFrequencies = [:]
        self.song = song
        let tuner = Tuner()
        tuner.delegate = self
        tuner.start()
    }
    
    public func getSong() -> Song {
        return song
    }
}
