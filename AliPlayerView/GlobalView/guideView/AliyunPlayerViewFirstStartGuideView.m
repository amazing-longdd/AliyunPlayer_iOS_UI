//
//  AliyunStartPagesView.m
//  AliyunVodPlayerViewSDK
//
//  Created by 王凯 on 2017/10/12.
//  Copyright © 2017年 SMY. All rights reserved.
//

#import "AliyunPlayerViewFirstStartGuideView.h"
#import "AliyunUtil.h"

static const CGFloat ALYFirstStartGuideViewCenterIVWidth    = 56;      //centerImageView 宽度
static const CGFloat ALYFirstStartGuideViewCenterIVHeight   = 72;      //centerImageView 高度
static const CGFloat ALYFirstStartGuideViewLabelWidth       = 150;     //label 宽度
static const CGFloat ALYFirstStartGuideViewLabelHeight      = 50;      //label 高度
static const CGFloat ALYFirstStartGuideViewMargin           = 10;      //centerImageView 高度
static const CGFloat ALYFirstStartGuideViewTextFont         = 17.0f;   //字体型号
static const CGFloat ALYFirstStartGuideViewImageViewMargin  = 100;     //图片之间间隙
static const CGFloat ALYFirstStartGuideViewLeftIVWidth      = 82;      //leftImageView 宽度
static const CGFloat ALYFirstStartGuideViewLeftIVHeight     = 58;      //leftImageView 高度

@interface AliyunPlayerViewFirstStartGuideView()

@property (nonatomic, strong) UIControl *control;           //整体view，增加control手势
@property (nonatomic, strong) UIImageView *centerImageView; //中间图片
@property (nonatomic, strong) UILabel *centerLabel;         //中间图片下方label
@property (nonatomic, strong) UIImageView *leftImageView;   //左边图片
@property (nonatomic, strong) UILabel *leftLabel;           //左边图片下方label
@property (nonatomic, strong) UIImageView *rightImageView;  //右边图片
@property (nonatomic, strong) UILabel *rightLabel;          //右边图片下方label

@end;
@implementation AliyunPlayerViewFirstStartGuideView

- (UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
     }
    return _centerImageView;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
    }
    return _centerLabel;
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        
    }
    return _leftLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        
    }
    return _rightLabel;
}

- (UIControl *)control{
    if (!_control) {
        _control = [[UIControl alloc] init];
        [_control addTarget:self action:@selector(controlButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _control;
}

- (void)controlButton:(UIControl *)sender{
    [self removeFromSuperview];
}

#pragma mark - init
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:self.control];
        
        [self addSubview:self.centerImageView];
        [self addSubview:self.centerLabel];
        
        [self addSubview:self.leftImageView];
        [self addSubview:self.leftLabel];
        
        [self addSubview:self.rightImageView];
        [self addSubview:self.rightLabel];
    }
    return self;
}

