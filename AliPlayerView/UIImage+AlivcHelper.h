//
//  UIImage+AlivcHelper.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/9.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AlivcHelper)

/**
 *  Create and return a 1x1 point size image with the given color.
 *
 *  @param color The color
 */

+ (UIImage *)avc_imageWithColor:(UIColor *)color;

/**
 *  Create and retuurn a pure color image with the given color and size
 *
 *  @param color The color
 *  @param size  image size
 */
+ (UIImage *)avc_imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)avc_drawCircleImage;
@end
