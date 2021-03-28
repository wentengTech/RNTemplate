//
//  PresentedAnimationOfImageView.swift
//  automoniaProject
//
//  Created by jackie on 2019/3/24.
//  Copyright © 2019 温腾. All rights reserved.
//

// ImageViewController 的presented动画对象
import Foundation
import UIKit

class PresentedAnimationOfImageView: NSObject, UIViewControllerAnimatedTransitioning {
  
  // 动画时长
  let duration            : TimeInterval = 0.2
  // 图片
  var sourceImageView     : UIImageView? = nil
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    
    // 源图片信息为空，无法执行相关动画。
    guard sourceImageView != nil, sourceImageView?.superview != nil, sourceImageView?.image != nil else {
      containerView.addSubview(toView)
      transitionContext.completeTransition(true)
      return
    }
    
    // 确定源图片的缩放数值
    let sourceImageFrame = sourceImageView!.superview!.convert(sourceImageView!.frame, to: nil)
    
    // 获取图片视图控制器的collectionView
    let collectionView = toView.viewWithTag(1001)!
    
    // 将collectionView调整为点击的图片的大小和方位.
    let scaleX = sourceImageFrame.width / sourceImageView!.image!.size.width
    let scaleY = sourceImageFrame.height / sourceImageView!.image!.size.height
    collectionView.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
    collectionView.center = CGPoint(x: sourceImageFrame.midX, y: sourceImageFrame.midY)
    
    // 动画设置
    // toView在presented模式下，不要sourceImageFrame计算前add，以免影响其结果计算
    containerView.addSubview(toView)
    UIView.animate(withDuration: duration, animations: {
      collectionView.transform = .identity
      collectionView.center = CGPoint(x: toView.bounds.midX, y: toView.bounds.midY)
    }, completion: { _ in
      transitionContext.completeTransition(true)
    })
    
  }
  
  
  
  
}
