//
//  ViewController.swift
//  Guitar Tabber
//
//  Created by Lau Kin Wai on 7/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var recorder: UIButton!
    
    
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var noteLabel: UILabel!
    
    
    
    @IBAction func stopAction(_ sender: AnyObject) {
        
    }
    @IBAction func recoderStart(_ sender: AnyObject) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var start: GuitarTuner = GuitarTuner()
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}


