[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 5.5](https://img.shields.io/badge/Swift-5.5-orange.svg?style=flat)](swift.org)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DoubleSlider.svg)](https://img.shields.io/cocoapods/v/DoubleSlider.svg)
[![Platform](https://img.shields.io/cocoapods/p/DoubleSlider.svg?style=flat)](http://cocoapods.org/pods/DoubleSlider)
# DoubleSlider
DoubleSlider is a version of UISlider that has two draggable points —useful for choosing two points in a range.

## Requirements
- iOS 12.0+
- Xcode 12.0+

## Screenshots
![demo](demo.gif)

## Installation

#### Swift Package Manager

Add via Xcode in the [usual way](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `DoubleSlider` by adding it to your `Podfile`:

```ruby
platform :ios, '11.0'
use_frameworks!
pod 'DoubleSlider'
```
``` swift
import DoubleSlider
```
#### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/DoubleSlider.framework` to an iOS project.

```
github "yhkaplan/DoubleSlider"
```
