//
//  ImageViewCollectionViewCell.swift
//  automoniaProject
//
//  Created by jackie on 2019/4/7.
//  Copyright © 2019 温腾. All rights reserved.
//

import Foundation
import UIKit

class ImageViewCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {
  
  public var imageViewController: ImageViewController? = nil
  
  private var scrollView          : UIScrollView! = nil
  private var imageView           : UIImageView!  = nil
  private var maxZoomScaleValue   : CGFloat       = 5
  
  // 特定时间内原图没有加载到，则显示加载中。但是不要一开始就显示。
  private var showLoadingTimer : Timer? = nil
  
  
  
  func presentView(image: UIImage?) -> ImageViewCollectionViewCell {
    // 优先显示imageView中的图片, 以快速的显示图片
    self.imageView.image = image
    self.imageView.frame = getFitFrameOfImageView()
    
    // scrollView设置初始化状态，zoomScale为1
    scrollView.setZoomScale(1, animated: false)
    return self
  }
  
  
  //    func build(imageView:  UIImageView) -> ImageViewCollectionViewCell {
  //        guard imageView.image != nil else {
  //            return self
  //        }
  //        // 优先显示imageView中的图片, 以快速的显示图片
  //        self.imageView.image = imageView.image
  //        self.imageView.frame = getFitFrameOfImageView()
  //
  //        // scrollView设置初始化状态，zoomScale为1
  //        scrollView.setZoomScale(1, animated: false)
  //
  //        // 如果是缩略图模式, 启动加载器，用于加载显示原图
  //        if let thumbnailModelValue = imageView.getIsThumbnailModel(), thumbnailModelValue {
  //
  //            // 创建0.2s后的定时器,定时打开loading效果
  //            showLoadingTimer = Timer(timeInterval: 0.2, repeats: false) { _ in
  //                CommonUtils.shared.showLoading(text: nil)
  //            }
  //
  //            // 显示原图，显示完成后清除定时器
  //            self.imageView.showOriginalImage(filePath: imageView.getOriginalImageFilePath()) { _ in
  //                self.showLoadingTimer?.invalidate()
  //                CommonUtils.shared.hide()
  //            }
  //        }
  //
  //        return self
  //    }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    scrollView = UIScrollView()
    scrollView.frame = contentView.bounds
    contentView.addSubview(scrollView)
    scrollView.maximumZoomScale = maxZoomScaleValue
    scrollView.delegate = self
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    if #available(iOS 11.0, *) {
      scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    scrollView.addSubview(imageView)
    scrollView.isUserInteractionEnabled = true
    
