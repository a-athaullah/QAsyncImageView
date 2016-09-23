//
//  QAsyncImageView.swift
//  QAsyncImageView
//
//  Created by Ahmad Athaullah on 6/30/16.
//  Copyright © 2016 Ahmad Athaullah. All rights reserved.
//

import UIKit
import Foundation

var cache = NSCache<NSString,UIImage>()
open class QAsyncImageView: UIImageView {
    
    
}
public extension UIImageView {
    public func loadAsync(_ url:String, placeholderImage:UIImage? = nil, header : [String : String] = [String : String](), useCache:Bool = true, maskImage:UIImage? = nil){
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
        imageForUrl(url: url, header: header, useCache: useCache, completionHandler:{(image: UIImage?, url: String) in
            print("image url: \(url)    ---   image is nil = \(image == nil)")
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
    
    public class func maskImage(_ image:UIImage, mask:(UIImage))->UIImage{
        
        let scaledImage = UIImage.resizeImage(image, toFillOnImage: mask)
        let imageReference = scaledImage.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: (maskReference?.width)!,
                                          height: (maskReference?.height)!,
                                          bitsPerComponent: (maskReference?.bitsPerComponent)!,
                                          bitsPerPixel: (maskReference?.bitsPerPixel)!,
                                          bytesPerRow: (maskReference?.bytesPerRow)!,
                                          provider: (maskReference?.dataProvider!)!, decode: nil, shouldInterpolate: false)
        
        let maskedReference = imageReference?.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }
    
    // func imageForUrl
    //  Modified from ImageLoader.swift Created by Nate Lyman on 7/5/14.
    //              git: https://github.com/natelyman/SwiftImageLoader
    //              Copyright (c) 2014 NateLyman.com. All rights reserved.
    //
    func imageForUrl(url urlString: String, header: [String : String] = [String : String](), useCache:Bool = true, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        
        DispatchQueue.main.async(execute: {()in
            let image = cache.object(forKey: urlString as NSString)
            
            if useCache && (image != nil) {
                DispatchQueue.main.sync(execute: {() in
                    completionHandler(image, urlString)
                })
                return
            }else{
                
                
                let url = URL(string: urlString)
                var urlRequest = URLRequest(url: url!)
                
                for (key, value) in header {
                    urlRequest.addValue(value, forHTTPHeaderField: key)
                }
                
                
                let downloadTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                    if (error != nil) {
                        completionHandler(nil, urlString)
                        print("[QAsyncImageView] : \(error)")
                        return
                    }
                    
                    if let data = data {
                        if let image = UIImage(data: data) {
                            if useCache{
                                cache.setObject(image, forKey: urlString as NSString)
                            }else{
                                cache.removeObject(forKey: urlString as NSString)
                            }
                            DispatchQueue.main.sync(execute: {() in
                                completionHandler(image, urlString)
                            })
                        }else{
                            DispatchQueue.main.sync(execute: {() in
                                completionHandler(nil, urlString)
                            })
                            print("[QAsyncImageView] : Can't get image from URL: \(url)")
                        }
                        return
                    }
                    return ()
                    
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
    public class func clearCachedImageForURL(_ urlString:String){
        cache.removeObject(forKey: urlString as NSString)
    }
    public class func resizeImage(_ image: UIImage, toFillOnImage: UIImage) -> UIImage {
        
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
        image.draw(in: CGRect(x: 0 - xPos,y: 0 - yPos, width: image.size.width * scaleFactor, height: image.size.height * scaleFactor))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
