//
//  Song.swift
//  Guitar Tabber
//
//  Created by David Ivorra on 18/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import Foundation
import Darwin

public enum NoteDuration: Int {
    case whole = 1, half = 2, quarter = 4, eighth = 8, sixteenth = 16
    
    public func getDuration() -> Float {
        return 1.0 / Float(rawValue)
    }
}
    
public class Note {
    public var noteDuration: NoteDuration
    public var dotted: Bool
    public var time: Float {
        get {
            if dotted {
                return noteDuration.getDuration() * 1.5
            } else {
                return noteDuration.getDuration()
            }
        }
        set(value){
            noteDuration = NoteDuration.init(rawValue: Int(1.0 / value))!
        }
    }
    public var inGuitar: (Int, Int) {
        get {
            let s6 = pitch + 12 * octave - (4 + 2 * 12)
            if s6 < 7 { return (6, s6) }
            
            let s5 = s6 - 5
            if s5 < 7 { return (5, s5) }
            
            let s4 = s5 - 5
            if s4 < 12 { return (4, s4) }
            
            let s3 = s4 - 5
            if s3 < 12 { return (3, s3) }
            
            let s2 = s3 - 4
            if s2 < 12 { return (2, s2) }
            
            let s1 = s2 - 5
            return (1, s1)
        }
    }
    
    public private(set) var pitch: Int
    public private(set) var octave: Int
    
    
    public private(set) var ligated: Bool
    
    public init(noteDuration: NoteDuration, pitch: Int, octave: Int, isLigated ligated: Bool =
        false, isDotted dotted: Bool = false) {
        self.noteDuration = noteDuration
        self.dotted = dotted
        self.pitch = pitch
        self.octave = octave
        self.ligated = ligated
    }
    
    // Creates a new silence
    public init(silenceDuration duration: NoteDuration, isLigated ligated: Bool =
        false, isDotted dotted: Bool = false) {
        noteDuration = duration
        pitch = 0
        octave = 0
        self.dotted = dotted
        self.ligated = ligated
    }
}

public class Compass {
    public internal(set)var notes: [Note] = []
    public var timeSignature: (Int, Int)
    public var tempo: Int
    
    init(signature timeSignature: (Int, Int), tempo: Int) {
        self.timeSignature = timeSignature
        self.tempo = tempo
    }
    
    init(copy compass: Compass) {
        notes = compass.notes
        tempo = compass.tempo
        timeSignature = compass.timeSignature
    }
    
    // Tries to inserts the note in the compass and returns true if it can, false if it can't
    public func insertNote(note: Note) -> Bool {
        if remainingTime() < note.time {
            return false
        }
        notes.append(note)
        return true
    }
    
    // Returns the remaining time of the compass
    public func remainingTime() -> Float {
        // 4/4 -> 1
        // 2/4 -> 0.5
        // 4/2 -> 2
        let totalTime: Float = Float(timeSignature.0) / Float(timeSignature.1)
        var remainingTime = totalTime
        for n in notes {
            remainingTime -= n.time
        }
        return remainingTime
    }

    // Splits the note to fit in the compass and returns the remaining
    public func insertPartial(note: Note) -> [Note] {
        if remainingTime() <= 0 { return [note] }
        
        var newNotes = [Note]()
        
        for dur in splitDurations(durations: note.time - remainingTime()) {
            let newNote = Note(noteDuration: dur, pitch: note.pitch, octave: note.octave,isLigated: true)
            newNotes.append(newNote)
        }
        
        for dur in splitDurations(durations: remainingTime()) {
            note.time = dur.getDuration()
            notes.append(note)
        }
        return newNotes
    }
    
    private func splitDurations(durations d: Float) -> [NoteDuration] {
        var nds = [NoteDuration]()
        var dur = d
        for i in 0...4 {
            while dur - (1.0 / pow(2, Float(i)) ) >= 0 {
                dur -= (1.0 / pow(2, Float(i)))
                nds.append(NoteDuration.init(rawValue: Int(pow(2, Float(i))))!)
            }
        }
        return nds
    }
}

public class Song: CustomStringConvertible {
    internal var compasses: [Compass] = []

    public private(set)var tempo: Int
    public private(set)var timeSignature: (Int, Int)
   
    // Returns the lenght of the a song compass in seconds
    public var compassTimeInSeconds: Float {
        get {
            return 60.0 / Float(tempo) * Float(timeSignature.1)
            //NoteDuration.init(rawValue: timeSignature.1)!.getDuration()
        }
    }
    
    public var description: String {
        get {
            var res: String = ""
            res += "Tempo: \(tempo)\tSignature: \(timeSignature.0) \(timeSignature.1)\n"
            for compass in compasses {
                for note in compass.notes {
                    res += "(\(note.pitch) \(note.octave) 1/\(note.noteDuration.rawValue))\t"
                }
                res += "\n"
            }
            
            return res
        }
    }
    
    init(tempo: Int, timeSignature: (Int, Int)) {
        self.tempo = tempo
        self.timeSignature = timeSignature
        compasses.append(Compass(signature: timeSignature, tempo: tempo))
    }

    // Inserts a raw note (from the micriphone) into the compass
    public func insertRawNote(noteToInsert rawNote: RawNote) {
        // Gets the raw note and aproximates the real duration to a theorical one
        let rawDuration: Double = Double(compassTimeInSeconds / rawNote.duration * Float(timeSignature.1) / Float(timeSignature.0))
        var duration = Int(pow(2, round(log2(rawDuration))))

        if (duration <= 16) {
            if duration == 0 { duration = 1 }
            let type = NoteDuration.init(rawValue: duration)!
            var note: Note
            
            // if the note pitch is -1, creates a silence
            if rawNote.pitch == -1 {
                note = Note(silenceDuration: type)
            } else {
                note = Note(noteDuration: type, pitch: rawNote.pitch, octave: rawNote.octave)
            }
            
            insertNotes(severalNotes: [note])
        }
    }
    
    public func insertNotes(severalNotes rnotes: [Note]) {
        var lastCompass = compasses[compasses.endIndex - 1]
        
        // Tries to insert the note in the last compass. If it does not fit, it creates new
        // compasses and tries to fit the note in them recursively
        for note in rnotes {
            if !lastCompass.insertNote(note: note) {
                let newNotes = lastCompass.insertPartial(note: note)
                compasses.append(Compass(signature: timeSignature, tempo: tempo))
                insertNotes(severalNotes: newNotes)
                lastCompass = compasses[compasses.endIndex - 1]
            }
        }
    }
}
