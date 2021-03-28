//
//  File.swift
//  SesameRNProject
//
//  Created by jackie on 2020/8/20.
//

import Foundation
import UIKit

// 一般用于模块视图的背景颜色
var mainGroupBackgroundColor: UIColor {
  if #available(iOS 13.0, *) {
    return UIColor.secondarySystemGroupedBackground
  } else {
    return UIColor.white
  }
}


extension StringProtocol where Index == String.Index {
  func index<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
    return range(of: string, options: options)?.lowerBound
  }
  func endIndex<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> Index? {
    return range(of: string, options: options)?.upperBound
  }
  func indexes<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Index] {
    var result: [Index] = []
    var start = startIndex
    while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
      result.append(range.lowerBound)
      start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
  func ranges<T: StringProtocol>(of string: T, options: String.CompareOptions = []) -> [Range<Index>] {
    var result: [Range<Index>] = []
    var start = startIndex
    while start < endIndex, let range = range(of: string, options: options, range: start..<endIndex) {
      result.append(range)
      start = range.lowerBound < range.upperBound  ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
    }
    return result
  }
  
}



extension UIViewController {
  
  //获取当前第一响应状态的UIViewController
  class func currentViewController(base: UIViewController? = nil) -> UIViewController? {
    var baseViewController = base
    // base的空情况处理
    if baseViewController == nil {
      baseViewController = CommonUtils.shared.getKeyWindow()?.rootViewController
    }
    
    if let nav = baseViewController as? UINavigationController {
      return currentViewController(base: nav.visibleViewController)
    }
    if let tab = baseViewController as? UITabBarController {
      return currentViewController(base: tab.selectedViewController)
    }
    if let presented = baseViewController?.presentedViewController {
      return currentViewController(base: presented)
    }
    return baseViewController
  }
  
  
  // 后退两步 - pop到底部
  class func popBackTwiceOrPopToRootToViewController() {
    // 往后回退两个页面
    if let children = UIViewController.currentViewController()?.navigationController?.children, let targetViewController = UIViewController.currentViewController()?.navigationController?.children[children.count - 3] {
      UIViewController.currentViewController()?.navigationController?.popToViewController(targetViewController, animated: true)
    } else {
      UIViewController.currentViewController()?.navigationController?.popToRootViewController(animated: true)
    }
  }
}



extension UIView {
  
