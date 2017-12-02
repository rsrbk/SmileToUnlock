SmileToUnlock ![Pod status](https://cocoapod-badges.herokuapp.com/v/SmileToUnlock/badge.png)
---
Make your users smile before opening the app :)
<p align="center">
  <img src="https://github.com/rsrbk/SmileToUnlock/blob/master/Resources/gif.gif?raw=true" alt="Demo gif"/>
</p>

Installation
---
The most preferable way to use this library is cocoapods. Add the following line to your `Podfile`:
```sh
pod 'SmileToUnlock'
```
and run `pod install` in your terminal.

Alternatively, you can manually add the files in the `SmileToUnlock` directory to your project.

Usage
--
First of all, you have to add NSCameraUsageDescription to you Info.plist with a brief explanation.

Then you need to check if a user's device has the face tracking support:
```swift
if SmileToUnlock.isSupported {
```
Keep in mind that only iPhone X (a real device, not even a stimulator!) has this support currently.

Then just create an instance of the SmileToUnlock and specify the success handler:
```swift
if SmileToUnlock.isSupported {
let vc = SmileToUnlock()
    vc.onSuccess = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        self.window?.rootViewController = vc
    }
    window?.rootViewController = vc
}
```
If you want SmileToUnlock to be presented on your app's launch, add the code above to your didFinishLaunchingWithOptions method in AppDelegate.

Few additional customization properties:
```swift
public var titleText: String? = "Hello,"
public var subtitleText: String? = "Begin using our app from the smile"
public var skipButtonText: String? = "Skip this"

/// Sound to play after a user has smiled. Set to nil if you don't want a sound to be played.
public var successSoundPlaying: (() -> Void)? = {
    AudioServicesPlaySystemSound(1075)
}

/// Set how much smile do you need from a user. 0.8 is kind of hard already!
public var successTreshold: CGFloat = 0.7

/// Background color for this view controller.
public var backgroundColor: SmileToUnlockBackground = .blue
```
There are 3 preinstalled background colors. You can set your custom one as well:
```swift
public enum SmileToUnlockBackground {
    case blue
    case red
    case purple
    case other(UIColor)
}
```

<img src="https://github.com/rsrbk/SmileToUnlock/blob/master/Resources/blue.png?raw=true" alt="Blue"/> <img src="https://github.com/rsrbk/SmileToUnlock/blob/master/Resources/red.png?raw=true" alt="Red"/> <img src="https://github.com/rsrbk/SmileToUnlock/blob/master/Resources/purple.png?raw=true" alt="Purple"/>

Check out my other libraries
--

[SRCountdownTimer](https://github.com/rsrbk/SRCountdownTimer) - a simple circle countdown with a configurable timer.
[SRAttractionsMap](https://github.com/rsrbk/SRAttractionsMap) - the map with attractions on which you can click and see the full description.

License
--
 MIT License

 Copyright (c) 2017 Ruslan Serebriakov <rsrbk1@gmail.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
