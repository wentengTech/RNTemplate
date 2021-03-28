//
//  YDImageViewManager.swift
//
//  Created by jackie on 2020/8/20.
//

import Foundation


@objc(YDImageViewManager)
class YDImageViewManager: RCTViewManager {
  
  
  override func view() -> UIView! {
    let imageView = YDImageView(frame: CGRect.zero)
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }
  
  @objc public func onUpdate(_ node: NSNumber, content: NSString) {
    // 过滤掉无效的content
    let contentStr = content as String
    if (contentStr.count <= 0 || !contentStr.contains("http")) {
      return
    }
    // 主线程上更新imageview控件的网络图片路径信息
    DispatchQueue.main.async {
      if let imageView = self.bridge.uiManager.view(forReactTag: node) as? YDImageView {
        imageView.filePath = content
        imageView.onUpdate()
      }
    }
  }
  
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  
  
  private func getTargetView(node: NSNumber) -> YDImageView? {
    if let view = self.bridge.uiManager.view(forReactTag: node) {
      return view as? YDImageView
    }
    return nil
  }
  
  
}
