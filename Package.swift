// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DoubleSlider",
    platforms: [.iOS(.v11)],
    products: [.library(name: "DoubleSlider", targets: ["DoubleSlider"])],
    targets: [.target(name: "DoubleSlider", path: "DoubleSlider/DoubleSlider")]
)
