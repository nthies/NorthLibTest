//
//  WebViewTests.swift
//
//  Created by Norbert Thies on 25.04.20.
//  Copyright © 2020 Norbert Thies. All rights reserved.
//

import UIKit
import NorthLib

// A view controller to test WebViews
class WebViewTests: UIViewController, VCDescription {
  
  static var title = "WebView 1"
  static var description = """
  A simple WebView with a JavaScript bridge and a ViewLogger \
  to show log messages.
  """
  
  // The WebView to test
  var webView = WebView()
  
  // The Logger to display messages in a view
  var viewLogger = Log.ViewLogger()
  
  // The Logger to display messages on the console
  var consoleLogger = Log.Logger()
 
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.view.addSubview(webView)
    let logView = viewLogger.logView
    view.addSubview(logView)
    logView.backgroundColor = UIColor.rgb(0xeeeeee)
    Log.append(logger: consoleLogger, viewLogger)
    Log.minLogLevel = .Debug
    pin(webView.top, to: self.view.topGuide())
    pin(webView.bottom, to: self.view.centerY)
    pin(webView.left, to: self.view.left)
    pin(webView.right, to: self.view.right)
    pin(logView.top, to: webView.bottom)
    pin(logView.bottom, to: self.view.bottomGuide())
    pin(logView.left, to: self.view.left)
    pin(logView.right, to: self.view.right)
    let html = """
    <header>
      <meta name='viewport' content='width=device-width, initial-scale=1.0, 
        maximum-scale=1.0, minimum-scale=1.0'/>
    </header>
    <body>
      <h1>This is a test</h1>
      <p>
        This is a link to <a href="https://taz.de/">taz.de</a><br/>
        This is a link to <a href="mailto:norbert@taz.de">norbert@taz.de</a>,
        which doesn't work out of the box...
      </p>
      <p>
        Have a look at the console output to understand the mechanics of the 
        JS code.
      </p>
    </body>
    """
    let bo = JSBridgeObject(name: "Test")
    bo.addfunc("bridgeTest") { jsCall in
      self.debug(jsCall.toString())
      return NSNull()
    }
    bo.addfunc("getInt") { jscall in
      return 14
    }
    let js = """
    Test.f1 = function() { Test.call("bridgeTest", Test.f3, 1, "huhu") }
    Test.f3 = function(arg) { console.log("called back: ", arg) }
    Test.getInt = function() { Test.call("getInt", Test.f3) }
    Test.f1()
    Test.getInt()
    Test.log("A ", "small ", "test")
    alert("A test of a JS alert")
    console.log("to whom", " it may concern")
    """
    webView.addBridge(bo)
    webView.load(html: html) { [weak self] in
      guard let self = self else { return }
      self.webView.injectBridges()
      self.webView.log2bridge(bo)
      self.webView.jsexec(js) { _ in
        self.log("Injected JS:\n\n\(js)")
      }
      self.webView.jsexec("console.log(\"a non delayed test\")")
      onMain(after: 5) {
        self.webView.jsexec("Test.log(\"a delayed test\")")
      }
    } 
  }

} // WebViewTests
