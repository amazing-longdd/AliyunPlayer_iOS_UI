//
//  AliyunPrivateDefine.h
//  AliyunVodPlayerViewSDK
//
//  Created by SMY on 16/9/9.
//  Copyright © 2016年 SMY. All rights reserved.
//  播放器模块的宏

#ifndef AliyunPrivateDefine_h
#define AliyunPrivateDefine_h

#import "AliyunUtil.h"

// 播控事件中的类型
#define kALYPVColorBlue                          [UIColor colorWithRed:(0 / 255.0) green:(193 / 255.0) blue:(222 / 255.0) alpha:1]
#define kALYPVPopErrorViewBackGroundColor        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define kALYPVPopSeekTextColor                   [UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:55 / 255.0 alpha:1]
#define kALYPVColorTextNomal                     [UIColor colorWithRed:(231 / 255.0) green:(231 / 255.0) blue:(231 / 255.0) alpha:1]
#define kALYPVColorTextGray                      [UIColor colorWithRed:(158 / 255.0) green:(158 / 255.0) blue:(158 / 255.0) alpha:1]

typedef NS_ENUM (int, ALYPVPlayMethod) {
    ALYPVPlayMethodUrl = 0,
    ALYPVPlayMethodMPS,
    ALYPVPlayMethodPlayAuth,
    ALYPVPlayMethodSTS,
    ALYPVPlayMethodLocal,
};

typedef NS_ENUM (int, ALYPVErrorType) {
    ALYPVErrorTypeUnknown = 0,
    ALYPVErrorTypeRetry,
    ALYPVErrorTypeReplay,
    ALYPVErrorTypePause,
};

typedef NS_ENUM(int, ALYPVOrientation) {
    ALYPVOrientationUnknow = 0,
    ALYPVOrientationHorizontal,
    ALYPVOrientationVertical
};

typedef NS_ENUM(int, ALYPVPlayerPopCode) {
    // 未知错误
    ALYPVPlayerPopCodeUnKnown = 0,
    
    // 当用户播放完成后提示用户可以重新播放。    再次观看，请点击重新播放
    ALYPVPlayerPopCodePlayFinish = 1,
    
    // 用户主动取消播放
    ALYPVPlayerPopCodeStop = 2,
    
    // 服务器返回错误情况
    ALYPVPlayerPopCodeServerError= 3,
    
    // 播放中的情况
    // 当网络超时进行提醒（文案统一可以定义），用户点击可以进行重播。      当前网络不佳，请稍后点击重新播放
    ALYPVPlayerPopCodeNetworkTimeOutError = 4,
    
    // 断网时进行断网提醒，点击可以重播（按记录已经请求成功的url进行请求播放） 无网络连接，检查网络后点击重新播放
    ALYPVPlayerPopCodeUnreachableNetwork = 5,
    
    // 当视频加载出错时进行提醒，点击可重新加载。   视频加载出错，请点击重新播放
    ALYPVPlayerPopCodeLoadDataError = 6,
     
    // 当用户使用移动网络播放时，首次不进行自动播放，给予提醒当前的网络状态，用户可手动使用移动网络进行播放。顶部提示条仅显示4秒自动消失。当用户从wifi切到移动网络时，暂定当前播放给予用户提示当前的网络，用户可以点击播放后继续当前播放。
    ALYPVPlayerPopCodeUseMobileNetwork,
};

#endif /* AliyunPrivateDefine_h */
