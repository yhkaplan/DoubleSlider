[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 4.1](https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat)](swift.org)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DoubleSlider.svg)](https://img.shields.io/cocoapods/v/DoubleSlider.svg)
[![Platform](https://img.shields.io/cocoapods/p/DoubleSlider.svg?style=flat)](http://cocoapods.org/pods/DoubleSlider)
# DoubleSlider
DoubleSlider is a version of UISlider that has two draggable points —useful for choosing two points in a range. 

## Requirements
- iOS 10.0+
- Xcode 9.3+

## Screenshots
![demo](demo.gif)

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `DoubleSlider` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
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

## Todos
 - [x] Add screenshots/GIF
 - [ ] Add info about using IBDesignable and setting up
 - [ ] Add long CocoaPods description
 - [ ] Fix badges
* Make upgrade script that bumps version number, commits, pushes, and runs pod trunk push
