//
//  MusicInformationViewController.swift
//  Guitar Tabber
//
//  Created by Frank Tong on 18/11/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class MusicInformationViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var beat1TextField: UITextField!
    @IBOutlet var beat2TextField: UITextField!
    @IBOutlet var label1: UILabel!
    var stringPassed = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label1.text = stringPassed
        
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
