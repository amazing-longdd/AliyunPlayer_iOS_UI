//
//  AliyunViewMoreView.h
//  AliyunVideoClient_Entrance
//
//  Created by 王凯 on 2018/6/28.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AliyunViewMoreView;
@protocol AliyunViewMoreViewDelegate <NSObject>

- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView clickedDownloadBtn:(UIButton *)downloadBtn;

- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView clickedAirPlayBtn:(UIButton *)airPlayBtn;

- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView clickedBarrageBtn:(UIButton *)barrageBtn;

- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView speedChanged:(float)speedValue;

@end
@interface AliyunViewMoreView : UIView
@property (nonatomic, weak) id<AliyunViewMoreViewDelegate>delegate;

- (void)showSpeedViewMoveInAnimate;

@end
