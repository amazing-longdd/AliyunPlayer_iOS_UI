//
//  UIColor+AlivcHelper.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/8.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 Create UIColor with a hex string.
 Example: UIColorHex(0xF0F), UIColorHex(66ccff), UIColorHex(#66CCFF88)
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor dl_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

@interface UIColor (AlivcHelper)

/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An UIColor object from string, or nil if an error occurs.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @param alpha the alpha of the color
 
 @return        An UIColor object from string, or nil if an error occurs.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;


@end


NS_ASSUME_NONNULL_END
