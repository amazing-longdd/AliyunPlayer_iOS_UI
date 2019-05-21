//
//  MBProgressHUD+AlivcHelper.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/12.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "MBProgressHUD+AlivcHelper.h"

static CGFloat secondPerText = 0.16;

@implementation MBProgressHUD (AlivcHelper)

+ (UIImage *)warningImage{
    return [UIImage imageNamed:@"avcPromptWarning"];
}

+ (UIImage *)sucessImage{
    return [UIImage imageNamed:@"avcPromptSuccess"];
}

+ (void)showMessage:(NSString *)message image:(UIImage *)image inView:(UIView *)view{
    
    MBProgressHUD  *hud =[MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:image];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 5;
    hud.label.text = message;
    [hud hideAnimated:true afterDelay:[MBProgressHUD showTimeWithMessage:message]];
}

+ (CGFloat )showTimeWithMessage:(NSString *)message{
    if (message) {
        CGFloat time = message.length * secondPerText;
        if (time > 5) {
            time = 5;
        }
        return time;
    }
    return 0;
}

+ (void)showSucessMessage:(NSString *)message inView:(UIView *)view{
    [self showMessage:message image:[self sucessImage] inView:view];
}

+ (void)showWarningMessage:(NSString *)message inView:(UIView *)view{
    [self showMessage:message image:[self warningImage] inView:view];
}

+ (void)showMessage:(NSString *)message inView:(UIView *)view{
    MBProgressHUD  *hud =[MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 10;
    hud.label.text = message;
    [hud hideAnimated:true afterDelay:[MBProgressHUD showTimeWithMessage:message]];
}

+ (MBProgressHUD *)showMessage:(NSString *)message alwaysInView:(UIView *)view{
    MBProgressHUD  *hud =[MBProgressHUD showHUDAddedTo:view animated:true];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    hud.contentColor = [UIColor whiteColor];
    hud.label.numberOfLines = 10;
    hud.label.text = message;
    return hud;
}



@end
