//
//  ViewController.swift
//  Example
//
//  Created by Ahmad Athaullah on 6/30/16.
//  Copyright © 2016 Ahmad Athaullah. All rights reserved.
//

import UIKit
import QAsyncImageView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageWidth = UIScreen.mainScreen().bounds.size.width - 200
        
        let imageView = UIImageView(frame: CGRectMake(100, 50, imageWidth, imageWidth))
        self.view.addSubview(imageView)
        
        imageView.loadAsync("https://static.pexels.com/photos/4062/landscape-mountains-nature-lake.jpeg")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