- (void)layoutSubviews{
    NSBundle *resourceBundle = [AliyunUtil languageBundle];
    CGFloat height = self.bounds.size.height;
    
    self.control.frame = self.bounds;
    
    self.centerImageView.frame = CGRectMake(0, 0, ALYFirstStartGuideViewCenterIVWidth, ALYFirstStartGuideViewCenterIVHeight);
    self.centerImageView.center= self.center;
    
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.center = self.centerImageView.center;
    self.centerLabel.frame = CGRectMake(0, 0, ALYFirstStartGuideViewLabelWidth, ALYFirstStartGuideViewLabelHeight);
    self.centerLabel.center = self.centerImageView.center;
    CGRect frame = self.centerLabel.frame;
    frame.origin.y = self.centerImageView.frame.origin.y+self.centerImageView.frame.size.height+ALYFirstStartGuideViewMargin;
    self.centerLabel.frame= frame;
    self.centerLabel.numberOfLines = 999;
    self.centerLabel.textColor = [UIColor whiteColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = ALYFirstStartGuideViewMargin;// 字体的行间距
    
    NSString *center = NSLocalizedStringFromTableInBundle(@"center", nil, resourceBundle, nil);
    NSString *progress = NSLocalizedStringFromTableInBundle(@"progress", nil, resourceBundle, nil);
    NSString *control = NSLocalizedStringFromTableInBundle(@"control", nil, resourceBundle, nil);
    NSString *centerStr = [NSString stringWithFormat:@"%@\n %@ %@",center,progress,control];
//    @"中心\n  进度调节";
    NSMutableAttributedString *maString = [[NSMutableAttributedString alloc] initWithString:centerStr];
    [maString addAttributes:@{ NSForegroundColorAttributeName: [AliyunUtil textColor:self.skin] ,
                               NSFontAttributeName : [UIFont systemFontOfSize:ALYFirstStartGuideViewTextFont],
                               NSParagraphStyleAttributeName:paragraphStyle,
                               } range:NSMakeRange(center.length+2, progress.length+1)];
    self.centerLabel.attributedText = maString;
    
    self.leftImageView.frame = CGRectMake(self.centerImageView.frame.origin.x-ALYFirstStartGuideViewImageViewMargin-ALYFirstStartGuideViewLeftIVWidth, (height-ALYFirstStartGuideViewLeftIVHeight)/2, ALYFirstStartGuideViewLeftIVWidth, ALYFirstStartGuideViewLeftIVHeight);
    
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.frame = CGRectMake(0, 0, ALYFirstStartGuideViewLabelWidth, ALYFirstStartGuideViewLabelHeight);
    self.leftLabel.center = self.leftImageView.center;
    CGRect frame1 = self.leftLabel.frame;
    frame1.origin.y = self.centerImageView.frame.origin.y+self.centerImageView.frame.size.height+ALYFirstStartGuideViewMargin;
    
    self.leftLabel.frame= frame1;
    self.leftLabel.numberOfLines = 999;
    self.leftLabel.textColor = [UIColor whiteColor];
    NSString *left = NSLocalizedStringFromTableInBundle(@"left", nil, resourceBundle, nil);
    NSString *brightness = NSLocalizedStringFromTableInBundle(@"brightness", nil, resourceBundle, nil);
    NSString *centerStr1 = [NSString stringWithFormat:@"%@\n %@ %@",
                                                  left,
                                                  brightness,
                                                  control];
//    @"左侧\n  亮度调节";
    NSMutableAttributedString *maString1 = [[NSMutableAttributedString alloc] initWithString:centerStr1];
    [maString1 addAttributes:@{ NSForegroundColorAttributeName: [AliyunUtil textColor:self.skin] ,
                               NSFontAttributeName : [UIFont systemFontOfSize:ALYFirstStartGuideViewTextFont],
                               NSParagraphStyleAttributeName:paragraphStyle,
                               } range:NSMakeRange(left.length+2, brightness.length+1)];
    self.leftLabel.attributedText = maString1;
    
    self.rightImageView.frame = CGRectMake(self.centerImageView.frame.origin.x+self.centerImageView.frame.size.width+ALYFirstStartGuideViewImageViewMargin, (height-ALYFirstStartGuideViewLeftIVHeight)/2, ALYFirstStartGuideViewLeftIVWidth, ALYFirstStartGuideViewLeftIVHeight);
    
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.frame = CGRectMake(0, 0, ALYFirstStartGuideViewLabelWidth, ALYFirstStartGuideViewLabelHeight);
    self.rightLabel.center = self.rightImageView.center;
    CGRect frame3 = self.rightLabel.frame;
    frame3.origin.y = self.centerImageView.frame.origin.y+self.centerImageView.frame.size.height + ALYFirstStartGuideViewMargin;
    self.rightLabel.frame= frame3;
    self.rightLabel.numberOfLines = 999;
    self.rightLabel.textColor = [UIColor whiteColor];
    
    NSString *right = NSLocalizedStringFromTableInBundle(@"right", nil, resourceBundle, nil);
    NSString *volume = NSLocalizedStringFromTableInBundle(@"volume", nil, resourceBundle, nil);
    NSString *centerStr3 = [NSString stringWithFormat:@"%@\n %@ %@",right,volume,control];
    
//    @"右侧\n  音量调节";
    NSMutableAttributedString *maString3 = [[NSMutableAttributedString alloc] initWithString:centerStr3];
    [maString3 addAttributes:@{ NSForegroundColorAttributeName: [AliyunUtil textColor:self.skin] ,
                                NSFontAttributeName : [UIFont systemFontOfSize:ALYFirstStartGuideViewTextFont],
                                NSParagraphStyleAttributeName:paragraphStyle,
                                } range:NSMakeRange(right.length+2, volume.length+1)];
    self.rightLabel.attributedText = maString3;
  
}

#pragma mark - 重写setter方法
- (void)setSkin:(AliyunVodPlayerViewSkin)skin{
    _skin = skin;
    self.centerImageView.image = [AliyunUtil imageWithNameInBundle:@"al_hit_center" skin:skin];
    self.leftImageView.image = [AliyunUtil imageWithNameInBundle:@"al_hit_left" skin:skin];
    self.rightImageView.image = [AliyunUtil imageWithNameInBundle:@"al_hit_right" skin:skin];
}

#pragma mark - public method
- (void)dismiss{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
