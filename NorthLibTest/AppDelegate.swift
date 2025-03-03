//
//  AppDelegate.swift
//  NorthLibTest
//
//  Created by Norbert Thies on 01.03.22.
//

import UIKit
import NorthLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate, DoesLog {
  
  var dlCallback: (Error?)->()
  static var dlCallback: (Error?)->() {
    get { return (UIApplication.shared.delegate as! AppDelegate).dlCallback }
    set { (UIApplication.shared.delegate as! AppDelegate).dlCallback = newValue }
  }
  
  override init() {
    dlCallback = { (err: Error?) in
      Log.error("Background download: No callback defined.")
    }
    super.init()
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String,
                   completionHandler: @escaping () -> Void) {
    do {
      try BackgroundSession.resume(name: identifier, completionHandler: completionHandler,
                                   callback: dlCallback)
    }
    catch {
      log("BackgroundSession.resume failed: \(error)")
    }
  }

}

