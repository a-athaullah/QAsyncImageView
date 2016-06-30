Pod::Spec.new do |s|

s.name         = "QAsyncImageView"
s.version      = "0.0.1"
s.summary      = "Simple UIImageView extension to loadAsync image"

s.description  = <<-DESC
Simple UIImageView extension to load image from URL asynchronously.
DESC

s.homepage     = "http://qisc.us"

s.license      = "MIT"
s.author       = "Ahmad Athaullah"

s.source       = { :git => "https://github.com/a-athaullah/QAsyncImageView.git", :tag => "#{s.version}" }


s.source_files  = "QAsyncImageView/QAsyncImageView/*.swift"
s.platform      = :ios, "8.0"


end