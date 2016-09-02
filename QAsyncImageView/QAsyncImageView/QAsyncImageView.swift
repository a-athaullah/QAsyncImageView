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
    public func loadAsync(url:String, placeholderImage:UIImage? = nil, header : [String : String] = [String : String](), useCache:Bool = true, maskImage:UIImage? = nil){
        var returnImage = UIImage()
        if placeholderImage != nil {
            if maskImage != nil{
                returnImage = UIImageView.maskImage(placeholderImage!, mask: maskImage!)
            }else{
                returnImage = placeholderImage!
            }
            self.image = returnImage
            
        }else{
            self.image = nil
        }
        imageForUrl(url, header: header, useCache: useCache, completionHandler:{(image: UIImage?, url: String) in
            if image != nil {
                if maskImage != nil{
                    print("here")
                    returnImage = UIImageView.maskImage(image!, mask: maskImage!)
                }else{
                    returnImage = image!
                }
                self.image = returnImage
            }
        })
    }
    
    public class func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let scaledImage = UIImage.resizeImage(image, toFillOnImage: mask)
        let imageReference = scaledImage.CGImage
        let maskReference = mask.CGImage
        
        let imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                          CGImageGetHeight(maskReference),
                                          CGImageGetBitsPerComponent(maskReference),
                                          CGImageGetBitsPerPixel(maskReference),
                                          CGImageGetBytesPerRow(maskReference),
                                          CGImageGetDataProvider(maskReference), nil, false)
        
        let maskedReference = CGImageCreateWithMask(imageReference, imageMask)
        
        let maskedImage = UIImage(CGImage:maskedReference!)
        
        return maskedImage
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
    public class func resizeImage(image: UIImage, toFillOnImage: UIImage) -> UIImage {
        
        var scale:CGFloat = 1
        var newSize:CGSize = toFillOnImage.size
        
        if image.size.width > image.size.height{
            scale = image.size.width / image.size.height
            newSize.width = toFillOnImage.size.width
            newSize.height = toFillOnImage.size.height / scale
        }else{
            scale = image.size.height / image.size.width
            newSize.height = toFillOnImage.size.height
            newSize.width = toFillOnImage.size.width / scale
        }
        
        var scaleFactor = newSize.width / image.size.width
        
        
        if (image.size.height * scaleFactor) < toFillOnImage.size.height{
            scaleFactor = scaleFactor * (toFillOnImage.size.height / (image.size.height * scaleFactor))
        }
        if (image.size.width * scaleFactor) < toFillOnImage.size.width{
            scaleFactor = scaleFactor * (toFillOnImage.size.width / (image.size.width * scaleFactor))
        }
        
        UIGraphicsBeginImageContextWithOptions(toFillOnImage.size, false, scaleFactor)
        
        var xPos:CGFloat = 0
        if (image.size.width * scaleFactor) > toFillOnImage.size.width {
            xPos = ((image.size.width * scaleFactor) - toFillOnImage.size.width) / 2
        }
        var yPos:CGFloat = 0
        if (image.size.height * scale) > toFillOnImage.size.height{
            yPos = ((image.size.height * scaleFactor) - toFillOnImage.size.height) / 2
        }
        image.drawInRect(CGRectMake(0 - xPos,0 - yPos, image.size.width * scaleFactor, image.size.height * scaleFactor))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}