//
//  RecorderController.swift
//  Guitar Tabber
//
//  Created by Enrique Mas Candela on 10/11/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class RecorderController: UIViewController {

    @IBOutlet var convertButton: UIButton!
    var song: Song?
    var recogniser: NoteRecogniser?
    
    var recording = false

    var tempo = 95
    var timeSignature = (4, 4)
    
    @IBOutlet var stat: UILabel!
    
    @IBAction func start(_ sender: Any) {
        if !recording {
            print("Recording started")

            recording = true
            song = Song(tempo: tempo, timeSignature: timeSignature)
            recogniser = NoteRecogniser(song: song!)
        }
        stat.text = "Recording"

    }

    @IBAction func stop(_ sender: Any) {
        
        convertButton.isEnabled = true
        if recording {
            song = recogniser?.getSong()
            print(song ?? "Couldnt get the song")
            recogniser = nil
            print("Recording end")
            recording = false
        }
        // Go to see the tab
        for campass in (song?.compasses)! {
            print("campass")
            for a in campass.notes{
                let(location,realdata) = a.inGuitar
                print("location:\(location),data:\(realdata)")
            }
        }
        stat.text = "Finish"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func convert(_ sender: UIButton) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "musicInformation") as! MusicInformationViewController
        var temp:String = "Frank is here"
        myVC.stringPassed = temp
        navigationController?.pushViewController(myVC, animated: true)
    }
    

    
    
}
