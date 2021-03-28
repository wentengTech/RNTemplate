//
//  ImageViewItemCollectionViewCell.swift
//  automoniaProject
//
//  Created by jackie on 2019/3/24.
//  Copyright © 2019 温腾. All rights reserved.
//

import Foundation
import UIKit

class ImageViewItemCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {
  
  private var scrollView      : UIScrollView! = nil
  private var imageView       : UIImageView! = nil
  
  private var imageViewTopConstraint      : NSLayoutConstraint! = nil
  private var imageViewLeftConstraint     : NSLayoutConstraint! = nil
  private var imageViewRightConstraint    : NSLayoutConstraint! = nil
  private var imageViewBottomConstraint   : NSLayoutConstraint! = nil
  
  private var initZoomScale: CGFloat = -1
  
  // 特定时间内原图没有加载到，则显示加载中。但是不要一开始就显示。
  private var showLoadingTimer : Timer? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.maximumZoomScale = 5
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.frame = self.contentView.bounds
    self.contentView.addSubview(scrollView)
    
    imageView = UIImageView()
    scrollView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewLeftConstraint = imageView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor)
    imageViewTopConstraint  = imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor)
    imageViewRightConstraint = imageView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor)
    imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
    NSLayoutConstraint.activate([imageViewLeftConstraint, imageViewRightConstraint, imageViewTopConstraint, imageViewBottomConstraint])
    imageView.isUserInteractionEnabled = true
    
    
    scrollView.isUserInteractionEnabled = true
    
    // 单点单次点击手势
    let oneTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
    scrollView.addGestureRecognizer(oneTapGesture)
    
    // 单点两次点击手势
    let twoTapGesutre = UITapGestureRecognizer(target: self, action: #selector(self.twoTapsGesture))
    twoTapGesutre.numberOfTapsRequired = 2
    scrollView.addGestureRecognizer(twoTapGesutre)
    
    //单次点击手势 和 多次点击手势 兼容处理
    //优先检测moreTap,若moreTap检测不到，或检测失败，则检测singleTap,检测成功后，触发方法
    oneTapGesture.require(toFail: twoTapGesutre)
    
    // 拖动手势
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panDownGesture))
    panGesture.delegate = self
    panGesture.maximumNumberOfTouches = 1
    panGesture.minimumNumberOfTouches = 1
    scrollView.addGestureRecognizer(panGesture)
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func presentView(image: UIImage?) -> ImageViewItemCollectionViewCell {
    self.imageView.image = image
    return self
  }
  
  //    func build(imageView: UIImageView) -> ImageViewItemCollectionViewCell {
  //        guard imageView.image != nil else {
  //            return self
  //        }
  //        
  //        // 优先显示imageView中的图片, 以快速的显示图片
  //        self.imageView.image = imageView.image
  //
  //        var minZoom = min(scrollView.bounds.size.width / imageView.image!.size.width, scrollView.bounds.size.height / imageView.image!.size.height)
  //        if minZoom > 1 { minZoom = 1 }
  //        scrollView.minimumZoomScale = minZoom
  //        self.initZoomScale = minZoom
  //        self.scrollView.setZoomScale(minZoom, animated: false)
  //        
  //        // 如果是缩略图模式, 启动加载器，用于加载显示原图
  //        if let thumbnailModelValue = imageView.getIsThumbnailModel(), thumbnailModelValue {
  //            
  //            // 创建0.2s后的定时器,定时打开loading效果
  //            self.showLoadingTimer = Timer(timeInterval: 0.2, repeats: false) { _ in
  //                CommonUtils.shared.showLoading(text: nil)
  //            }
  //            
  //            // 显示原图，显示完成后清楚定时器
  //            self.imageView.showOriginalImage(filePath: imageView.getOriginalImageFilePath()) { _ in
  //                self.showLoadingTimer?.invalidate()
  //                CommonUtils.shared.hide()
  //            }
  //        }
  //        
  //        return self
  //    }
  
  
  // 单次的点击是退出当前视图
  @objc func tapGesture() {
    UIViewController.currentViewController()?.dismiss(animated: true, completion: nil)
  }
  
  // 双次的点击是退出当前视图
  @objc func twoTapsGesture(_ gesture: UIGestureRecognizer) {
    if self.scrollView.zoomScale == self.initZoomScale {
      let scaleX = self.contentView.bounds.width / self.imageView.image!.size.width
      let scaleY = self.contentView.bounds.height / self.imageView.image!.size.height
      let scaleValue = max(max(scaleX, scaleY), 2)
      
      var zoomRect = CGRect.zero
      zoomRect.size = CGSize(width: imageView.frame.size.width  / scaleValue, height: imageView.frame.size.height / scaleValue)
      let touchedCenter = imageView.convert(gesture.location(in: gesture.view), from: self)
      zoomRect.origin = CGPoint(x: touchedCenter.x - ((zoomRect.size.width / 2.0)), y: touchedCenter.y - ((zoomRect.size.height / 2.0)))
      self.scrollView.zoom(to: zoomRect, animated: true)
    }
    else {
      self.scrollView.setZoomScale(self.initZoomScale, animated: true)
    }
  }
  
  // 向下拖动是退出视图
  private var startLocationOfPanGesture: CGPoint = CGPoint.zero
  private var startTransform = CGAffineTransform.identity
  private var allowPanGesture = true
  private var startScale: CGFloat = 0
  @objc func panDownGesture(_ gesture: UIPanGestureRecognizer) {
    // 有效性的验证, 一个手指的拖动，scrollView在顶部
    guard gesture.numberOfTouches <= 1, self.scrollView.contentOffset.y <= 0 else {
      return
    }
    // 手势开始拖动，判定方向是否为向下垂直(不要求严格的垂直)。否则后续所有事件都忽略
    let translation = gesture.velocity(in: gesture.view)
    if gesture.state == .began && (translation.x >= 88 || translation.x <= -88 || translation.y <= 0) {
      allowPanGesture = false
    }
    if gesture.state == .ended {
      allowPanGesture = true
    }
    guard allowPanGesture else {
      return
    }
    
    // 当前拖动有效，开始执行相关逻辑
    if gesture.state == .began {
      // 记录拖动的初始信息
      //            startTransform = self.imageView.transform
      startScale = self.scrollView.zoomScale
      startLocationOfPanGesture = gesture.location(in: self.scrollView)
    }
    // 做个变换集合
    var transformOfImageView = CGAffineTransform.identity.scaledBy(x: startScale, y: startScale)
    
    // 如果目前状态是结束了
    if gesture.state == .ended {
      UIView.animate(withDuration: 0.2) {
        self.imageView.transform = transformOfImageView
        let viewController = UIViewController.currentViewController()
        viewController?.view.backgroundColor = UIColor.black.withAlphaComponent(1)
        viewController?.view.viewWithTag(1001)?.backgroundColor = UIColor.black.withAlphaComponent(1)
      }
      return
    }
    
    // 获取当前点击的点
    let currentLocationOfPanGesture = gesture.location(in: self.scrollView)
    
    // 使整个视图透明，以透视上一个视图。备注：上一个视图设置为并未从视图栈中移除
    // ImageViewController的视图层级。collectionView的tag是1001
    let alphaValue = 1 - (currentLocationOfPanGesture.y - startLocationOfPanGesture.y) / self.scrollView.bounds.width
    let viewController = UIViewController.currentViewController()
    viewController?.view.backgroundColor = UIColor.black.withAlphaComponent(alphaValue)
    viewController?.view.viewWithTag(1001)?.backgroundColor = UIColor.black.withAlphaComponent(alphaValue)
    
    // 移动视图
    let translationX = (currentLocationOfPanGesture.x - startLocationOfPanGesture.x)
    let translationY = (currentLocationOfPanGesture.y - startLocationOfPanGesture.y)
    transformOfImageView = transformOfImageView.translatedBy(x: translationX, y: translationY)
    
    // 向下移动过程中缩小图片
    let scaleValue = 1 - (currentLocationOfPanGesture.y - startLocationOfPanGesture.y) / self.scrollView.bounds.height
    if scaleValue <= 1 {
      transformOfImageView = transformOfImageView.scaledBy(x: scaleValue, y: scaleValue)
    }
    
    UIView.animate(withDuration: 0, animations: {
      self.imageView.transform = transformOfImageView
    })
  }
  
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////UIScrollViewDelegate/////
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    guard self.imageView.image != nil else {
      return
    }
    
    let imageWidth = imageView.image!.size.width
    let imageHeight = imageView.image!.size.height
    
    let viewWidth = scrollView.bounds.size.width
    let viewHeight = scrollView.bounds.size.height
    
    // center image if it is smaller than the scroll view
    var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
    if hPadding < 0 { hPadding = 0 }
    
    var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
    if vPadding < 0 { vPadding = 0 }
    
    imageViewLeftConstraint.constant = hPadding
    imageViewRightConstraint.constant = hPadding
    
    imageViewTopConstraint.constant = vPadding
    imageViewBottomConstraint.constant = vPadding
    
    self.contentView.layoutIfNeeded()
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////UIGestureRecognizerDelegate/////
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
