//
//  SongTests.swift
//  Guitar Tabber
//
//  Created by Enrique Mas Candela on 11/11/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import XCTest
@testable import Guitar_Tabber

class SongTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNote() {
        let note = Note(noteDuration: NoteDuration.eighth, pitch: 5, octave: 3)
        assert(note.time == 1.0 / 8.0)
        
        note.dotted = true
        assert(note.time == (1.0 / 8.0) * 1.5)
        
        note.dotted = false
        note.time = 1.0 / 4.0
        assert(note.noteDuration == NoteDuration.quarter)
    }
    
    func testTabConversion() {
        var note = Note(noteDuration: NoteDuration.quarter, pitch: 7, octave: 2)
        assert(note.inGuitar == (6, 3))
        
        note = Note(noteDuration: NoteDuration.quarter, pitch: 0, octave: 3)
        assert(note.inGuitar == (5, 3))
    }
    
    func testSimpleNoteInsertion() {
        let compass = Compass(signature: (4, 4), tempo: 120)
        var remaining = NoteDuration.whole.getDuration()
        assert(compass.remainingTime() == remaining, "Error, remaining \(compass.remainingTime()) instead of \(remaining)")
        
        let quarterNote = Note(noteDuration: NoteDuration.quarter, pitch: 3, octave: 3)
        var correct: Bool
        
        correct = compass.insertNote(note: quarterNote)
        assert(correct)
        remaining -= quarterNote.time
        assert(compass.remainingTime() == remaining, "Error, remaining \(compass.remainingTime()) instead of \(remaining)")
        
        correct = compass.insertNote(note: quarterNote)
        assert(correct)
        remaining -= quarterNote.time
        assert(compass.remainingTime() == remaining, "Error, remaining \(compass.remainingTime()) instead of \(remaining)")
        
        correct = compass.insertNote(note: quarterNote)
        assert(correct)
        remaining -= quarterNote.time
        assert(compass.remainingTime() == remaining, "Error, remaining \(compass.remainingTime()) instead of \(remaining)")
        
        correct = compass.insertNote(note: quarterNote)
        assert(correct)
        remaining -= quarterNote.time
        assert(compass.remainingTime() == remaining, "Error, remaining \(compass.remainingTime()) instead of \(remaining)")
        
        correct = compass.insertNote(note: quarterNote)
        assert(!correct)
    }
    
    func testDifferentSignaturesInsertion() {
        var compass: Compass
        var note: Note
        var correct: Bool
        
        // 4 4
        compass = Compass(signature: (4, 4), tempo: 120)
        note = Note(noteDuration: NoteDuration.whole, pitch: 3, octave: 3)
        assert(compass.remainingTime() == NoteDuration.whole.getDuration())
        correct = compass.insertNote(note: note)
        assert(correct)
        assert(compass.remainingTime() == 0)
        
        // 2 4
        compass = Compass(signature: (2, 4), tempo: 120)
        note = Note(noteDuration: NoteDuration.half, pitch: 3, octave: 3)
        assert(compass.remainingTime() == NoteDuration.half.getDuration())
        correct = compass.insertNote(note: note)
        assert(correct)
        assert(compass.remainingTime() == 0)
        
        // 6 8
        compass = Compass(signature: (6, 8), tempo: 120)
        note = Note(noteDuration: NoteDuration.half, pitch: 3, octave: 3)
        assert(compass.remainingTime() == NoteDuration.half.getDuration() + NoteDuration.quarter.getDuration())
        correct = compass.insertNote(note: note)
        assert(correct)
        note = Note(noteDuration: NoteDuration.quarter, pitch: 3, octave: 3)
        correct = compass.insertNote(note: note)
        assert(correct)
        assert(compass.remainingTime() == 0)
        
        // 4 8
        compass = Compass(signature: (4, 8), tempo: 120)
        note = Note(noteDuration: NoteDuration.half, pitch: 3, octave: 3)
        assert(compass.remainingTime() == NoteDuration.half.getDuration())
        correct = compass.insertNote(note: note)
        assert(correct)
        assert(compass.remainingTime() == 0)
    }
    
    func testInsertPartialNote() {
        var compass: Compass
        var note: Note
        var correct: Bool
        
        compass = Compass(signature: (4, 4), tempo: 120)
        note = Note(noteDuration: NoteDuration.half, pitch: 3, octave: 3)
        correct = compass.insertNote(note: note)
        assert(correct)
        
        note = Note(noteDuration: NoteDuration.whole, pitch: 3, octave: 3)
        correct = compass.insertNote(note: note)
        assert(!correct)
        let newNotes = compass.insertPartial(note: note)
        
        
        assert(compass.remainingTime() == 0)

        assert(newNotes[0].time == NoteDuration.half.getDuration())
        assert(newNotes[0].ligated)
    }
    
    func testSimpleRawNoteInsertion() {
        let tempo: Int = 120
        let timeSignature = (4, 4)
        let song = Song(tempo: tempo, timeSignature: timeSignature)
        let compassDuration = 60.0 / Float(tempo) * Float(timeSignature.1)
        let wholeDuration: Float = compassDuration * (Float(timeSignature.1) / Float(timeSignature.0))

        let rawNote = RawNote(pitch: "C", octave: 3)
        rawNote.finish()
        rawNote.startTime = 0.0
        rawNote.endTime = Double(wholeDuration) / 4.0
        
        song.insertRawNote(noteToInsert: rawNote)
        
        let lastCompass = song.compasses[song.compasses.endIndex - 1]
        let insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
        assert(insertedNote.noteDuration == NoteDuration.quarter)
        assert(insertedNote.pitch == rawNote.pitch)
        assert(insertedNote.dotted == false)
        assert(insertedNote.octave == rawNote.octave)
    }
    
    func testSimpleRawNoteWithErrorInsertion() {
        let tempo: Int = 120
        let timeSignature = (4, 4)
        let song = Song(tempo: tempo, timeSignature: timeSignature)
        let compassDuration = 60.0 / Float(tempo) * Float(timeSignature.1)
        let wholeDuration: Float = compassDuration * (Float(timeSignature.1) / Float(timeSignature.0))
        
        let rawNote = RawNote(pitch: "C", octave: 3)
        rawNote.finish()
        rawNote.startTime = 0.0
        rawNote.endTime = Double(wholeDuration) / 4.0 * 1.12
        
        song.insertRawNote(noteToInsert: rawNote)
        
        var lastCompass = song.compasses[song.compasses.endIndex - 1]
        var insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
        assert(insertedNote.noteDuration == NoteDuration.quarter)
        assert(insertedNote.pitch == rawNote.pitch)
        assert(insertedNote.dotted == false)
        assert(insertedNote.octave == rawNote.octave)
        
        rawNote.startTime = 0.0
        rawNote.endTime = Double(wholeDuration) / 4.0 * 0.9
        
        song.insertRawNote(noteToInsert: rawNote)
        
        lastCompass = song.compasses[song.compasses.endIndex - 1]
        insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
        assert(insertedNote.noteDuration == NoteDuration.quarter)
        assert(insertedNote.pitch == rawNote.pitch)
        assert(insertedNote.dotted == false)
        assert(insertedNote.octave == rawNote.octave)
        
        rawNote.startTime = 0.0
        rawNote.endTime = Double(wholeDuration) / 8.0 * 0.8
        
        song.insertRawNote(noteToInsert: rawNote)
        
        lastCompass = song.compasses[song.compasses.endIndex - 1]
        insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
        assert(insertedNote.noteDuration == NoteDuration.eighth)
        assert(insertedNote.pitch == rawNote.pitch)
        assert(insertedNote.dotted == false)
        assert(insertedNote.octave == rawNote.octave)
    }
    
    func testMultipleCompassesInsertion() {
        let tempo: Int = 120
        let timeSignature = (4, 4)
        let song = Song(tempo: tempo, timeSignature: timeSignature)
        
        let compassDuration = 60.0 / Float(tempo) * Float(timeSignature.1)
        let wholeDuration: Float = compassDuration * (Float(timeSignature.1) / Float(timeSignature.0))
        
        let rawNote = RawNote(pitch: "C", octave: 3)
        rawNote.finish()
        rawNote.startTime = 0
        rawNote.endTime = Double(wholeDuration) / 8.0
        
        var lastCompass: Compass = song.compasses[song.compasses.endIndex - 1]
        
        for _ in 0...3 {
            song.insertRawNote(noteToInsert: rawNote)
            lastCompass = song.compasses[song.compasses.endIndex - 1]
            let insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
            assert(insertedNote.noteDuration == NoteDuration.eighth)
        }
        
        assert(lastCompass.remainingTime() == NoteDuration.half.getDuration())
        rawNote.endTime = Double(wholeDuration) / 4.0
        
        
        for _ in 0...1 {
            song.insertRawNote(noteToInsert: rawNote)
            lastCompass = song.compasses[song.compasses.endIndex - 1]
            let insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
            assert(insertedNote.noteDuration == NoteDuration.quarter)
        }
        
        assert(lastCompass.remainingTime() == 0)
        
        song.insertRawNote(noteToInsert: rawNote)
        lastCompass = song.compasses[song.compasses.endIndex - 1]
        var insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
        assert(insertedNote.noteDuration == NoteDuration.quarter)
        
        song.insertRawNote(noteToInsert: rawNote)
        lastCompass = song.compasses[song.compasses.endIndex - 1]
        insertedNote = lastCompass.notes[lastCompass.notes.endIndex - 1]
        assert(insertedNote.noteDuration == NoteDuration.quarter)
        
        assert(lastCompass.remainingTime() == NoteDuration.half.getDuration())
        assert(song.compasses.count == 2)
        
        print(song)
    }
}
