//
//  RecorderController.swift
//  Guitar Tabber
//
//  Created by Enrique Mas Candela on 10/11/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class RecorderController: UIViewController {

    var song: Song?
    var recogniser: NoteRecogniser?
    
    var recording = false

    var tempo = 95
    var timeSignature = (4, 4)
    
    
    @IBAction func start(_ sender: Any) {
        if !recording {
            print("Recording started")

            recording = true
            song = Song(tempo: tempo, timeSignature: timeSignature)
            recogniser = NoteRecogniser(song: song!)
        }

    }

    @IBAction func stop(_ sender: Any) {
        if recording {
            song = recogniser?.getSong()
            print(song ?? "Couldnt get the song")
            recogniser = nil
            print("Recording end")
            recording = false
        }
        // Go to see the tab
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
