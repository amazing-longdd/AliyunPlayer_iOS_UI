//
//  AliyunPVPlaySpeedView.h
//

#import <UIKit/UIKit.h>
#import "AliyunUtil.h"
#import "AliyunPrivateDefine.h"

@class AliyunPlayerViewSpeedView;
@protocol AliyunPVPlaySpeedViewDelegate <NSObject>

/*
 * 功能 ：倍速播放，选择的倍速值
 */
- (void)aliyunPVPlaySpeedView:(AliyunPlayerViewSpeedView*)playSpeedView playSpeed:(float)playSpeed;

@end

@interface AliyunPlayerViewSpeedView : UIView
@property (nonatomic, weak  ) id<AliyunPVPlaySpeedViewDelegate> delegate;
@property (nonatomic, assign) AliyunVodPlayerViewSkin skin;         //功能 ：皮肤

/*
 * 功能 ： 倍速播放界面 入场动画
 */
- (void)showSpeedViewMoveInAnimate;

@end
