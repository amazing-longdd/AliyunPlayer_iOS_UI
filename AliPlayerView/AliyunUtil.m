//
//  AliyunPVUtil.m
//  AliyunVodPlayerViewSDK
//
//  Created by SMY on 16/9/8.
//  Copyright © 2016年 SMY. All rights reserved.
//

#import "AliyunUtil.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

static NSString * const AliyunUtilImageBundleName = @"AliyunImageSource.bundle";
static NSString * const AliyunUtilImageBundle     = @"AliyunImageSource";
static NSString * const AliyunUtilLanguageBundle  = @"AliyunLanguageSource";
static const CGFloat AliyunUtilTitleNomalTextSize = 28;
static NSString * const ALYPVVersion  = @"3.4.9";

@implementation AliyunUtil

+ (NSString*)getSDKVersion{
    return ALYPVVersion;
}

+ (NSBundle *)resourceBundle {
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:AliyunUtilImageBundle ofType:@"bundle"]];
    if (!resourceBundle) {
        resourceBundle = [NSBundle mainBundle];
    }
    return resourceBundle;
}

+ (NSBundle *)languageBundle {
    NSBundle *resourceBundle = [NSBundle mainBundle];
    return resourceBundle;
}

+ (UIImage *)imageWithNameInBundle:(NSString *)nameInBundle {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", AliyunUtilImageBundleName, nameInBundle]];
}

+ (UIImage *)imageWithNameInBundle:(NSString *)name skin:(AliyunVodPlayerViewSkin)skin{
    UIImage *img = [[self class] imageWithNameInBundle:name];
    if (!img) {
        NSString *suffix = @"blue";
        
        switch (skin) {
            case AliyunVodPlayerViewSkinBlue:
                suffix = @"blue";
                break;
            case AliyunVodPlayerViewSkinRed:
                suffix = @"red";
                break;
            case AliyunVodPlayerViewSkinOrange:
                suffix = @"orange";
                break;
            case AliyunVodPlayerViewSkinGreen:
                suffix = @"green";
                break;
            default:
                break;
        }
        img = [[self class]  imageWithNameInBundle:[NSString stringWithFormat:@"%@_%@", name, suffix]];
    }
    return img;
    
}

+ (BOOL)isInterfaceOrientationPortrait {
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    return o == UIInterfaceOrientationPortrait;
}

+ (void)setFullOrHalfScreen {
    BOOL isFull = [self isInterfaceOrientationPortrait];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = isFull ? UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
}

+ (NSString *)timeformatFromSeconds:(NSInteger)seconds {
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", (long) seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long) (seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", (long) seconds % 60];
    //format of time
    NSString *format_time = nil;
    if (seconds / 3600 <= 0) {
        format_time = [NSString stringWithFormat:@"00:%@:%@", str_minute, str_second];
    } else {
        format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    }
    return format_time;
}

+ (void)drawFillRoundRect:(CGRect)rect radius:(CGFloat)radius color:(UIColor *)color context:(CGContextRef)context {
    CGContextSetAllowsAntialiasing(context, TRUE);
    CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
    //    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius);
    CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

+ (UIColor *)textColor:(AliyunVodPlayerViewSkin)skin{
    UIColor *color = nil;
    switch (skin) {
        case AliyunVodPlayerViewSkinBlue:
            color = UIColorFromRGB(0x379DF2);
            break;
        case AliyunVodPlayerViewSkinRed:
            color = UIColorFromRGB(0xE94033);
            break;
        case AliyunVodPlayerViewSkinOrange:
            color = UIColorFromRGB(0xEE7C33);
            break;
        case AliyunVodPlayerViewSkinGreen:
            color = UIColorFromRGB(0x57AB44);
            break;
            
        default:
            break;
    }
    return color;
}

+ (float)convertPixelToPoint:(float)pixel {
    if (pixel < 0) {
        return 0;
    }
    return pixel / 2;
}

+ (float)nomalTextSize {
    return AliyunUtilTitleNomalTextSize / 2.0;
}

//"fd_definition" = "流畅";
//"ld_definition" = "标清";
//"sd_definition" = "高清";
//"hd_definition" = "超清";
//"2k_definition" = "2K";
//"4k_definition" = "4K";
//"od_definition" = "OD";
//获取所有已知清晰度泪飙
+ (NSArray<NSString *> *)allQualities {
    NSBundle *resourceBundle = [[self class] languageBundle];
    return @[NSLocalizedStringFromTableInBundle(@"VOD_FD", nil, resourceBundle, nil),
             NSLocalizedStringFromTableInBundle(@"VOD_LD", nil, resourceBundle, nil),
             NSLocalizedStringFromTableInBundle(@"VOD_SD", nil, resourceBundle, nil),
             NSLocalizedStringFromTableInBundle(@"VOD_HD", nil, resourceBundle, nil),
             NSLocalizedStringFromTableInBundle(@"VOD_2K", nil, resourceBundle, nil),
             NSLocalizedStringFromTableInBundle(@"VOD_4K", nil, resourceBundle, nil),
             NSLocalizedStringFromTableInBundle(@"VOD_OD", nil, resourceBundle, nil),
             ];
}

+ (void)setPlayFinishTips:(NSString *)des{
    ALIYUNVODVIEW_PLAYFINISH = des;
}

+ (NSString *)playFinishTips{
    return ALIYUNVODVIEW_PLAYFINISH;
}

+ (void)setNetworkTimeoutTips:(NSString *)des{
    ALIYUNVODVIEW_NETWORKTIMEOUT = des;
}

+ (NSString *)networkTimeoutTips{
    return ALIYUNVODVIEW_NETWORKTIMEOUT;
}

+ (void)setNetworkUnreachableTips:(NSString *)des{
    ALIYUNVODVIEW_NETWORKUNREACHABLE = des;
}

+ (NSString *)networkUnreachableTips{
    return ALIYUNVODVIEW_NETWORKUNREACHABLE;
}

+ (void)setLoadingDataErrorTips:(NSString *)des{
    ALIYUNVODVIEW_LOADINGDATAERROR = des;
}

+ (NSString*)loadingDataErrorTips{
    return ALIYUNVODVIEW_LOADINGDATAERROR;
}

+ (void)setSwitchToMobileNetworkTips:(NSString *)des{
    ALIYUNVODVIEW_USEMOBILENETWORK = des;
}
+ (NSString *)switchToMobileNetworkTips{
    return ALIYUNVODVIEW_USEMOBILENETWORK;
}
@end
