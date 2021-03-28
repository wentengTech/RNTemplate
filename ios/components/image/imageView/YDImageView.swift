//
//  ImageView.swift
//
//  Created by jackie on 2020/8/11.
//

import UIKit


class YDImageView: UIImageView {
  
  // 本地图片
  @objc var fileName: NSString? = nil
  
  // 网络图片
  @objc var filePath: NSString? = nil
  // 网络图片显示失败下，未显示前默认显示的本地图片
  @objc var defaultImageName: NSString? = nil
  
  @objc var cornerRadius: NSNumber? = nil
  @objc var previewable: NSNumber? = nil
  
  // 将onUpdate的操作放置到后面
  private var hasMoveToWindow = false
  
  //
  private var loadedShowImageName: String? = nil
  private var loadedShowFilePath: String? = nil
  
  private static var userInterfaceStyleBeDarkTheme: Bool? = nil
  private var sessionQueue: DispatchQueue? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.sessionQueue = DispatchQueue(label: "YDImageViewComponentQueue")
    if YDImageView.userInterfaceStyleBeDarkTheme == nil {
      if #available(iOS 12.0, *), self.traitCollection.userInterfaceStyle == .dark {
        YDImageView.userInterfaceStyleBeDarkTheme = true
      } else {
        YDImageView.userInterfaceStyleBeDarkTheme = false
      }
    }
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.touchImageView)))
  }
  
  
  // 图片点击后的预览
  @objc func touchImageView() {
    if self.previewable != nil && self.previewable! == 1 {
      ImageViewController.factory(index: 0, imageViews: [self])
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  public func onUpdate() {
    // 当hasMoveToWindow为true时候，才执行onUpdate，否则拦截loadImage，但是不能拦截filePath的设置逻辑
    if !self.hasMoveToWindow {
      return
    }
    self.sessionQueue?.async {
      if let value = self.filePath {
        self.loadImage(url: value as String)
      }
    }
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    self.hasMoveToWindow = true
    
    if let value = self.cornerRadius {
      self.layer.cornerRadius = CGFloat(truncating: value)
      self.layer.masksToBounds = true
    }
    
    if let value = self.fileName {
      self.sessionQueue?.async {
        self.showImage(imageName: value as String)
      }
    }
    
    if let value = self.filePath {
      self.sessionQueue?.async {
        self.loadImage(url: value as String)
      }
    }
  }
  
  
  public func showImage(imageName: String) {
    if self.loadedShowImageName != nil, self.loadedShowImageName! == imageName {
      return
    }
    self.loadedShowImageName = imageName
    let image = UIImage(named: "\(imageName)")
    DispatchQueue.main.async {
      self.image = image
    }
  }
  
  // 加载网络类型的图片
  public func loadImage(url: String?) {
    guard let urlValue = url else {
      return
    }
    if self.loadedShowFilePath != nil, self.loadedShowFilePath! == url {
      return
    }
    if !url!.contains("http") {
      return
    }
    self.loadedShowFilePath = url
    let defaultImage = defaultImageName != nil ? UIImage(named: defaultImageName! as String) : nil
    self.sd_setImage(with: URL(string: urlValue), placeholderImage: defaultImage)
  }


}
