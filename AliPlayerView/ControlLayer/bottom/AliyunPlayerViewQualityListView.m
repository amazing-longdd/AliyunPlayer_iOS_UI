//
//  PVDropDownModule.m
//

#import "AliyunPlayerViewQualityListView.h"
#import "AliyunUtil.h"

#define kALYPVPopQualityListBackGroundColor      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
static const CGFloat AliyunPlayerViewQualityListViewQualityButtonHeight = 32;

@interface AliyunPlayerViewQualityListView ()
@property (nonatomic, strong)NSMutableArray<UIButton *> *qualityBtnArray; //清晰度按钮数组
@end
@implementation AliyunPlayerViewQualityListView

#pragma mark - init
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _playMethod = ALYPVPlayMethodSTS;
        self.clipsToBounds = NO;
        self.backgroundColor = kALYPVPopQualityListBackGroundColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float btnHeight = AliyunPlayerViewQualityListViewQualityButtonHeight;
    for (int i = 0; i < _qualityBtnArray.count; i++) {
        UIButton *btn = _qualityBtnArray[i];
        btn.frame = CGRectMake(0, btnHeight * i, width, btnHeight);
    }
}

#pragma  mark - public method
/*
 * 功能 ：计算清晰度列表所需高度
 */
- (float)estimatedHeight{
    return [self.allSupportQualities count] * AliyunPlayerViewQualityListViewQualityButtonHeight;
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality {
    if (![self.allSupportQualities containsObject:[NSString stringWithFormat:@"%d", quality]]) {
        return;
    }
    for (UIButton *btn in self.qualityBtnArray) {
        if (btn.tag == quality) {
            [btn setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
        }
    }
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition{
    if (![self.allSupportQualities containsObject:videoDefinition]) {
        return;
    }
    for (UIButton *btn in self.qualityBtnArray) {
        if ([btn.titleLabel.text isEqualToString:videoDefinition]) {
            [btn setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
        }
    }
}

#pragma mark - private method
/*
 * 功能 ： 监测字符串中的int值
 */
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 重写setter方法
-(void)setAllSupportQualities:(NSArray *)allSupportQualities {
    if ([allSupportQualities count] == 0) {
        return;
    }
    _allSupportQualities = allSupportQualities;
    self.qualityBtnArray = [NSMutableArray array];
    
    //枚举类型
    NSArray *ary  = [AliyunUtil allQualities];
    for (int i = 0; i < allSupportQualities.count; i++) {
        int tempTag = -1;
        UIButton *btn = [[UIButton alloc] init];
        if (self.playMethod == ALYPVPlayMethodMPS) {
            tempTag = i+100000;
            [btn setTitle:allSupportQualities[i] forState:UIControlStateNormal];
        }else{
            tempTag = [allSupportQualities[i] intValue]+100000;
            NSString *title = ary[[allSupportQualities[i] intValue]];
            [btn setTitle:ary[[allSupportQualities[i] intValue]] forState:UIControlStateNormal];
        }
        UIButton *tempButton = (UIButton *)[self viewWithTag:tempTag];
        if (tempButton) {
            [tempButton removeFromSuperview];
            tempButton = nil;
        }
        [btn setTitleColor:kALYPVColorTextGray forState:UIControlStateNormal];
        [btn setTitleColor:kALYPVColorBlue forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:[AliyunUtil nomalTextSize]]];
        [btn setTag:tempTag];
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.qualityBtnArray addObject:btn];
    }
}

#pragma mark - button action
- (void)onClick:(UIButton *)btn {
    if (self.playMethod == ALYPVPlayMethodMPS) {
        NSString* videoDefinition = btn.titleLabel.text;
        if (self.delegate && [self.delegate respondsToSelector:@selector(qualityListViewOnDefinitionClick:)]) {
            for (UIButton *btn in self.qualityBtnArray) {
                if ([btn.titleLabel.text isEqualToString:videoDefinition]) {
                    [btn setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
                }else{
                    [btn setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
                }
            }
            [self.delegate qualityListViewOnDefinitionClick:videoDefinition];
        }
    }else{
        int tag = (int) btn.tag-100000;
        if (self.delegate && [self.delegate respondsToSelector:@selector(qualityListViewOnDefinitionClick:)]) {
            for (UIButton *btn in self.qualityBtnArray) {
                if (btn.tag == tag+100000) {
                    [btn setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
                }else{
                    [btn setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
                }
            }
            [self.delegate qualityListViewOnItemClick:tag];
        }
    }
    [self removeFromSuperview];
}

@end
