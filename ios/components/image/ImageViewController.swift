//
//  ImageViewController.swift
//  automoniaProject
//
//  Created by jackie on 2019/3/23.
//  Copyright © 2019 温腾. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController: UIViewController, UIViewControllerTransitioningDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  // 在dismissed过程中的切换图片
  static var dismissedImageView: UIImageView! = nil
  
  // 创建图片查看的工厂函数
  // index            显示图片的序号
  // imageFilePaths   显示图片路径的数据源
  class func factory(index: Int, imageViews: [UIImageView]) {
    // 数据源为空，无需做任何显示
    if imageViews.isEmpty {
      return
    }
    // 确保视图控制器不为空
    guard let viewController = UIViewController.currentViewController() else {
      return
    }
    let imageViewController = ImageViewController()
    imageViewController.transitioningDelegate = imageViewController
    imageViewController.selectedIndex = index
    imageViewController.imageViews = imageViews
    
    // 展示图片视图控制器
    imageViewController.modalPresentationStyle = .overFullScreen
    viewController.present(imageViewController, animated: true, completion: nil)
  }
  
  
  //-//////////////////////////////////////////////////////////////////////////////
  //-//////////////////////////////////////////////////////////////////////////////
  /* UIViewControllerTransitioningDelegate */
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animatedTransitioning = DismissedAnimationOfImageView()
    animatedTransitioning.sourceImageView = self.imageViews[self.selectedIndex]
    animatedTransitioning.dismissedImageView = ImageViewController.dismissedImageView
    return animatedTransitioning
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let animatedTransitioning = PresentedAnimationOfImageView()
    animatedTransitioning.sourceImageView = self.imageViews[self.selectedIndex]
    return animatedTransitioning
  }
  
  
  //-//////////////////////////////////////////////////////////////////////////////
  //-//////////////////////////////////////////////////////////////////////////////
  
  // 图片的原始图片的展示集合视图。必要时候展示加载中控件
  private var collectionView      : UICollectionView! = nil
  private var imageViews          = [UIImageView]()
  private var selectedIndex       = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black
    
    // 设置原始图片的展示集合视图
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 0
    collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
    collectionView.backgroundColor = UIColor.black
    self.view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.tag = 1001
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    
    collectionView.register(ImageViewCollectionViewCell.self, forCellWithReuseIdentifier: "ImageViewCollectionViewCell")
    
    // 滑动到特定的row
    collectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .left, animated: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    CommonUtils.shared.gradientTransparent(viewController: self)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    CommonUtils.shared.gradientNontransparent(viewController: self, title: nil)
  }
  
  //-//////////////////////////////////////////////////////////////////////////////////
  //-//////////////////////////////////////////////////////////////////////////////////
  /* UICollectionViewDataSource, UICollectionViewDelegateFlowLayout */
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageViews.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCollectionViewCell", for: indexPath) as! ImageViewCollectionViewCell
    cell.imageViewController = self
    return cell.presentView(image: imageViews[indexPath.row].image)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollX = scrollView.contentOffset.x + self.view.bounds.width / 2
    selectedIndex = Int(scrollX / self.view.bounds.width)
  }
}
