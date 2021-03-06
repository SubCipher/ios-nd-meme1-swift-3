//
//  ScrollViewController.swift
//  MeMe1
//
//  Created by kpicart on 1/28/17.
//  Copyright © 2017 StepwiseDesigns. All rights reserved.
//

import UIKit


class ScrollViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    let viewSettings = ViewSettings()

    //scrollView and zooming fuctions to position/resize image
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            //keep base image size while zooming out
            scrollView.minimumZoomScale =  0.125
            scrollView.maximumZoomScale = 3.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        //use coordinate system of superView to set scrollView size and contentSize
        scrollView.contentSize = sourceImageView.frame.size
        scrollView.frame.size = self.view.frame.size
        
        return sourceImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //set parameters for sourceImage and sourceImageView
        viewSettings.setSourceImage()
        scrollView.addSubview(sourceImageView)
        
        //offSet image placement based on superView coordinate system after zooming
        view.frame.origin.y = -10.0
        }
    }
