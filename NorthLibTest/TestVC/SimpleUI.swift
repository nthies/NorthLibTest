//
//  UITests.swift
//
//  Created by Norbert Thies on 02.02.20.
//  Copyright © 2020 Norbert Thies. All rights reserved.
//

import UIKit
import NorthLib

class SimpleUI: UIViewController, VCDescription {
  
  lazy var toolBar = Toolbar()
  lazy var bottomView = UIView()
  lazy var viewA = UIView()
  lazy var viewB = UIView()
  lazy var label = Label()
  lazy var waste = Button<ImageView>()
  var gif: UIImageView?
  
  static var description: String = """
  Some very simple UI tests with a bottom ToolBar mainly focussing \
  on auto layout pin*-functions.
  """

  func drawPinExample() {
    if viewA.isVisible {
      viewA.removeFromSuperview()
      viewB.removeFromSuperview()
      return
    }
    viewA.backgroundColor = UIColor.yellow
    viewB.backgroundColor = UIColor.blue
    self.view.addSubview(viewA)
    self.view.addSubview(viewB)
    viewA.pinWidth(200)
    viewA.pinHeight(200)
    viewB.pinWidth(50)
    viewB.pinHeight(50)
    var x = pin(viewA.centerX, to: self.view.centerX)
    var y = pin(viewA.centerY, to: self.view.centerY)
    pin(viewB.centerX, to: viewA.centerX)
    pin(viewB.centerY, to: viewA.centerY)
    self.view.layoutIfNeeded()
    
    func animateX(delay: Double, closure: @escaping ()->NSLayoutConstraint) {
      UIView.animate(seconds: 1, delay: delay) { [weak self] in
        guard let self = self, self.viewA.isVisible else { return }
        x.isActive = false
        x = closure()
        self.view.layoutIfNeeded()
      }
    }
    func animateY(delay: Double, closure: @escaping ()->NSLayoutConstraint) {
      UIView.animate(seconds: 1, delay: delay) { [weak self] in
        guard let self = self, self.viewA.isVisible else { return }
        y.isActive = false
        y = closure()
        self.view.layoutIfNeeded()
      }
    }
    
    animateY(delay: 0) { pin(self.viewA.top, to: self.view.topGuide()) }
    animateY(delay: 1) { pin(self.viewA.bottom, to: self.view.bottomGuide(), dist: -60) }
    animateY(delay: 2) { pin(self.viewA.centerY, to: self.view.centerY) }
    animateX(delay: 3) { pin(self.viewA.right, to: self.view.rightGuide(isMargin: true)) }
    animateX(delay: 4) { pin(self.viewA.left, to: self.view.leftGuide(isMargin: true)) }
    animateX(delay: 5) { pin(self.viewA.centerX, to: self.view.centerX) }
  }
  
  func drawFontLabel() {
    if label.isVisible {
      label.removeFromSuperview()
      waste.removeFromSuperview()
      return
    }
    let font = UIFont(name: "Papyrus", size: 20)!
    label.font = font
    label.text = "Family: \(font.familyName), Name: \(font.fontName)"
    label.backgroundColor = UIColor.rgb(0xdddddd)
    self.view.addSubview(label)
    pin(label.centerX, to: self.view.centerX)
    pin(label.centerY, to: self.view.centerY, dist: 250)
    label.onTap { _ in self.printFontNames() }
    let biv = waste
    biv.buttonView.symbol = "trash"
    view.addSubview(biv)
    pin(biv.centerX, to: self.view.centerX)
    pin(biv.centerY, to: self.view.centerY, dist: 170)
    biv.pinWidth(100)
    biv.pinHeight(100)
    biv.backgroundColor = .blue
    biv.buttonView.backgroundColor = .yellow
    biv.onPress { [weak self] _ in self?.drawFontLabel() }
  }

  func makeToolbar() {
    self.view.backgroundColor = UIColor.rgb(0xeeeeee)
    toolBar.placeInViewController(self, isTop: false)
    toolBar.backgroundColor = UIColor.rgb(0x101010)
    let backButton = Button<LeftArrowView>(width: 25, height: 25)
    let pinButton = Button<ImageView>()
    let fontButton = Button<TextView>()
    let gifButton = Button<TextView>()
    let alertButton = Button<TextView>()
    backButton.pinWidth(22)
    backButton.pinHeight(22)
    backButton.lineWidth = 0.08
    backButton.isBistable = false
    toolBar.addButton(backButton, direction: .left)
    pinButton.buttonView.symbol = "mount"
    pinButton.pinWidth(30)
    pinButton.pinHeight(30)
    toolBar.addButton(pinButton, direction: .right)
    toolBar.addButton(Toolbar.Spacer(), direction: .right)
    fontButton.buttonView.text = "F"
    fontButton.pinWidth(30)
    fontButton.pinHeight(30)
    toolBar.addButton(fontButton, direction: .right)
    toolBar.addButton(Toolbar.Spacer(), direction: .right)
    gifButton.buttonView.text = "G"
    gifButton.pinWidth(30)
    gifButton.pinHeight(30)
    toolBar.addButton(gifButton, direction: .right)
    toolBar.addButton(Toolbar.Spacer(), direction: .right)
    alertButton.buttonView.text = "A"
    alertButton.pinWidth(30)
    alertButton.pinHeight(30)
    toolBar.addButton(alertButton, direction: .right)
    toolBar.setButtonColor(UIColor.rgb(0xeeeeee))
    backButton.onPress { _ in
      self.navigationController?.popViewController(animated: true)
    }
    pinButton.onPress { [weak self] _ in self?.drawPinExample() }
    fontButton.onPress { [weak self] _ in self?.drawFontLabel() }
    gifButton.onPress { [weak self] _ in self?.drawGif() }
    alertButton.onPress { [weak self] _ in self?.alertTest() }
    bottomView.backgroundColor = UIColor.rgb(0x101010)
    self.view.addSubview(bottomView)
    bottomView.pinWidth(to: self.view.width)
    pin(bottomView.bottom, to: self.view.bottom)
    pin(bottomView.top, to: toolBar.bottom)
  }
  
  func drawGif() {
    if gif != nil {
      gif?.removeFromSuperview()
      gif = nil
      return
    }
    if let path = Bundle.main.path(forResource: "moment", ofType: "gif"),
      let image = UIImage.animatedGif(File(path).data) {
      gif = UIImageView(image: image)
      self.view.addSubview(gif!)
      var isize = image.size
      let maxHeight: CGFloat = 200
      if isize.height > maxHeight {
        let factor = maxHeight / isize.height
        isize.height *= factor
        isize.width *= factor
      }
      gif!.pinSize(isize)
      pin(gif!.top, to: self.view.topGuide(), dist: 10)
      pin(gif!.left, to: self.view.leftGuide(), dist: 10)
    }
  }
  
  func printFontNames() {
    for family in UIFont.familyNames.sorted() {
      if family == "System Font" { continue }
      let names = UIFont.fontNames(forFamilyName: family)
      print("Family: \(family) Font names: \(names)")
    }
  }
  
  func alertTest() {
    let actions = [
      Alert.action("test 1") { s in print(s) },
      Alert.action("test 2") { s in print(s) },
      Alert.action("test 3") { s in print(s) },
      Alert.action("test 4") { s in print(s) }
    ]
    Alert.actionSheet(title: "Title", message: "Test", actions: actions)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    makeToolbar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
}


