//
//  RecorderController.swift
//  Guitar Tabber
//
//  Created by Enrique Mas Candela on 10/11/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class RecorderController: ViewController {

    var song: Song?
    var recogniser: NoteRecogniser?
    
    var recording = false
    
    var tempo = 120
    var timeSignature = (4, 4)

    
    @IBAction func startPressed(_ sender: Any) {
        if !recording {
            recording = true
            song = Song(tempo: tempo, timeSignature: timeSignature)
            recogniser = NoteRecogniser(song: song!)
        }
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        if recording {
            song = recogniser?.getSong()
            recogniser = nil
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
