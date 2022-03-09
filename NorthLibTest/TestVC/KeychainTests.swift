//
//  KeychainTests.swift
//  taz.neo
//
//  Created by Norbert Thies on 19.06.21.
//  Copyright © 2021 Norbert Thies. All rights reserved.
//

import UIKit
import NorthLib

// A view controller to test Keychain usage
class KeychainTests: UIViewController, VCDescription {
  
  static var description = """
  Tests some aspects of iOS keychain access with a single LogView \
  (and Toast).
  """
  
  // The Logger to display messages in a view
  var viewLogger = Log.ViewLogger()
  
  // The Logger to display messages on the console
  var consoleLogger = Log.Logger()
  
  // The "clear" button
  var clearButton = Label()
 
  @Key("testBool")
  var testBool: Bool
  @Key("testString")
  var testString: String
  @Key("testCGFloat")
  var testCGFloat: CGFloat
  @Key("testDouble")
  var testDouble: Double
  @Key("testInt")
  var testInt: Int
  
  func AssertEqual<T: Equatable>(_ arg1: T, _ arg2: T, file: String = #file,
                                  line: Int = #line) {
    guard arg1 == arg2 else {
      error("Failure (\(line)@\(file):\n  \(arg1) != \(arg2)")
      return
    }
  }
  
  func AssertEqual<T: Equatable>(_ arg1: T?, _ arg2: T, file: String = #file,
                                  line: Int = #line) {
    guard arg1 == arg2 else {
      error("Failure (\(line)@\(file):\n  \(String(describing: arg1)) != \(arg2)")
      return
    }
  }
  
  func AssertNil<T>(_ arg: T?, file: String = #file,
                     line: Int = #line) {
    guard arg == nil else {
      error("Failure (\(line)@\(file):\n  \(String(describing: arg)) != nil")
      return
    }
  }
  
  private var keys = ["secret", "testBool", "testString", "testInt",
                      "testCGFloat", "testDouble", "id", "password"]
  
  func clear() {
    for k in keys { Keychain.singleton.delete(key: k) }
  }
  
  func checkPrevious() {
    let kc = Keychain.singleton
    log("Previous values " +
          "(access group: \(kc.suite ?? "undefined"))")
    for key in keys {
      if let val = kc[key] { log("  \(key): \(val)") }
      else { log("  key '\(key)' is undefined") }
    }
  }

  func testKeychain() {
    log("Checking keychain")
    let kc = Keychain.singleton
    kc["secret"] = "huhu"
    AssertEqual(kc["secret"], "huhu")
    kc["secret"] = nil
    AssertNil(kc["secret"])
    kc["secret"] = "I don't know"
  }
  
  func testWrappers() {
    log("Checking wrapper")
    testBool = false
    $testBool.onChange { val in self.log("testBool changed to: \(val)") }
    testBool = true
    AssertEqual(testBool, true)
    testBool = true
    testBool = false
    testString = ""
    $testString.onChange { val in self.log("testString changed to: \(val)") }
    testString = "test"
    AssertEqual(testString, "test")
    testInt = 0
    $testInt.onChange { val in self.log("testInt changed to: \(val)") }
    testInt = 14
    AssertEqual(testInt, 14)
    testCGFloat = 0
    $testCGFloat.onChange { val in self.log("testCGFloat changed to: \(val)") }
    testCGFloat = 15
    AssertEqual(testCGFloat, 15)
    testDouble = 0
    $testDouble.onChange { val in self.log("testDouble changed to: \(val)") }
    testDouble = 16
    AssertEqual(testDouble, 16)
  }

  override func viewDidLoad() {
    let logView = viewLogger.logView
    view.addSubview(logView)
    view.addSubview(clearButton)
    clearButton.backgroundColor = UIColor.red
    clearButton.textColor = UIColor.white
    clearButton.textAlignment = .center
    pin(clearButton.centerX, to: view.centerX)
    pin(clearButton.bottom, to: view.bottomGuide())
    clearButton.pinWidth(250)
    clearButton.pinHeight(40)
    clearButton.text = "Clear tmp Keychain values"
    clearButton.onTap { _ in 
      self.clear() 
      Toast.show("tmp Keychain values deleted")
    }
    pin(logView.top, to: self.view.topGuide())
    pin(logView.bottom, to: clearButton.top, dist: -10)
    pin(logView.left, to: self.view.left)
    pin(logView.right, to: self.view.right)
    view.backgroundColor = UIColor.white
    Log.append(logger: consoleLogger, viewLogger)
    Log.minLogLevel = .Debug
    Keychain.singleton.suite = "tmp"
    checkPrevious()
    testKeychain()
    testWrappers()
  }

} // KeychainTests

