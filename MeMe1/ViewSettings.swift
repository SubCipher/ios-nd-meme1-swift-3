//
//  ViewSettings.swift
//  MeMe1
//
//  Created by kpicart on 2/15/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit

//MARK: - Global var
    //the original base of meme image
var sourceImageView = UIImageView()
var sourceImage: UIImage? {
    get{
        return sourceImageView.image
    }
    set {
        //new properties for view
        sourceImageView.image = newValue
        sourceImageView.frame.size = sourceImageView.intrinsicContentSize
    }
}


class ViewSettings: UIViewController {
    
    //stand in image if memeImage could not be generated:
    let noMemeImage:UIImage? = UIImage(named: "noMemeGenerated")
    
    func setSourceImage( ){
        sourceImageView.image = sourceImage
    }
    
    func hideNavButtons(_ navShow:Bool, topNavBar: UINavigationItem,bottomNavBar: UIToolbar, button1: UIButton, button2: UIButton){
        button1.isHidden = navShow
        button2.isHidden = navShow
        topNavBar.accessibilityElementsHidden = navShow
        bottomNavBar.isHidden = navShow
    }
}

