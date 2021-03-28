//
//  YDImageViewManager.m
//
//  Created by jackie on 2020/8/20.
//

#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"


@interface RCT_EXTERN_MODULE(YDImageViewManager, RCTViewManager)


// 指明显示的图片名称，images.xcassets目录中
RCT_EXPORT_VIEW_PROPERTY(fileName, NSString)

// 用于显示网络图片
RCT_EXPORT_VIEW_PROPERTY(filePath, NSString)
RCT_EXPORT_VIEW_PROPERTY(defaultImageName, NSString)

// 图片的圆角
RCT_EXPORT_VIEW_PROPERTY(cornerRadius, NSNumber)

// 图片的点击预览属性
RCT_EXPORT_VIEW_PROPERTY(previewable, NSNumber)



// 更新网络图片，兼容性处理
RCT_EXTERN_METHOD(onUpdate:(nonnull NSNumber *)node content:(nonnull NSString *)content)

@end

