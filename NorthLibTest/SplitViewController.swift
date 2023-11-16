//
//  SplitViewController.swift
//  NorthLibTest
//
//  Created by Norbert Thies on 09.03.22.
//

import UIKit
import NorthLib

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate,
                           VCTableDelegate {
  
  /// Primary navigation controller
  var primaryNC: NavController!
  /// Secondary initial VC
  var secondaryVC: UIViewController!
  /// Secondary NC
  var secondaryNC: UINavigationController!
  
  init() {
    super.init(style: .doubleColumn)
    primaryNC = NavController(delegate: self)
    secondaryVC = UIViewController()
    secondaryNC = UINavigationController(rootViewController: secondaryVC)
    secondaryVC.view.backgroundColor = UIColor.rgb(0xeeeeee)
    self.delegate = self
    self.viewControllers = [primaryNC, secondaryNC]
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    show(.primary)
  }
  
  // MARK: - VCTableDelegate methods
  
  func showVC(vc: VCDescription) {
    secondaryNC.setViewControllers([vc], animated: true)
    show(.secondary)
  }
  
  // MARK: - UISplitViewControllerDelegate methods
  
  // Make column 1 the default 
  @available(iOS 14.0, *)
  public func splitViewController(_ svc: UISplitViewController, 
    topColumnForCollapsingToProposedTopColumn proposedTopColumn: 
    UISplitViewController.Column) -> UISplitViewController.Column {
    return .primary
  }
  
  /* not needed for doubleColumn splitviews
  public func splitViewController(_ splitViewController: UISplitViewController,
    collapseSecondary secondaryViewController: UIViewController,
    onto primaryViewController: UIViewController) -> Bool {
    return true
  }
  */

} // SplitViewController
