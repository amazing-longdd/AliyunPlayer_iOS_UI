//
//  AlivcUIConfig.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/8.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlivcUIConfig : NSObject

+ (instancetype)shared;

/**
 背景颜色
 */
@property (strong, nonatomic, readonly) UIColor *kAVCBackgroundColor;

/**
 系统色
 */
@property (strong, nonatomic, readonly) UIColor *kAVCThemeColor;






@end
