//
//  QAsyncImageView.swift
//  QAsyncImageView
//
//  Created by Ahmad Athaullah on 6/30/16.
//  Copyright © 2016 Ahmad Athaullah. All rights reserved.
//

import UIKit
import Foundation

public class QAsyncImageView: UIImageView {


}
public extension UIImageView {
    public func loadAsync(url:String, placeholderImage:UIImage? = nil, header : [String : String] = [String : String]()){
        if placeholderImage != nil {
            self.image = placeholderImage!
        }
        imageForUrl(url, header: header, completionHandler:{(image: UIImage?, url: String) in
            self.image = image
        })
    }
    
    //  func imageForUrl
    //  taken from : ImageLoader.swift
    //  extension
    //
    //  Created by Nate Lyman on 7/5/14.
    //  git: https://github.com/natelyman/SwiftImageLoader
    //  Copyright (c) 2014 NateLyman.com. All rights reserved.
    //
    func imageForUrl(urlString: String, header: [String : String] = [String : String](), completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            let cache = NSCache()
            let data: NSData? = cache.objectForKey(urlString) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            if header.count > 0 {
                let url = NSURL(string: urlString)
                let mutableRequest = NSMutableURLRequest(URL: url!)
                
                for (key, value) in header {
                    mutableRequest.setValue(key, forHTTPHeaderField: value)
                }
                
                let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(mutableRequest, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if (error != nil) {
                        completionHandler(image: nil, url: urlString)
                        return
                    }
                    
                    if let data = data {
                        let image = UIImage(data: data)
                        cache.setObject(data, forKey: urlString)
                        dispatch_async(dispatch_get_main_queue(), {() in
                            completionHandler(image: image, url: urlString)
                        })
                        return
                    }
                    
                })
                downloadTask.resume()
            }else{
                let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if (error != nil) {
                        completionHandler(image: nil, url: urlString)
                        return
                    }
                    
                    if let data = data {
                        let image = UIImage(data: data)
                        cache.setObject(data, forKey: urlString)
                        dispatch_async(dispatch_get_main_queue(), {() in
                            completionHandler(image: image, url: urlString)
                        })
                        return
                    }
                    
                })
                downloadTask.resume()
            }
        })
        
    }
}