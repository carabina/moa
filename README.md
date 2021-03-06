# Moa, an image downloader for iOS/Swift

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)][carthage]
[![CocoaPods Version](https://img.shields.io/cocoapods/v/moa.svg?style=flat)][cocoadocs]
[![License](https://img.shields.io/cocoapods/l/moa.svg?style=flat)][cocoadocs]
[![Platform](https://img.shields.io/cocoapods/p/moa.svg?style=flat)][cocoadocs]
[cocoadocs]: http://cocoadocs.org/docsets/moa
[carthage]: https://github.com/Carthage/Carthage

Moa is an image download library for iOS written in Swift.
It allows to download and show an image in `UIImageView` by setting its `moa.url` property.

* Images are downloaded asynchronously.
* Uses NSURLSession for networking and caching.
* Images are cached locally according to their HTTP response headers.
* Can be used without UIImageView.
* Provides closure properties for image manipulation and error handling.

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg' alt='Moa hunting' width='400'>

> "Lost, like the Moa is lost" - Maori proverb

## Setup

There are three ways you can add Moa to your Xcode project.

**Add source (iOS 7+)**

Simply add [MoaDistrib.swift](https://github.com/evgenyneu/moa/blob/master/Distrib/MoaDistrib.swift) file into your Xcode project.

**Setup with Carthage (iOS 8+)**

Alternatively, add `github "evgenyneu/moa" ~> 1.0` to your Cartfile and run `carthage update`.

**Setup with CocoaPods (iOS 8+)**

If you are using CocoaPods add this text to your Podfile and run `pod install`.

    use_frameworks!
    pod 'moa', '~> 1.0'

## Usage

1. Add `import moa` to your source code if you used Carthage or CocoaPods setup methods.

1. Set `moa.url` property of `UIImageView` to start asynchronous image download. The image will be automatically displayed when download is finished.

```Swift
imageView.moa.url = "http://site.com/image.jpg"
```

## Canceling download

Ongoing image download for the UIImageView is automatically canceled when:

1. Image view is deallocated.
2. New image download is started: `imageView.moa.url = ...`.

Call `imageView.moa.cancel()` to manually cancel the download.


## Advanced features



### Supplying completion closure

Assign a closure that will be called when image is received.

```Swift
imageView.moa.onSuccessAsync = { image in
  return image
}

imageView.moa.url = "http://site.com/image.jpg"
```

The closure will be called *asynchronously* after download finishes and before the image
is assigned to the image view. This is a good place to manipulate the image before it is shown. The closure returns an image that will be shown in the image view. Return nil if you do not want the image to be shown.



### Supplying error closure

```Swift
imageView.moa.onErrorAsync = { error, response in
  // Handle error
}

imageView.moa.url = "http://site.com/image.jpg"
```

The closure is called *asynchronously* if image download fails. [See Wiki](https://github.com/evgenyneu/moa/wiki/Moa-errors) for the list of possible error codes.

**Closure arguments**:

*error*: NSError instance.

*response*: NSHTTPURLResponse instance.



### Download an image without UIImageView

An instance of `Moa` class can also be used without an image view.

```Swift
let moa = Moa()
moa.onSuccessAsync = { image in
  return image
}
moa.url = "http://site.com/image.jpg"
```

## Alternative solutions

Here is the list of other image download libraries for Swift.

* [cbot/Vincent](https://github.com/cbot/Vincent)
* [daltoniam/Skeets](https://github.com/daltoniam/Skeets)
* [Haneke/HanekeSwift](https://github.com/Haneke/HanekeSwift)
* [hirohisa/ImageLoaderSwift](https://github.com/hirohisa/ImageLoaderSwift)
* [natelyman/SwiftImageLoader](https://github.com/natelyman/SwiftImageLoader)
* [onevcat/Kingfisher](https://github.com/onevcat/Kingfisher)
* [zalando/MapleBacon](https://github.com/zalando/MapleBacon)

## Credits

* 'Hunting Moa' image: Extinct Monsters by Rev. H. N. Hutchinson, illustrations by Joseph Smit (1836-1929) and others. 4th ed., 1896. Plate XXIII between pages 232 and 233. File source: [Wikimedia Commons](http://commons.wikimedia.org/wiki/File:Hunting_Moa.jpg).

## License

Moa is released under the [MIT License](LICENSE).


