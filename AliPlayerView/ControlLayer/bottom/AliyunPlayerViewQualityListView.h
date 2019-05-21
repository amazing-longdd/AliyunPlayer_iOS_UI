//
//  PVDropDownModule.h
//

#import <UIKit/UIKit.h>
#import "AliyunPrivateDefine.h"

@protocol AliyunPVQualityListViewDelegate <NSObject>
/*
 * 功能 ：清晰度列表选择
 */
- (void)qualityListViewOnItemClick:(int)index;

/*
 * 功能 ：清晰度列表选择，MTS播放方式
 */
- (void)qualityListViewOnDefinitionClick:(NSString*)videoDefinition;

@end

@interface AliyunPlayerViewQualityListView : UIView
@property (nonatomic, weak  ) id<AliyunPVQualityListViewDelegate> delegate;
@property (nonatomic, copy  ) NSArray *allSupportQualities;             //清晰度列表信息
@property (nonatomic, assign) ALYPVPlayMethod playMethod; //根据播放方式，确定清晰度 名称

/*
 * 功能 ：计算清晰度列表所需高度
 */
- (float)estimatedHeight;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality;

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition;
@end
