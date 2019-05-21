//
//  AlyunVodProgressView.h
//

#import <UIKit/UIKit.h>
#import "AliyunPlayerViewSlider.h"
#import "AliyunPrivateDefine.h"
#import "AliyunVodPlayerViewDefine.h"

@class AliyunPlayerViewProgressView;
@protocol AliyunVodProgressViewDelegate <NSObject>

/*
 * 功能 ： 移动距离
   参数 ： dragProgressSliderValue slide滑动长度
          event 手势事件，点击-移动-离开
 */
- (void)aliyunVodProgressView:(AliyunPlayerViewProgressView *)progressView dragProgressSliderValue:(float)value event:(UIControlEvents)event;
@end

@interface AliyunPlayerViewProgressView : UIView
@property (nonatomic, weak  ) id<AliyunVodProgressViewDelegate>delegate;
@property (nonatomic, assign) AliyunVodPlayerViewSkin skin;    //皮肤
@property (nonatomic, assign) float progress;                  //设置sliderValue
@property (nonatomic, assign) float loadTimeProgress;          //设置缓冲progress

/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime : (float)durationTime;

@end
