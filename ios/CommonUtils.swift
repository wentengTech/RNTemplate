//
//  CommonUtils.swift
//  SesameRNProject
//
//  Created by jackie on 2020/8/20.
//

import Foundation
import UIKit

class CommonUtils: NSObject {
  
  func arrayToJson<E: Encodable>(_ objects: [E]?) -> String? {
    guard let objectsValue = objects else {
      return nil
    }
    let jsonEncoder = JSONEncoder()
    do {
      let jsonData = try jsonEncoder.encode(objectsValue)
      return String(data: jsonData, encoding: String.Encoding.utf8)
    } catch {
      return nil
    }
  }
  
  // MARK: - base64加密
  func encode64(str: String?) -> String? {
    if let value = str {
      let plainData = value.data(using: String.Encoding.utf8)
      return (plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0)))!
    } else {
      return nil
    }
  }
  
  // base64解码
  func decodeBase64(content: String?) -> String? {
    guard let value = content else {
      return nil
    }
    //Convert string to NSData
    guard let myData = value.data(using: .utf8) else {
      return nil
    }
    
    //Decode base64
    guard let resultData = NSData(base64Encoded: myData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) else {
      return nil
    }
    
    //Convert NSData to NSString
    guard let resultNSString = NSString(data: resultData as Data, encoding: String.Encoding.utf8.rawValue) else {
      return nil
    }
    
    //Convert NSString to String
    return resultNSString as String
  }
  
  static let shared = CommonUtils()
  private override init() {
    super.init()
  }
  
  // MARK: - 本地文件加载函数
  func getLocalDocumentFilePath(filePath: String) -> String {
    let fileName = getFileName(filePath: filePath) + (CommonUtils.shared.encode64(str: filePath) ?? "xx_xx");
    let localFilePath    = NSHomeDirectory() + "/Documents/files\(String(describing: fileName))"
    let parentFolderPath = getParentFolderPath(filePath: localFilePath)
    // 确保父文件夹创建好
    if !FileManager.default.fileExists(atPath: parentFolderPath) {
      try? FileManager.default.createDirectory(atPath: parentFolderPath, withIntermediateDirectories: true, attributes: nil)
    }
    return localFilePath
  }
  
  //从filePath路径中获取父路径目录的信息
  private func getParentFolderPath(filePath: String) -> String {
    let index = filePath.endIndex(of: "/", options: .backwards) ?? filePath.endIndex
    return String(filePath[..<index])
  }
  
  private func getFileName(filePath: String) -> String {
    let index = filePath.endIndex(of: "/", options: .backwards) ?? filePath.startIndex
    return String(filePath[filePath.index(index, offsetBy: 1)..<filePath.endIndex])
  }
  
  // MARK: -
  // 获取当前的key的window
  func getKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
      for window in UIApplication.shared.windows {
        if (window.isKeyWindow) {
          return window
        }
      }
      return nil
    } else {
      return UIApplication.shared.keyWindow
    }
  }
  
  // 获取iphone的安全距离，以兼容iphone x
  func getSafeAreaInsets() -> UIEdgeInsets {
    if #available(iOS 11.0, *), let window = UIApplication.shared.windows.first {
      return window.safeAreaInsets
    }
    return UIEdgeInsets.zero
  }
  
  
  
  // 渐变距离， 44 是导航栏的默认高度, 20
  private var gradientLenght: CGFloat = 0
  private func getGradientLength(viewController: UIViewController) -> CGFloat {
    if gradientLenght == 0 {
      
      // 设置滑动距离的默认高度
      gradientLenght = 40
      
      // 添加状态栏的高度
      if #available(iOS 13.0, *) {
        gradientLenght += UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0
      } else {
        gradientLenght += UIApplication.shared.statusBarFrame.height
      }
      
      // 添加导航栏的高度，如果存在
      if let value = viewController.navigationController?.navigationBar.frame.height {
        gradientLenght += value
      }
      
      // 如果存在安全距离
      gradientLenght += getSafeAreaInsets().top
    }
    return gradientLenght
  }
  
  // 渐变距离， 44 是导航栏的默认高度, 20
  func gradientTransparent(viewController: UIViewController, title: String? = nil, collectionView: UICollectionView? = nil) {
    
    // 对于滑动视图(UICollectionView)有滑动的距离，说明其原本存在，已设置好沉浸式。
    if collectionView != nil && collectionView!.contentOffset.y > 0 {
      self.toggleGradient(scrollView: collectionView!, viewController: viewController, title: title)
      return
    }
    
    // 设置滑动距离
    self.gradientLenght = getGradientLength(viewController: viewController)
    
    // 集合视图的沉浸式兼容
    if let value = collectionView {
      if #available(iOS 11.0, *) {
        value.contentInsetAdjustmentBehavior = .automatic
      }
    }
    
    // 设置导航栏透明
    viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mainGroupBackgroundColor]
    viewController.navigationController?.navigationBar.tintColor = mainGroupBackgroundColor
    viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    viewController.navigationItem.title = title
  }
  
  // 渐变非透明函数
  func gradientNontransparent(viewController: UIViewController, title: String? = nil) {
    // 清空滑动距离
    self.gradientLenght = 0
    // 设置导航栏不透明
    viewController.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    viewController.navigationController?.navigationBar.shadowImage = nil
    viewController.navigationController?.navigationBar.tintColor = .blue
    viewController.navigationController?.navigationBar.titleTextAttributes = nil
    viewController.navigationItem.title = title
  }
  
  // 在导航栏视图的导航栏上下滑动切换隐藏效果
  func toggleGradient(scrollView: UIScrollView, viewController: UIViewController, title: String?) {
    guard viewController.navigationController != nil else {
      return
    }
    let offsetY = scrollView.contentOffset.y
    if offsetY <= getGradientLength(viewController: viewController) {
      if viewController.navigationController!.navigationBar.tintColor == .blue {
        CommonUtils.shared.gradientTransparent(viewController: viewController)
      }
    }
    else {
      if viewController.navigationController!.navigationBar.tintColor != .blue {
        CommonUtils.shared.gradientNontransparent(viewController: viewController, title: title)
      }
    }
  }
  
  
  ///
  
  private var mBProgressHUD: MBProgressHUD? = nil
  private var mBProgressHUDLoadingTimer: Timer? = nil
  
  // 该方式的内容会2s后自动消失
  func show(text: String?, viewController: UIViewController? = UIViewController.currentViewController()) {
    guard text != nil else {
      return
    }
    // 关闭之前的
    self.hide()
    
    mBProgressHUD = MBProgressHUD.showAdded(to: (viewController?.view)!, animated: true)
    mBProgressHUD?.mode = .text
    mBProgressHUD?.label.text = text
    mBProgressHUD?.isUserInteractionEnabled = false
    mBProgressHUD?.removeFromSuperViewOnHide = true
    mBProgressHUD?.hide(animated: true, afterDelay: 2)
  }
  
  func showFailure(text: String?, viewController: UIViewController? = UIViewController.currentViewController()) {
    show(text: text, viewController: viewController)
  }
  
  // 延迟loading展示
  func showDelayLoading(text: String) {
    self.hide()
    mBProgressHUDLoadingTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
      let viewController = UIViewController.currentViewController()
      self.mBProgressHUD = MBProgressHUD.showAdded(to: (viewController?.view)!, animated: true)
      self.mBProgressHUD?.label.text = text
      self.mBProgressHUD?.removeFromSuperViewOnHide = true
    }
  }
  
  // 展示loading效果控件
  func showLoading(text: String?, viewController: UIViewController? = UIViewController.currentViewController()) {
    //关闭之前的
    self.hide()
    
    mBProgressHUD = MBProgressHUD.showAdded(to: (viewController?.view)!, animated: true)
    mBProgressHUD?.label.text = text
    mBProgressHUD?.removeFromSuperViewOnHide = true
    //mBProgressHUD?.hide(animated: true, afterDelay: 60)
  }
  
  // 展示loading效果控件
  func showSuccessText(text: String?, viewController: UIViewController? = UIViewController.currentViewController()) {
    //关闭之前的
    self.hide()
    
    let imageView = UIImageView(image: UIImage(named: "check-unchecked"))
    mBProgressHUD = MBProgressHUD.showAdded(to: (viewController?.view)!, animated: true)
    mBProgressHUD?.mode = .customView
    mBProgressHUD?.customView = imageView
    mBProgressHUD?.label.text = text
    mBProgressHUD?.isUserInteractionEnabled = false
    mBProgressHUD?.removeFromSuperViewOnHide = true
    mBProgressHUD?.hide(animated: true, afterDelay: 2)
  }
  
  // 隐藏mBProgressHUD控件
  func hide() {
    if mBProgressHUDLoadingTimer != nil {
      mBProgressHUDLoadingTimer?.invalidate()
      mBProgressHUDLoadingTimer = nil
    }
    
    if mBProgressHUD != nil {
      mBProgressHUD?.removeFromSuperview()
      mBProgressHUD = nil
    }
  }
}
