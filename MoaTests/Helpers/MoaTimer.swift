//
// Creats a timer that executes code after delay.
//
// Usage
// -----
//   var timer: MoaTimer.runAfter?
//   ...
//
//   func myFunc() {
//     timer = MoaTimer.runAfter(0.010) { timer in
//        ... code to run
//     }
//   }
//
//
//  Cancelling the timer
//  --------------------
//
//  Timer is cancelled automatically whe it is deallocated. You can also cancel it manually:
//
//  let timer = MoaTimer.runAfter(0.010) { timer in ... }
//  timer.cancel()
//
//

import UIKit

final class MoaTimer: NSObject {
  private let repeats: Bool
  private var timer: NSTimer?
  private var callback: ((MoaTimer)->())?
  
  private init(interval: NSTimeInterval, repeats: Bool = false, callback: (MoaTimer)->()) {
    self.repeats = repeats
    
    super.init()
    
    self.callback = callback
    timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self,
      selector: "timerFired:", userInfo: nil, repeats: repeats)
  }
  
  deinit {
    cancel()
  }
  
  func cancel() {
    timer?.invalidate()
    timer = nil
  }
  
  func timerFired(timer: NSTimer) {
    self.callback?(self)
    if !repeats { cancel() }
  }
  
  class func runAfter(interval: NSTimeInterval, repeats: Bool = false,
    callback: (MoaTimer)->()) -> MoaTimer {
      
    return MoaTimer(interval: interval, repeats: repeats, callback: callback)
  }
}