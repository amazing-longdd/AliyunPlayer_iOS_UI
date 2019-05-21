//
//  AlyunVodBottomView.h
//


#import <UIKit/UIKit.h>
#import "AliyunPlayerViewProgressView.h"
#import "AliyunPlayerViewQualityListView.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayerVideo.h>

static const CGFloat ALYPVBottomViewMargin                  = 8;                            //间隙
static const CGFloat ALYPVBottomViewFullScreenButtonWidth   = 48;                           //全屏按钮宽度
static const CGFloat ALYPVBottomViewQualityButtonWidth      = 48 + ALYPVBottomViewMargin*2; // 清晰度按钮宽度

@class AliyunPlayerViewBottomView;
@protocol AliyunVodBottomViewDelegate <NSObject>

/*
 * 功能 ：进度条滑动 偏移量
 * 参数 ：bottomView 对象本身
         progressValue 偏移量
         event 手势事件，点击-移动-离开
 */
- (void)aliyunVodBottomView:(AliyunPlayerViewBottomView *)bottomView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event;

/*
 * 功能 ：点击播放，返回代理
 * 参数 ：bottomView 对象本身
 */
- (void)onClickedPlayButtonWithAliyunPVBottomView:(AliyunPlayerViewBottomView *)bottomView;


/*
 * 功能 ：点击全屏按钮
 * 参数 ：bottomView 对象本身
 */
- (void)onClickedfullScreenButtonWithAliyunPVBottomView:(AliyunPlayerViewBottomView *)bottomView;

/*
 * 功能 ：点击清晰度按钮
 * 参数 ：bottomView 对象本身
         qulityButton 清晰度按钮
 */
- (void)aliyunPVBottomView:(AliyunPlayerViewBottomView *)bottomView qulityButton:(UIButton *)qulityButton;


@end

@interface AliyunPlayerViewBottomView : UIView

@property (nonatomic, weak  ) id<AliyunVodBottomViewDelegate>delegate;
@property (nonatomic, assign) AliyunVodPlayerViewSkin skin;         //界面皮肤
@property (nonatomic, strong) AliyunVodPlayerVideo *videoInfo;      //播放器媒体数据
@property (nonatomic, strong) UIButton *qualityButton;              //清晰度按钮
@property (nonatomic, assign) float progress;                       //滑动progressValue值
@property (nonatomic, assign) float loadTimeProgress;               //缓存progressValue
@property (nonatomic, assign) BOOL isPortrait;                      //竖屏判断





/*
 * 功能 ：播放器按钮action
 */
- (void)playButtonClicked:(UIButton *)sender;

/*
 * 功能 ：更新进度条与时间
 * 参数 ：currentTime 当前播放时间
         durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime;

/*
 * 功能 ：更新当前显示时间
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateCurrentTime:(float)currentTime durationTime:(float)durationTime;

/*
 * 功能 ：根据播放器状态，改变状态
 * 参数 ：state 播放器状态
 */
- (void)updateViewWithPlayerState:(AliyunVodPlayerState)state;

/*
 * 功能 ：锁屏状态
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：取消锁屏
 * 参数 ：isScreenLocked 是否是锁屏状态
         fixedPortrait 是否是绝对竖屏状态
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;


@end
