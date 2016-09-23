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
    
    var baseColor = UIColor(red: 51/255.0, green: 204/255.0, blue: 51/255.0, alpha: 1)
    var lightGrey = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    var darkGrey = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
    
    var urlField = UITextField()
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "QAsyncImageView Demo"
        
        let imageWidth = UIScreen.mainScreen().bounds.size.width - 100
        let textWidth = UIScreen.mainScreen().bounds.size.width - 30
        
        urlField.frame = CGRectMake(15, 15, textWidth, 40)
        urlField.placeholder = "Put your image url here ..."
        urlField.font = UIFont.systemFontOfSize(13)
        urlField.layer.cornerRadius = 3
        urlField.layer.borderColor = darkGrey.CGColor
        urlField.backgroundColor = lightGrey
        urlField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(urlField)
        
        let button1 = UIButton(frame: CGRectMake(15, 70, textWidth, 30))
        button1.backgroundColor = baseColor
        button1.setTitle("Load Image Without Placeholder", forState: UIControlState.Normal)
        button1.layer.cornerRadius = 3
        button1.addTarget(self, action: #selector(ViewController.loadWithoutPlaceholder), forControlEvents: UIControlEvents.TouchUpInside)
        button1.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRectMake(15, 110, textWidth, 30))
        button2.backgroundColor = baseColor
        button2.setTitle("Load Image With Placeholder", forState: UIControlState.Normal)
        button2.layer.cornerRadius = 3
        button2.addTarget(self, action: #selector(ViewController.loadWithPlaceholder), forControlEvents: UIControlEvents.TouchUpInside)
        button2.titleLabel?.font = UIFont.systemFontOfSize(12)
        self.view.addSubview(button2)
        
        imageView.frame = CGRectMake(50, 175, imageWidth, imageWidth)
        imageView.backgroundColor = lightGrey
        imageView.layer.cornerRadius = 4
        imageView.layer.borderColor = darkGrey.CGColor
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(imageView)
        
        let infoLabel = UILabel(frame: CGRectMake(15, 175 + imageWidth + 15, textWidth, 50))
        infoLabel.text = "Only support secure image URL (with https protocol), if you need to load from non secure URL you need to whitelist that URL in your plist.info file"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.font = UIFont.systemFontOfSize(11, weight: 1)
        infoLabel.textColor = darkGrey
        self.view.addSubview(infoLabel)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadWithoutPlaceholder(){
        print("load image without placeholder")
        imageView.image = nil
        var url = ""
        if urlField.text != nil {
            url = urlField.text!
        }
        imageView.loadAsync(url)
    }
    func loadWithPlaceholder(){
        var url = ""
        if urlField.text != nil {
            url = urlField.text!
        }
        imageView.loadAsync(url, placeholderImage: UIImage(named: "placeholder"))
    }
}