  public func layoutWithLayoutConstraint(leading: NSLayoutXAxisAnchor? = nil,
                                         leadingConstant: CGFloat? = nil,
                                         trailing: NSLayoutXAxisAnchor? = nil,
                                         trailingConstant: CGFloat? = nil,
                                         top: NSLayoutYAxisAnchor? = nil,
                                         topConstant: CGFloat? = nil,
                                         bottom: NSLayoutYAxisAnchor? = nil,
                                         bottomConstant: CGFloat? = nil,
                                         centerX: NSLayoutXAxisAnchor? = nil,
                                         centerXConstant: CGFloat = 0,
                                         centerY: NSLayoutYAxisAnchor? = nil,
                                         centerYConstant: CGFloat = 0,
                                         width: NSLayoutDimension? = nil,
                                         widthConstant: CGFloat = 0,
                                         height: NSLayoutDimension? = nil,
                                         heightConstant: CGFloat = 0,
                                         widthValue: CGFloat? = nil,
                                         heightValue: CGFloat? = nil) -> [NSLayoutConstraint] {
    
    var layoutConstraint = [NSLayoutConstraint]()
    
    //
    self.translatesAutoresizingMaskIntoConstraints = false
    
    // 空值处理
    let tempLeadingConstant = leadingConstant ?? 12
    let tempTrailingConstant = trailingConstant ?? -12
    let tempTopConstant = topConstant ?? 12
    let tempBottomConstant = bottomConstant ?? -12
    
    if let leadingAnchor = leading {
      layoutConstraint.append(customLeadingAnchorConstraint(leadingAnchor: leadingAnchor, leadingConstant: tempLeadingConstant))
    }
    if let trailingAnchor = trailing {
      layoutConstraint.append(customTrailingAnchorConstraint(trailingAnchor: trailingAnchor, trailingConstant: tempTrailingConstant))
    }
    if let topAnchor = top {
      layoutConstraint.append(customTopAnchorConstraint(topAnchor: topAnchor, topConstant: tempTopConstant))
    }
    if let bottomAnchor = bottom {
      layoutConstraint.append(customBottomAnchorConstraint(bottomAnchor: bottomAnchor, bottomConstant: tempBottomConstant))
    }
    if let widthAnchor = width {
      layoutConstraint.append(customWidthAnchorConstraint(widthAnchor: widthAnchor, widthConstant: widthConstant))
    }
    if let heightAnchor = height {
      layoutConstraint.append(customHeightAnchorConstraint(heightAnchor: heightAnchor, heightConstant: heightConstant))
    }
    if widthValue != nil {
      layoutConstraint.append(customWidthConstantConstraint(widthValue: widthValue!))
    }
    if heightValue != nil {
      layoutConstraint.append(customHeightConstantConstraint(heightValue: heightValue!))
    }
    if let centerXAnchor = centerX {
      layoutConstraint.append(customCenterXAnchorConstraint(centerXAnchor: centerXAnchor, centerXConstant: centerXConstant))
    }
    if let centerYAnchor = centerY {
      layoutConstraint.append(customCenterYAnchorConstraint(centerYAnchor: centerYAnchor, centerYConstant: centerYConstant))
    }
    
    for item in layoutConstraint {
      item.isActive = true
    }
    
    return layoutConstraint
  }
  
  
  // MARK: - 自定义布局逻辑
  public func layout(leading: NSLayoutXAxisAnchor? = nil,
                     leadingConstant: CGFloat? = nil,
                     trailing: NSLayoutXAxisAnchor? = nil,
                     trailingConstant: CGFloat? = nil,
                     top: NSLayoutYAxisAnchor? = nil,
                     topConstant: CGFloat? = nil,
                     bottom: NSLayoutYAxisAnchor? = nil,
                     bottomConstant: CGFloat? = nil,
                     centerX: NSLayoutXAxisAnchor? = nil,
                     centerXConstant: CGFloat = 0,
                     centerY: NSLayoutYAxisAnchor? = nil,
                     centerYConstant: CGFloat = 0,
                     width: NSLayoutDimension? = nil,
                     widthConstant: CGFloat = 0,
                     height: NSLayoutDimension? = nil,
                     heightConstant: CGFloat = 0,
                     widthValue: CGFloat? = nil,
                     heightValue: CGFloat? = nil) {
    
    let _ = layoutWithLayoutConstraint(leading: leading, leadingConstant: leadingConstant,
                                       trailing: trailing, trailingConstant: trailingConstant,
                                       top: top, topConstant: topConstant,
                                       bottom: bottom, bottomConstant: bottomConstant,
                                       centerX: centerX, centerXConstant: centerXConstant,
                                       centerY: centerY, centerYConstant: centerYConstant,
                                       width: width, widthConstant: widthConstant,
                                       height: height, heightConstant: heightConstant,
                                       widthValue: widthValue, heightValue: heightValue)
  }
  
  
  
  
  
  @objc public func customLeadingAnchorConstraint(leadingAnchor: NSLayoutXAxisAnchor, leadingConstant: CGFloat) -> NSLayoutConstraint {
    return self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant)
  }
  
  @objc public func customTrailingAnchorConstraint(trailingAnchor: NSLayoutXAxisAnchor, trailingConstant: CGFloat) -> NSLayoutConstraint {
    return self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant)
  }
  
  @objc public func customTopAnchorConstraint(topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) -> NSLayoutConstraint {
    return self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant)
  }
  
  @objc public func customBottomAnchorConstraint(bottomAnchor: NSLayoutYAxisAnchor, bottomConstant: CGFloat) -> NSLayoutConstraint {
    return self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant)
  }
  
  @objc public func customCenterXAnchorConstraint(centerXAnchor: NSLayoutXAxisAnchor, centerXConstant: CGFloat) -> NSLayoutConstraint {
    return self.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerXConstant)
  }
  
  @objc public func customCenterYAnchorConstraint(centerYAnchor: NSLayoutYAxisAnchor, centerYConstant: CGFloat) -> NSLayoutConstraint {
    return self.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYConstant)
  }
  
  @objc public func customWidthAnchorConstraint(widthAnchor: NSLayoutDimension, widthConstant: CGFloat) -> NSLayoutConstraint {
    return self.widthAnchor.constraint(equalTo: widthAnchor, constant: widthConstant)
  }
  
  @objc public func customHeightAnchorConstraint(heightAnchor: NSLayoutDimension, heightConstant: CGFloat) -> NSLayoutConstraint {
    return self.heightAnchor.constraint(equalTo: heightAnchor, constant: heightConstant)
  }
  
  @objc public func customHeightConstantConstraint(heightValue: CGFloat) -> NSLayoutConstraint {
    return self.heightAnchor.constraint(equalToConstant: heightValue)
  }
  
  @objc public func customWidthConstantConstraint(widthValue: CGFloat) -> NSLayoutConstraint {
    return self.widthAnchor.constraint(equalToConstant: widthValue)
  }
}

