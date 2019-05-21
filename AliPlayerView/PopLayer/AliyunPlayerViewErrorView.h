//
//  ALPVErrorMessageView.h
//

#import <UIKit/UIKit.h>
#import "AliyunVodPlayerViewDefine.h"
#import "AliyunPrivateDefine.h"

@protocol AliyunPVErrorViewDelegate <NSObject>

/*
 * 功能 ：错误状态提示
 * 参数 ： type 错误类型
 */
- (void)onErrorViewClickedWithType:(ALYPVErrorType)type;

@end

@interface AliyunPlayerViewErrorView : UIView

@property (nonatomic, weak  ) id<AliyunPVErrorViewDelegate> delegate;
@property (nonatomic, assign) AliyunVodPlayerViewSkin skin;             //皮肤
@property (nonatomic, copy  ) NSString *message;                        //错误信息内容
@property (nonatomic, assign)ALYPVErrorType type;         //错误类型

/*
 * 功能 ：展示错误页面偏移量
 * 参数 ：parent 插入的界面
 */
- (void)showWithParentView:(UIView *)parent;

/*
 * 功能 ：是否展示界面
 */
- (BOOL)isShowing;

/*
 * 功能 ：是否删除界面
 */
- (void)dismiss;

@end