    // 图片的长按事件
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressTouchImageCellView))
    longPressGesture.minimumPressDuration = 0.8
    scrollView.addGestureRecognizer(longPressGesture)
    
    // 单点单次点击手势
    let tapOnceGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnceAction))
    scrollView.addGestureRecognizer(tapOnceGesture)
    
    // 单点两次点击手势
    let tapTwiceGesutre = UITapGestureRecognizer(target: self, action: #selector(self.tapTwiceAction))
    tapTwiceGesutre.numberOfTapsRequired = 2
    scrollView.addGestureRecognizer(tapTwiceGesutre)
    //单次点击手势 和 多次点击手势 兼容处理
    //优先检测moreTap,若moreTap检测不到，或检测失败，则检测singleTap,检测成功后，触发方法
    tapOnceGesture.require(toFail: tapTwiceGesutre)
    
    // 拖动手势
    let downPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.downPanGesture))
    downPanGesture.delegate = self
    scrollView.addGestureRecognizer(downPanGesture)
    
  }
  
  
  @objc func longPressTouchImageCellView(gesture: UIGestureRecognizer) {
    if gesture.state == UIGestureRecognizer.State.began, let imageValue = self.imageView.image {
      let alertV = UIAlertController()
      let saveAction = UIAlertAction(title: "保存图片", style: .default) { (alertV) in
        UIImageWriteToSavedPhotosAlbum(imageValue, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
      }
      let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
      alertV.addAction(saveAction)
      alertV.addAction(cancelAction)
      UIViewController.currentViewController()?.present(alertV, animated: true, completion: nil)
    }
  }
  
  @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject){
    if didFinishSavingWithError != nil {
      CommonUtils.shared.show(text: "请开启访问相册权限后使用此功能", viewController: imageViewController)
    } else {
      CommonUtils.shared.showSuccessText(text: "图片保存成功", viewController: imageViewController)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////gesture/////
  @objc func tapOnceAction() {
    guard let _ = imageView.image else {
      return
    }
    
    if scrollView.zoomScale != 1.0 {
      scrollView.setZoomScale(1.0, animated: true)
    }
    
    ImageViewController.dismissedImageView = self.imageView
    UIViewController.currentViewController()?.dismiss(animated: true, completion: nil)
  }
  
  
  @objc func tapTwiceAction(_ gesture: UITapGestureRecognizer) {
    guard let _ = imageView.image else {
      return
    }
    if scrollView.zoomScale == 1.0 {
      // 确定合适的
      let scaleX = self.contentView.bounds.width / self.imageView.frame.size.width
      let scaleY = self.contentView.bounds.height / self.imageView.frame.size.height
      let scaleValue = max(max(scaleX, scaleY), 2)
      
      var zoomRect = CGRect.zero
      zoomRect.size = CGSize(width: imageView.frame.size.width / scaleValue, height: imageView.frame.size.height / scaleValue)
      let touchedCenter = imageView.convert(gesture.location(in: gesture.view), from: self)
      zoomRect.origin = CGPoint(x: touchedCenter.x - ((zoomRect.size.width / 2.0)), y: touchedCenter.y - ((zoomRect.size.height / 2.0)))
      self.scrollView.zoom(to: zoomRect, animated: true)
    } else {
      self.scrollView.setZoomScale(1.0, animated: true)
    }
  }
  
  
  private var beganFrame = CGRect.zero, beganTouch = CGPoint.zero, downPanValidation = true
  @objc func downPanGesture(_ gesture: UIPanGestureRecognizer) {
    guard let _ = imageView.image else {
      return
    }
    // 手势开始拖动，判定方向是否为向下垂直(不要求严格的垂直)。否则后续所有事件都忽略
    if gesture.state == .began {
      let velocity = gesture.velocity(in: self)
      if velocity.y <= 0 || abs(Int(velocity.x)) > Int(velocity.y) || scrollView.contentOffset.y > 0 {
        downPanValidation = false
      }
        // 当前的开始拖动手势是有效的，禁止UICollectionView的scroll特性
      else {
        (UIViewController.currentViewController()?.view.viewWithTag(1001) as? UICollectionView)?.isScrollEnabled = false
      }
    }
    // 拦截
    guard downPanValidation else {
      if gesture.state == .ended { downPanValidation = true }
      return
    }
    
    switch gesture.state {
    case .began:
      beganFrame = imageView.frame
      beganTouch = gesture.location(in: scrollView)
    case .changed:
      let transform = computeTransformInfoInPanGesture(gesture)
      imageView.frame = transform.frame
      alphaViewController(alphaValue: transform.scale - 0.5)
    case .ended, .cancelled:
      // 拖动结束，激活collectionView的scroll特性
      (UIViewController.currentViewController()?.view.viewWithTag(1001) as? UICollectionView)?.isScrollEnabled = true
      
      if gesture.velocity(in: self).y > 0 {
        tapOnceAction()
      } else {
        resetImageView()
      }
    default:
      resetImageView()
    }
  }
  
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // 在拖动过程中，计算图片的frame和scale
  private func computeTransformInfoInPanGesture(_ panGesture: UIPanGestureRecognizer) -> (frame: CGRect, scale: CGFloat) {
    guard let _ = imageView.image else {
      return (CGRect.zero, 1)
    }
    // 拖动偏移量
    let translation = panGesture.translation(in: scrollView)
    let currentTouchPoint = panGesture.location(in: scrollView)
    
    // 由下拉的偏移量决定缩放比例
    let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
    
    let width = beganFrame.size.width * scale
    let height = beganFrame.size.height * scale
    
    // 计算x和y，保持手指在图片上的相对位置不变
    let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
    let currentTouchDeltaX = xRate * width
    let xValue = currentTouchPoint.x - currentTouchDeltaX
    
    let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
    let currentTouchDeltaY = yRate * height
    let yValue = currentTouchPoint.y - currentTouchDeltaY
    
    return (CGRect(x: xValue.isNaN ? 0 : xValue, y: yValue.isNaN ? 0 : yValue, width: width, height: height), scale)
  }
  
  //
  private func alphaViewController(alphaValue: CGFloat) {
    let viewController = UIViewController.currentViewController()
    
    viewController?.view.backgroundColor = UIColor.black.withAlphaComponent(alphaValue)
    viewController?.view.viewWithTag(1001)?.backgroundColor = UIColor.black.withAlphaComponent(alphaValue)
  }
  
  private func resetImageView() {
    let fitSizeOfImageView = getFitSizeOfImageView()
    let needResetSize = imageView.bounds.size.width < fitSizeOfImageView.width || imageView.bounds.size.height < fitSizeOfImageView.height
    UIView.animate(withDuration: 0.25) {
      self.imageView.center = self.getResettingCenterOfImageView()
      if needResetSize {
        self.imageView.bounds.size = fitSizeOfImageView
      }
      
      self.alphaViewController(alphaValue: 1)
    }
  }
  
  
  // 计算图片在当前屏幕下的合适的大小
  private func getFitSizeOfImageView() -> CGSize {
    guard let image = imageView.image else {
      return CGSize.zero
    }
    let scaleValueOfWidth = scrollView.bounds.width / image.size.width
    let scaleValueOfHeight = scrollView.bounds.height / image.size.height
    let scaleValue = min(scaleValueOfHeight, scaleValueOfWidth)
    
    return CGSize(width: scaleValue * image.size.width, height: scaleValue * image.size.height)
  }
  
  
  // 计算图片复位的中心位置
  private func getResettingCenterOfImageView() -> CGPoint {
    guard let _ = imageView.image else {
      return CGPoint.zero
    }
    let deltaWidth  = bounds.width - scrollView.contentSize.width
    let offsetX     = deltaWidth > 0 ? deltaWidth * 0.5 : 2
    
    let deltaHeight = bounds.height - scrollView.contentSize.height
    let offsetY     = deltaHeight > 0 ? deltaHeight * 0.5 : 2
    
    return CGPoint(x: scrollView.contentSize.width / 2 + offsetX, y: scrollView.contentSize.height / 2 + offsetY)
  }
  
  // 计算图片合适的frame
  private func getFitFrameOfImageView() -> CGRect {
    guard let _ = imageView.image else {
      return CGRect.zero
    }
    let fitSizeOfImageView = getFitSizeOfImageView()
    
    let valueY = scrollView.bounds.height > fitSizeOfImageView.height ? (scrollView.bounds.height - fitSizeOfImageView.height) / 2 : 0
    let valueX = scrollView.bounds.width > fitSizeOfImageView.width ? (scrollView.bounds.width - fitSizeOfImageView.width) / 2 : 0
    
    return CGRect(x: valueX, y: valueY, width: fitSizeOfImageView.width, height: fitSizeOfImageView.height)
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////UIScrollViewDelegate/////
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    imageView.center = getResettingCenterOfImageView()
  }
  
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////UIGestureRecognizerDelegate/////
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
}
