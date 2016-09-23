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
        
        let imageWidth = UIScreen.main.bounds.size.width - 100
        let textWidth = UIScreen.main.bounds.size.width - 30
        
        urlField.frame = CGRect(x: 15, y: 15, width: textWidth, height: 40)
        urlField.placeholder = "Put your image url here ..."
        urlField.font = UIFont.systemFont(ofSize: 13)
        urlField.layer.cornerRadius = 3
        urlField.layer.borderColor = darkGrey.cgColor
        urlField.backgroundColor = lightGrey
        urlField.textAlignment = NSTextAlignment.center
        self.view.addSubview(urlField)
        
        let button1 = UIButton(frame: CGRect(x: 15, y: 70, width: textWidth, height: 30))
        button1.backgroundColor = baseColor
        button1.setTitle("Load Image Without Placeholder", for: UIControlState())
        button1.layer.cornerRadius = 3
        button1.addTarget(self, action: #selector(ViewController.loadWithoutPlaceholder), for: UIControlEvents.touchUpInside)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.view.addSubview(button1)
        
        let button2 = UIButton(frame: CGRect(x: 15, y: 110, width: textWidth, height: 30))
        button2.backgroundColor = baseColor
        button2.setTitle("Load Image With Placeholder", for: UIControlState())
        button2.layer.cornerRadius = 3
        button2.addTarget(self, action: #selector(ViewController.loadWithPlaceholder), for: UIControlEvents.touchUpInside)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.view.addSubview(button2)
        
        imageView.frame = CGRect(x: 50, y: 175, width: imageWidth, height: imageWidth)
        imageView.backgroundColor = lightGrey
        imageView.layer.cornerRadius = 4
        imageView.layer.borderColor = darkGrey.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(imageView)
        
        let infoLabel = UILabel(frame: CGRect(x: 15, y: 175 + imageWidth + 15, width: textWidth, height: 50))
        infoLabel.text = "Only support secure image URL (with https protocol), if you need to load from non secure URL you need to whitelist that URL in your plist.info file"
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.font = UIFont.systemFont(ofSize: 11, weight: 1)
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

