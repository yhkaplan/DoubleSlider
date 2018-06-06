Pod::Spec.new do |s|
  s.name         = "DoubleSlider"
  s.version      = "0.25.0"
  s.summary      = "DoubleSlider is a version of UISlider that has two draggable points —useful for choosing two points in a range."
  #s.description  = "DoubleSlider is a version of UISlider that has two draggable points —useful for choosing two points in a range."
  s.homepage     = "https://github.com/yhkaplan/doubleslider"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "yhkaplan" => "yhkaplan@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/yhkaplan/DoubleSlider.git", :tag => "#{"v" + s.version.to_s}" }
  s.source_files  = "DoubleSlider/DoubleSlider/**/*.{h,swift}"
  s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
  s.framework  = "UIKit", "CoreGraphics"
end
