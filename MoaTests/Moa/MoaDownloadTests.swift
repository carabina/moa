import UIKit
import XCTest

class MoaDownloadTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    StubHttp.removeAllStubs()
  }
  
  func testLoadPngImage() {
    StubHttp.with96pxPngImage()

    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?

    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(96, imageResponse!.size.width)
      XCTAssert(errorResponse == nil)
      XCTAssert(httpUrlResponse == nil)
    }
  }
  
  func testLoadJpegImage() {
    StubHttp.with35pxJpgImage()
    
    let moa = Moa()
    var imageResponse: UIImage?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.url = "http://evgenii.com/moa/35px.jpg"
    
    moa_eventually(imageResponse != nil) {
      XCTAssertEqual(35, imageResponse!.size.width)
    }
  }

  func testLoadImage_errorWhenImageNotFound() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png", statusCode: 404)
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(MoaHttpImageErrors.HttpStatusCodeIsNot200.rawValue, errorResponse!.code)
      XCTAssertEqual("MoaHttpImageErrorDomain", errorResponse!.domain)
      XCTAssertEqual(404, httpUrlResponse!.statusCode)
    }
  }
  
  func testLoadImage_noInternetConnectionError() {
    // Code: -1009
    let notConnectedErrorCode = Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue)
    
    let notConnectedError = NSError(domain: NSURLErrorDomain,
      code: notConnectedErrorCode, userInfo: nil)
    
    StubHttp.withError(notConnectedError, forUrlPart: "96px.png")
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(-1009, errorResponse!.code)
      XCTAssertEqual("NSURLErrorDomain", errorResponse!.domain)
      XCTAssert(httpUrlResponse == nil)
    }
  }

  func testLoadImage_errorWhenResponseIsNotAnImageType() {
    StubHttp.withImage("96px.png", forUrlPart: "96px.png",
      responseHeaders: ["Content-Type": "text/html"])
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
  
    moa_eventually(errorResponse != nil) {
      XCTAssert(imageResponse == nil)

      XCTAssertEqual(MoaHttpImageErrors.NotAnImageContentTypeInResponseHttpHeader.rawValue,
        errorResponse!.code)
  
      XCTAssertEqual("MoaHttpImageErrorDomain", errorResponse!.domain)
      XCTAssertEqual(200, httpUrlResponse!.statusCode)
    }
  }

  func testLoadImage_errorWhenResponseDataIsNotImage() {
    StubHttp.withImage("text.txt", forUrlPart: "96px.png")
    
    let moa = Moa()
    var imageResponse: UIImage?
    var errorResponse: NSError?
    var httpUrlResponse: NSHTTPURLResponse?
    
    moa.onSuccessAsync = { image in
      imageResponse = image
      return nil
    }
    
    moa.onErrorAsync = { error, response in
      errorResponse = error
      httpUrlResponse = response
    }
    
    moa.url = "http://evgenii.com/moa/96px.png"
    
    moa_eventually {
      XCTAssert(imageResponse == nil)
      XCTAssertEqual(MoaHttpImageErrors.FailedToReadImageData.rawValue,
        errorResponse!.code)
      
      XCTAssertEqual("MoaHttpImageErrorDomain", errorResponse!.domain)
      XCTAssertEqual(200, httpUrlResponse!.statusCode)
    }
  }
}