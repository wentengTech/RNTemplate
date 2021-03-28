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
  
  
  public func showImage(imageName: String?) {
    guard let imageNameValue = imageName else {
      return
    }
    if self.loadedShowImageName != nil, self.loadedShowImageName! == imageName {
      return
    }
    self.loadedShowImageName = imageNameValue
    let image = UIImage(named: "\(imageNameValue)")
    DispatchQueue.main.async {
      self.image = image
    }
  }
  
  // 加载网络类型的图片
  public func loadImage(url: String?) {
    self.showImage(imageName: self.defaultImageName as String?)
    guard let urlValue = url else {
      return
    }
    if self.loadedShowFilePath != nil, self.loadedShowFilePath! == url, !url!.contains("http") {
      return
    }
    
    self.loadedShowFilePath = url
    // let defaultImage = defaultImageName != nil ? UIImage(named: defaultImageName! as String) : nil
    // self.sd_setImage(with: URL(string: urlValue), placeholderImage: defaultImage)
    
    // 获取目标图片在本地系统的图片路径信息，可能不存在
    let localFilePath = CommonUtils.shared.getLocalDocumentFilePath(filePath: urlValue)
    
    //优先检索本地是否存在该图片
    if FileManager.default.fileExists(atPath: localFilePath) {
        // 本地目录存在，则加载本地图片并显示
      DispatchQueue.main.async {
        self.image = UIImage.init(contentsOfFile: localFilePath)
      }
    } else {
        // 本地目录不存在，则从网络服务器加载并显示，同时异步保存到本地目录
        DispatchQueue.global().async {
          if let requestUrl = URL(string: urlValue), let data: Data = try? Data(contentsOf: requestUrl), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
                // 保存图片到本地
                try! image.pngData()?.write(to: URL(fileURLWithPath: "\(localFilePath)"), options: .atomic)
            }
        }
    }
  }


}
