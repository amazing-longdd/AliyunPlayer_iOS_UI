//
//  AliyunPVGifView.h
//

#import <UIKit/UIKit.h>

@interface AliyunPlayerViewGifView : UIView
/*
 * 功能 ：设定gif动画图片
 */
- (void)setGifImageWithName:(NSString *)name;

/*
 * 功能 ：开始动画
 */
- (void)startAnimation;

/*
 * 功能 ：停止动画
 */
- (void)stopAnimation;
@end
