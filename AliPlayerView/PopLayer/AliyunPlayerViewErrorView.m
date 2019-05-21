//
//  ALPVErrorMessageView.m
//

#import "AliyunPlayerViewErrorView.h"

static const CGFloat AliyunPlayerViewErrorViewWidth         = 220; //宽度
static const CGFloat AliyunPlayerViewErrorViewHeight        = 120; //高度
static const CGFloat AliyunPlayerViewErrorViewTextMarginTop = 30;  //text距离顶部距离
static const CGFloat ALYPVErrorButtonWidth       = 82;  //button宽度
static const CGFloat ALYPVErrorButtonHeight      = 30;  //button高度
static const CGFloat ALYPVErrorButtonMarginLeft  = 68;  //button左侧距离父类距离
static const CGFloat AliyunPlayerViewErrorViewRadius        = 4;   //半径

@interface AliyunPlayerViewErrorView ()
@property (nonatomic, strong) UILabel *textLabel;               //错误界面，文本提示
@property (nonatomic, strong) UIButton *button;                 //界面中 点击按钮
@property (nonatomic, strong) NSString *errorButtonEventType; //按钮中，提示信息（重播、重试等）
@end

@implementation AliyunPlayerViewErrorView

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setTextColor:kALYPVColorTextNomal];
        [_textLabel setFont:[UIFont systemFontOfSize:[AliyunUtil nomalTextSize]]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        _textLabel.numberOfLines = 999;
    }
    return _textLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"al_error_btn_white"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"al_over_btn_refresh"] forState:UIControlStateNormal];
        _button.imageEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        _button.titleLabel.font = [UIFont systemFontOfSize:[AliyunUtil nomalTextSize]];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_button setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
        [_button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

#pragma mark - init
- (instancetype)init{
    CGRect defaultFrame = CGRectMake(0, 0, AliyunPlayerViewErrorViewWidth, AliyunPlayerViewErrorViewHeight);
    return [self initWithFrame:defaultFrame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = AliyunPlayerViewErrorViewWidth;
    CGFloat height = AliyunPlayerViewErrorViewHeight;
    self.textLabel.frame = CGRectMake(0, AliyunPlayerViewErrorViewTextMarginTop, width, height);
    self.button.frame = CGRectMake(ALYPVErrorButtonMarginLeft, AliyunPlayerViewErrorViewTextMarginTop/2.0,
                                   ALYPVErrorButtonWidth,
                                   ALYPVErrorButtonHeight);
}

#pragma mark - 重写setter方法
-(void)setSkin:(AliyunVodPlayerViewSkin)skin{
    _skin = skin;
    [self.button setTitleColor:[AliyunUtil textColor:skin] forState:UIControlStateNormal];
    self.button.titleLabel.textColor = [AliyunUtil textColor:skin];
    self.button.layer.cornerRadius = 5;
    self.button.layer.borderWidth = 1;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderColor = [AliyunUtil textColor:skin].CGColor;
    [self.button setImage:[UIImage imageNamed:@"al_over_btn_refresh"] forState:UIControlStateNormal];
    self.textLabel.textColor = [AliyunUtil textColor:skin];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.textLabel.text = message;
    int width = AliyunPlayerViewErrorViewWidth;
    NSDictionary *dic = @{NSFontAttributeName : self.textLabel.font};
    CGRect infoRect = [message boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    self.textLabel.frame = CGRectMake(0, self.frame.size.width/2.0, width, infoRect.size.height);
    [self setNeedsLayout];
}

/*
 "Retry" = "重试";
 "Replay" = "重播";
 "Play" = "播放";
 */
- (void)setType:(ALYPVErrorType)type{
    _type = type;
    NSString *str = @"";
    NSBundle *resourceBundle = [AliyunUtil languageBundle];
    switch (type) {
        case ALYPVErrorTypeUnknown:
             str = NSLocalizedStringFromTableInBundle(@"Retry", nil, resourceBundle, nil);
            break;
        case ALYPVErrorTypeRetry:
            str = NSLocalizedStringFromTableInBundle(@"Retry", nil, resourceBundle, nil);
            break;
        case ALYPVErrorTypeReplay:
            str = NSLocalizedStringFromTableInBundle(@"Replay", nil, resourceBundle, nil);
            break;
        case ALYPVErrorTypePause:
            str = NSLocalizedStringFromTableInBundle(@"Play", nil, resourceBundle, nil);
            break;
            
        default:
            break;
    }
    [_button setTitle:str forState:UIControlStateNormal];
}

#pragma mark - public method
/*
 * 功能 ：展示错误页面偏移量
 * 参数 ：parent 插入的界面
 */
- (void)showWithParentView:(UIView *)parent {
    if (!parent) {
        return;
    }
    parent.hidden = NO;
    [parent addSubview:self];
    self.center = CGPointMake(parent.frame.size.width / 2, parent.frame.size.height / 2);
    self.backgroundColor = [UIColor clearColor];
}

/*
 * 功能 ：是否展示界面
 */
- (BOOL)isShowing {
    return self.superview != nil;
}

/*
 * 功能 ：是否删除界面
 */
- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - onClick
- (void)onClick:(UIButton *)sender {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onErrorViewClickedWithType:)]) {
        [self.delegate onErrorViewClickedWithType:self.type];
    }  
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [AliyunUtil drawFillRoundRect:rect radius:[AliyunUtil convertPixelToPoint:AliyunPlayerViewErrorViewRadius] color:kALYPVPopErrorViewBackGroundColor context:context];
    CGContextRestoreGState(context);
}

@end
