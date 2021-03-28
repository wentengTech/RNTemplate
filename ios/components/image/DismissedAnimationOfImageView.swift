//
//  DismissedAnimationOfImageView.swift
//  automoniaProject
//
//  Created by jackie on 2019/3/24.
//  Copyright © 2019 温腾. All rights reserved.
//

// ImageViewController 的dismissed动画对象
import Foundation
import UIKit

class DismissedAnimationOfImageView: NSObject, UIViewControllerAnimatedTransitioning {
  
  // 动画时长
  let duration: TimeInterval = 0.4
  
  // 图片
  var sourceImageView     : UIImageView? = nil
  
  // dismiss过程中消退的图片
  var dismissedImageView  : UIImageView! = nil
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)
    let fromView = transitionContext.view(forKey: .from)!
    
    // 源图片信息为空，无法执行相关动画。
    guard sourceImageView != nil, sourceImageView?.superview != nil, sourceImageView?.image != nil else {
      if toView != nil { containerView.addSubview(toView!) }
      transitionContext.completeTransition(true)
      return
    }
    
    // 获取图片视图控制器的collectionView
    //        let collectionView = fromView.viewWithTag(1001)!
    
    // 在dismissed模式下,需先将toView添加回来，否则会影响sourceImageFrame数值
    if toView != nil { containerView.addSubview(toView!) }
    containerView.bringSubviewToFront(fromView)
    
    // 确定源图片在视图中的方位信息
    let sourceImageFrame = sourceImageView!.superview!.convert(sourceImageView!.frame, to: nil)
    
    // 动画设置
    UIView.animate(withDuration: 0.1) {
      fromView.backgroundColor = mainGroupBackgroundColor.withAlphaComponent(0)
      fromView.viewWithTag(1001)!.backgroundColor = mainGroupBackgroundColor.withAlphaComponent(0)
    }
    
    UIView.animate(withDuration: duration, animations: {
      self.dismissedImageView.center = CGPoint(x: sourceImageFrame.midX, y: sourceImageFrame.midY)
      self.dismissedImageView.bounds.size = sourceImageFrame.size
    }, completion: { _ in
      transitionContext.completeTransition(true)
    })
  }
  
}
