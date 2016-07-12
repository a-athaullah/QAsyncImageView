# QAsyncImageView

QAsyncImageView is a extented UIImageView library written in Swift.

## Features

- Load image from URL Asynchronously
- Load image from URL with Header Asynchronously
- Optional use of cache image

## Requirements

- iOS 8.3+ 
- Xcode 7.3+

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To integrate QAsyncImageView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'QAsyncImageView'
end
```

Then, run the following command:

```
$ pod install
```

## Usage

### Get Image from URL

```
import QAsyncImageView

let imageView = UIImageView(frame: CGRectMake(100, 50, imageWidth, imageWidth))
imageView.loadAsync("https://static.pexels.com/photos/4062/landscape-mountains-nature-lake.jpeg")
```

### Get Image from URL with placeholder image:

```
import QAsyncImageView

let imageView = UIImageView(frame: CGRectMake(100, 50, imageWidth, imageWidth))
imageView.loadAsync("https://static.pexels.com/photos/4062/landscape-mountains-nature-lake.jpeg", placeholderImage: UIImage(named: "placeholder"))
```
