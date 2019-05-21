//
//  AliyunPVPopLayer.h
//

#import <UIKit/UIKit.h>
#import "AlilyunViewLoadingView.h"
#import "AliyunPlayerViewErrorView.h"
#import "AliyunUtil.h"

@class AliyunPlayerViewPopLayer;
@protocol AliyunPVPopLayerDelegate <NSObject>

/*
 * 功能 ：点击返回时操作
 * 参数 ：popLayer 对象本身
 */
- (void)onBackClickedWithAlPVPopLayer:(AliyunPlayerViewPopLayer *)popLayer ;

/*
 * 功能 ：提示错误信息时，当前按钮状态
 * 参数 ：type 错误类型
 */
- (void)showPopViewWithType:(ALYPVErrorType)type;

@end

@interface AliyunPlayerViewPopLayer : UIView

@property (nonatomic, weak) id<AliyunPVPopLayerDelegate>delegate;

/*
 * 功能 ：根据不同code，展示弹起的消息界面
 * 参数 ： code ： 事件
          popMsg ：自定义消息
 */
- (void)showPopViewWithCode:(ALYPVPlayerPopCode)code popMsg:(NSString *)popMsg;
@end
