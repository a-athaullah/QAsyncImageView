//
//  QAsyncImageView.swift
//  QAsyncImageView
//
//  Created by Ahmad Athaullah on 6/30/16.
//  Copyright © 2016 Ahmad Athaullah. All rights reserved.
//

import UIKit
import Foundation

var cache = NSCache()

public class QAsyncImageView: UIImageView {


}
public extension UIImageView {
    public func loadAsync(url:String, placeholderImage:UIImage? = nil, header : [String : String] = [String : String](), useCache:Bool = true){
        if placeholderImage != nil {
            self.image = placeholderImage!
        }else{
            self.image = nil
        }
        imageForUrl(url, header: header, useCache: useCache, completionHandler:{(image: UIImage?, url: String) in
                if image != nil {
                    self.image = image
                }
            })
    }
    
    // func imageForUrl
    //  Modified from ImageLoader.swift Created by Nate Lyman on 7/5/14.
    //              git: https://github.com/natelyman/SwiftImageLoader
    //              Copyright (c) 2014 NateLyman.com. All rights reserved.
    //
    func imageForUrl(urlString: String, header: [String : String] = [String : String](), useCache:Bool = true, completionHandler:(image: UIImage?, url: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {()in
            
            let image = cache.objectForKey(urlString) as? UIImage
            
            if useCache && (image != nil) {
                dispatch_async(dispatch_get_main_queue(), {() in
                    completionHandler(image: image, url: urlString)
                })
                return
            }else{
                
                let url = NSURL(string: urlString)
                let mutableRequest = NSMutableURLRequest(URL: url!)
                
                for (key, value) in header {
                    mutableRequest.setValue(value, forHTTPHeaderField: key)
                }
                
                let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(mutableRequest, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if (error != nil) {
                        completionHandler(image: nil, url: urlString)
                        print("[QAsyncImageView] : \(error)")
                        return
                    }
                    
                    if let data = data {
                        if let image = UIImage(data: data) {
                            if useCache{
                                cache.setObject(image, forKey: urlString)
                            }else{
                                cache.removeObjectForKey(urlString)
                            }
                            dispatch_async(dispatch_get_main_queue(), {() in
                                completionHandler(image: image, url: urlString)
                            })
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {() in
                                completionHandler(image: nil, url: urlString)
                            })
                            print("[QAsyncImageView] : Can't get image from URL: \(url)")
                        }
                        return
                    }
                    
                })
                downloadTask.resume()
            }
        })
    }
}
public extension UIImage {
    public class func clearAllCache(){
        cache.removeAllObjects()
    }
    public class func clearCachedImageForURL(urlString:String){
        cache.removeObjectForKey(urlString)
    }
}