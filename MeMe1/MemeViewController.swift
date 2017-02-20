//
//  MemeViewController.swift
//  MeMe1
//
//  Created by kpicart on 2/2/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    
    //capture and display memedImage
    var segueMemedImage: UIImage?
 
    @IBOutlet weak var generatedMemeImageOutlet: UIImageView!
    
        override func viewWillAppear(_ animated: Bool) {
            if let segueMemedImage = self.segueMemedImage { self.generatedMemeImageOutlet.image = segueMemedImage }}
   }
