Pod::Spec.new do |s|
  s.name         = "DoubleSlider"
  s.version      = "0.21.0"
  s.summary      = "DoubleSlider is a version of UISlider that has two draggable points —useful for choosing two points in a range."
  #s.description  = "DoubleSlider is a version of UISlider that has two draggable points —useful for choosing two points in a range." 
  s.homepage     = "https://github.com/yhkaplan/doubleslider"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "yhkaplan" => "yhkaplan@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/yhkaplan/DoubleSlider.git", :tag => "#{"v" + s.version.to_s}" }
  s.source_files  = "DoubleSlider/DoubleSlider/**/*.{h,swift}"
  s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"

  s.framework  = "UIKit", "CoreGraphics"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
