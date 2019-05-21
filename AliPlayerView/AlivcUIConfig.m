//
//  AlivcUIConfig.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/4/8.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "AlivcUIConfig.h"
#import "UIColor+AlivcHelper.h"

static AlivcUIConfig *sharedIns = nil;

@implementation AlivcUIConfig

+ (instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedIns) {
            sharedIns = [[AlivcUIConfig alloc]_init];
        }
    });
    return sharedIns;
}

- (instancetype)init{
//    @throw [NSException exceptionWithName:@"AlivcUIConfig init error" reason:@"'shared' to get instance." userInfo:nil];
    return [super init];
}

- (instancetype)_init {
    self = [super init];
    if (self) {
        _kAVCBackgroundColor = [UIColor colorWithHexString:@"1e222d"];
        _kAVCThemeColor = [UIColor colorWithHexString:@"00c1de"];
    }
    return self;
}

@end
