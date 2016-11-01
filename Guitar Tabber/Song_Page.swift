//
//  Song_Page.swift
//  Guitar Tabber
//
//  Created by Lau Kin Wai on 24/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//
import UIKit
import Foundation
class songPage {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
    
}
