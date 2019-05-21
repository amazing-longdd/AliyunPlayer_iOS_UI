//
//  AliyunControlView.h
//

#import <UIKit/UIKit.h>
#import "AliyunPlayerViewTopView.h"
#import "AliyunPlayerViewBottomView.h"
#import "AliyunPlayerViewGestureView.h"
#import "AliyunPrivateDefine.h"

@class AliyunPlayerViewControlView;
@protocol AliyunControlViewDelegate <NSObject>

/*
 * 功能 ： 点击下载按钮
 * 参数 ： controlView 对象本身
 */
- (void)onDownloadButtonClickWithAliyunControlView:(AliyunPlayerViewControlView *)controlView;

/*
 * 功能 ： 点击返回按钮
 * 参数 ： controlView 对象本身
 */
- (void)onBackViewClickWithAliyunControlView:(AliyunPlayerViewControlView*)controlView;

/*
 * 功能 ： 展示倍速播放界面
 * 参数 ： controlView 对象本身
 */
- (void)onSpeedViewClickedWithAliyunControlView:(AliyunPlayerViewControlView*)controlView;

/*
 * 功能 ： 播放按钮
 * 参数 ： controlView 对象本身
 */
- (void)onClickedPlayButtonWithAliyunControlView:(AliyunPlayerViewControlView*)controlView;

/*
 * 功能 ： 全屏
 * 参数 ： controlView 对象本身
 */
- (void)onClickedfullScreenButtonWithAliyunControlView:(AliyunPlayerViewControlView*)controlView;

/*
 * 功能 ： 锁屏
 * 参数 ： controlView 对象本身
 */
- (void)onLockButtonClickedWithAliyunControlView:(AliyunPlayerViewControlView*)controlView;
/*
 * 功能 ： 拖动进度条
 * 参数 ： controlView 对象本身
          progressValue slide滑动长度
          event 手势事件，点击-移动-离开
 */
- (void)aliyunControlView:(AliyunPlayerViewControlView*)controlView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event;

/*
 * 功能 ： 清晰度切换
 * 参数 ： index 选择的清晰度
 */
- (void)aliyunControlView:(AliyunPlayerViewControlView*)controlView qualityListViewOnItemClick:(int)index;


@end

@interface AliyunPlayerViewControlView : UIView
@property (nonatomic, weak  ) id<AliyunControlViewDelegate>delegate;
@property (nonatomic, strong) AliyunVodPlayerVideo *videoInfo;      //播放数据
@property (nonatomic, assign) AliyunVodPlayerState state;           //播放器播放状态
@property (nonatomic, assign) AliyunVodPlayerViewSkin skin;         //界面皮肤
@property (nonatomic, copy) NSString *title;                        //设置标题
@property (nonatomic, assign) float loadTimeProgress;               //缓存进度
@property (nonatomic, assign) BOOL isProtrait;                      //竖屏判断
@property (nonatomic, strong) UIButton *lockButton;                 //锁屏按钮
@property (nonatomic, strong) AliyunPlayerViewQualityListView *listView;    //清晰度列表view

@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic ,assign) ALYPVPlayMethod playMethod; //播放方式

/*
 * 功能 ：更新播放器状态
 */
- (void)updateViewWithPlayerState:(AliyunVodPlayerState)state isScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：更新进度条
 */
- (void)updateProgressWithCurrentTime:(NSTimeInterval)currentTime durationTime : (NSTimeInterval)durationTime;

/*
 * 功能 ：更新当前时间
 */
- (void)updateCurrentTime:(NSTimeInterval)currentTime durationTime : (NSTimeInterval)durationTime;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition;

/*
 * 功能 ：是否禁用手势（双击、滑动)
 */
- (void)setEnableGesture:(BOOL)enableGesture;

/*
 * 功能 ：隐藏topView、bottomView
 */
- (void)hiddenView;

/*
 * 功能 ：展示topView、bottomView
 */
- (void)showView;

/*
 * 功能 ：锁屏
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;

/*
 * 功能 ：取消锁屏
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait;


- (void)setQualityButtonTitle:(NSString *)title;

@end
