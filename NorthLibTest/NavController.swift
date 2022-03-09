//
//  NavController.swift
//  NorthLibTest
//
//  Created by Norbert Thies on 01.03.22.
//

import UIKit
import NorthLib

class NavController: NavigationController {
  
  var vcTable = VCTable()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    vcTable.header = "NorthLib test view controllers"
    vcTable.add(vcd: SimpleUI.self)
    vcTable.add(vcd: WebViewTests.self)
    vcTable.add(vcd: KeychainTests.self)
    pushViewController(vcTable, animated: false)
  }

}

