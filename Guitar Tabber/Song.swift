//
//  Song.swift
//  Guitar Tabber
//
//  Created by David Ivorra on 18/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import Foundation
import Darwin

enum NoteDuration: Int {
    case semibreve = 1, minim = 2, crotchet = 4, quaver = 8, semiquaver = 16, demisemiquaver = 32, hemidemisemiquaver = 64
    
    public func getDuration() -> Float {
        return 1.0 / Float(rawValue)
    }
}

class Note {
    public var noteDuration: NoteDuration
    public var dotted: Bool
    public var time: Float {
        get {
            return noteDuration.getDuration() * 1.5
        }
        set(value){
            noteDuration = NoteDuration.init(rawValue: Int(value))!
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
    public init(silenceDuration duration: NoteDuration) {
        noteDuration = duration
        pitch = 0
        octave = 0
    }
    

}

class Compass {
    public private(set)var notes: [Note] = []
    public var timeSignature: (Int, Int)
    public var tempo: Int
    
    init(signature timeSignature: (Int, Int), tempo: Int) {
        self.timeSignature = timeSignature
        self.tempo = tempo
    }
    
    init(copy compass: Compass) {
        
        notes = compass.notes
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
    public func insertPartial(note: Note) -> Note {
        if remainingTime() <= 0 { return note }
        
        let newNote = Note(noteDuration: NoteDuration(rawValue: Int(note.time - remainingTime()))!, pitch: note.pitch, octave: note.octave,isLigated: true)
        note.time = remainingTime()
        notes.append(note)
        
        return newNote
    }
}

class Song {
    private var compasses: [Compass] = []

    public private(set)var tempo: Int
    public private(set)var timeSignature: (Int, Int)
   
    // Returns the lenght of the a song compass in seconds
    public var compassTimeInSeconds: Float {
        get {
            return 60.0 / tempo * NoteType.init(rawValue: timeSignature.1)?.getDuration()
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
        let rawDuration: Double = Double(rawNote.duration / compassTimeInSeconds)
        let duration = pow(round(log2(rawDuration), 2)

        let type = NoteType.init(rawValue: duration)
        var note: Note

        // if the note pitch is -1, creates a silence
        if rawNote.pitch == -1 {
            note = Note(duration: duration)
        } else {
            note = Note(duration: duration, pitch: rawNote.pitch, octave: rawNote.octave)
        }

        var lastCompass = compasses[compasses.endIndex - 1]
        
        // Tries to insert the note in the last compass. If it does not fit, it creates new
        // compasses and tries to fit the note in them recursively
        if !lastCompass.insertNote(note: note) {
            repeat {
                let newNote = lastCompass.insertPartial(note: note)
                compasses.append(Compass(signature: timeSignature, tempo: tempo))
                lastCompass = compasses[compasses.endIndex - 1]
            } while (!lastCompass.insertNote(note: note))
        }
    }
}
