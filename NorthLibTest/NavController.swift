//
//  NavController.swift
//  NorthLibTest
//
//  Created by Norbert Thies on 01.03.22.
//

import UIKit
import NorthLib

class NavController: NavigationController {
  
  var vcTable: VCTable
  
  init(delegate: VCTableDelegate? = nil) {
    vcTable = VCTable(delegate: delegate) 
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    vcTable = VCTable()
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    vcTable.header = "NorthLib test view controllers"
    vcTable.add(vcd: SimpleUI.self)
    vcTable.add(vcd: WebViewTests.self)
    vcTable.add(vcd: KeychainTests.self)
    pushViewController(vcTable, animated: false)
  }

}

