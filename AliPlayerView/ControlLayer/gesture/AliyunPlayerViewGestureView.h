
#import <UIKit/UIKit.h>
#import "AliyunPrivateDefine.h"

@class AliyunPlayerViewGestureView;
@protocol AliyunPVGestureViewDelegate <NSObject>

//单击屏幕
- (void)onSingleClickedWithAliyunPVGestureView:(AliyunPlayerViewGestureView *)gestureView;

//双击屏幕
- (void)onDoubleClickedWithAliyunPVGestureView:(AliyunPlayerViewGestureView *)gestureView;

//手势水平移动偏移量
- (void)horizontalOrientationMoveOffset:(float)moveOffset;

@end

@interface AliyunPlayerViewGestureView : UIView
@property (nonatomic, weak) id<AliyunPVGestureViewDelegate>delegate;

/*
 * 功能 ： 是否禁用手势（双击、滑动）
 */
- (void)setEnableGesture:(BOOL)enableGesture;

/*
 * 功能 ： 传递
 */
- (void)setSeekTime:(NSTimeInterval)time direction:(UISwipeGestureRecognizerDirection)direction;

@end
