//
//  AlyunVodTopView.h
//

#import <UIKit/UIKit.h>
#import "AliyunPrivateDefine.h"

@class AliyunPlayerViewTopView;
@protocol AliyunPVTopViewDelegate <NSObject>

/*
 * 功能 ： 点击返回按钮
 * 参数 ： topView 对象本身
 */
- (void)onBackViewClickWithAliyunPVTopView:(AliyunPlayerViewTopView*)topView;

/*
 * 功能 ： 点击下载按钮
 * 参数 ： topView 对象本身
 */
- (void)onDownloadButtonClickWithAliyunPVTopView:(AliyunPlayerViewTopView*)topView;

/*
 * 功能 ： 点击展示倍速播放界面按钮
 * 参数 ： 对象本身
 */
- (void)onSpeedViewClickedWithAliyunPVTopView:(AliyunPlayerViewTopView*)topView;

@end

@interface AliyunPlayerViewTopView : UIView
@property (nonatomic, weak  ) id<AliyunPVTopViewDelegate>delegate;
@property (nonatomic, assign) AliyunVodPlayerViewSkin skin;         //皮肤
@property (nonatomic, copy  ) NSString *topTitle;                   //标题

@property (nonatomic ,assign) ALYPVPlayMethod playMethod; //播放方式

@end
