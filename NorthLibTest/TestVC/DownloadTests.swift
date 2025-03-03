//
//  DownloadTests.swift
//  NorthLibTest
//
//  Created by Norbert Thies on 27.02.25.
//

import UIKit
import NorthLib

// A view controller to test WebViews
class DownloadTests: UIViewController, VCDescription {
  
  static var title = "BackgroundDownload 1"
  static var description = """
  Only debug output of a download using BackgroundSession.
  """
    
  // The Logger to display messages in a view
  var viewLogger = Log.ViewLogger()
  
  // The Logger to display messages on the console
  var consoleLogger = Log.Logger()
  
  func dlCallback(err: Error?) {
    if let err { log("Error in download: \(err)") }
    else { log("Download successful") }
  }
 
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    let logView = viewLogger.logView
    view.addSubview(logView)
    Log.append(logger: consoleLogger, viewLogger)
    Log.minLogLevel = .Debug
    pin(logView.top, to: self.view.topGuide())
    pin(logView.bottom, to: self.view.bottomGuide())
    pin(logView.left, to: self.view.left)
    pin(logView.right, to: self.view.right)

    log("""
      Background Capabilities:
        App.mayBackgroundFetch:        \(App.mayBackgroundFetch)
        App.mayBackgroundProcess:      \(App.mayBackgroundProcess)
        App.mayBackgroundNotification: \(App.mayBackgroundNotification)
    """)
    let url = "https://www.princexml.com/samples/wind-in-willows/wind-in-willows.zip"
    log("You have 5s to put the app in background mode")
    onMain(after: 5) { 
      do {
        let bgs = try BackgroundSession(url, callback: self.dlCallback)
        AppDelegate.dlCallback = self.dlCallback
        self.log("downloading to: \(Dir.documentsPath)")
        bgs.downloadZip(toDir: Dir.documentsPath)
      }
      catch {
        self.log("Exception received: \(error)")
      }
    } 
  }

} // WebViewTests
