//
//  AliyunPVPlaySpeedView.m
//

#import "AliyunPlayerViewSpeedView.h"
#import "AliyunSpeedButton.h"

static const CGFloat ALYPVPlaySpeedViewTitleFont = 18.0f;

@interface AliyunPlayerViewSpeedView()
@property (nonatomic, strong) UIView *contentView;      //包含所有的view
@property (nonatomic, strong) UIControl *contentControl;//contentView上的control
@property (nonatomic, strong) UIView *containBtnView;   //包含选择倍速的view
@property (nonatomic, strong) UIControl *containControl;//containBtnView上的control
@property(nonatomic, strong) UILabel *titleLabel;       //标题
@property (nonatomic, strong) UILabel *tipLabel;        //提示信息
@property (nonatomic, assign) NSInteger btnTag;         //记录上次点击按钮TAG
@end

@implementation AliyunPlayerViewSpeedView
#pragma mark - 懒加载
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

- (UIControl *)contentControl{
    if (!_contentControl) {
        _contentControl = [[UIControl alloc] init];
        _contentControl.backgroundColor = [UIColor clearColor];
        [_contentControl addTarget:self action:@selector(controlButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _contentControl;
}

- (UIControl *)containControl{
    if (!_containControl) {
        _containControl = [[UIControl alloc] init];
        _containControl.backgroundColor = [UIColor clearColor];
        [_containControl addTarget:self action:@selector(controlButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _containControl;
}

- (void)controlButton:(UIControl *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        if ([AliyunUtil isInterfaceOrientationPortrait]) {
            CGRect frame = self.containBtnView.frame;
            frame.origin.x = self.frame.size.width;
            self.containBtnView.frame = frame;
        }else{
            CGRect frame = self.containBtnView.frame;
            frame.origin.x = SCREEN_WIDTH;
            self.containBtnView.frame = frame;
        }
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (UIView *)containBtnView{
    if (!_containBtnView) {
        _containBtnView = [[UIView alloc] init];
        _containBtnView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _containBtnView;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        NSBundle *resourceBundle = [AliyunUtil languageBundle];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = NSLocalizedStringFromTableInBundle(@"Fast speed play", nil, resourceBundle, nil);//@"倍速播放";
        [_titleLabel setFont:[UIFont systemFontOfSize:ALYPVPlaySpeedViewTitleFont]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setTextColor:kALYPVColorTextNomal];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
        _tipLabel.backgroundColor = [UIColor blackColor];
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

#pragma mark - buttonClicked
- (void)buttonClicked:(UIButton *)sender{
    if (sender.tag == self.btnTag) {
        return;
    }
    AliyunSpeedButton *nomalBtn = [self viewWithTag:self.btnTag];
    nomalBtn.speedImageView.image = nil;
    nomalBtn.speedLabel.textColor = [UIColor whiteColor];
    AliyunSpeedButton *btn = (AliyunSpeedButton*)sender;
    btn.speedLabel.textColor = [AliyunUtil textColor:self.skin];
    btn.speedImageView.image = [AliyunUtil imageWithNameInBundle:@"al_point_btn" skin:self.skin];
    self.btnTag = btn.tag;

    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunPVPlaySpeedView:playSpeed:)]) {
        float speed = 1.0;
        long tempTag = sender.tag - 10000;
        if ( tempTag == 3) {
            speed = 2.0;
        }else{
            speed += 0.25*tempTag;
        }
        [self.delegate aliyunPVPlaySpeedView:self playSpeed:speed];
        
        [self showSpeedViewSelectedPushInAnimateWithPlaySpeed:speed];
    }
}


#pragma mark - init
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame: frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.btnTag = 10000;
        
        [self addSubview:self.contentView];
        [self.contentView addSubview: self.contentControl];
        [self.containBtnView addSubview:self.titleLabel];
        [self.containBtnView addSubview:self.containControl];
        [self.containBtnView sendSubviewToBack:self.containControl];
        [self.contentView addSubview:self.containBtnView];
        [self.contentView addSubview:self.tipLabel];
    }
    return self;
}
#pragma mark - layoutSubviews
-(void)layoutSubviews{
    self.contentView.frame = self.bounds;
    self.contentControl.frame = self.contentView.bounds;
    if ([AliyunUtil isInterfaceOrientationPortrait]){
        self.containBtnView.frame = self.contentView.bounds;
    }else{
        self.containBtnView.frame = CGRectMake(self.contentView.frame.size.width-310, 0, 310, self.contentView.frame.size.height);;
    }
    self.titleLabel.frame = CGRectMake(0, 0, self.containBtnView.frame.size.width, 48);
    self.containControl.frame = self.containBtnView.bounds;
    CGFloat leftWidth = 20;
    CGFloat buttonWidth = 60;
    CGFloat disWidth = (self.containBtnView.frame.size.width - 4*buttonWidth-2*leftWidth)/3;
    CGFloat tempY  = self.containBtnView.frame.size.height/2-45;
    for (int i = 0; i<4; i++) {
        //已经存在，不在重复创建
        AliyunSpeedButton *tempButton = [self viewWithTag:10000+i];
        if (tempButton) {
            tempButton.frame = CGRectMake(leftWidth+i*(disWidth+buttonWidth), tempY, buttonWidth, 30+15);
            continue;
        }
        
        AliyunSpeedButton *btn = [AliyunSpeedButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.speedLabel.font = [UIFont systemFontOfSize:15.0];
        btn.speedLabel.textAlignment = NSTextAlignmentCenter;
        if (self.btnTag==btn.tag) {
            btn.speedLabel.textColor = [AliyunUtil textColor:self.skin];
            btn.speedImageView.image = [AliyunUtil imageWithNameInBundle:@"al_point_btn" skin:self.skin];
        }else{
            btn.speedLabel.textColor = [UIColor whiteColor];
            btn.speedImageView.image = [[UIImage alloc] init];
        }
        NSBundle *resourceBundle = [AliyunUtil languageBundle];
        btn.frame = CGRectMake(leftWidth+i*(disWidth+buttonWidth), tempY, buttonWidth, 30+15);
        switch (i) {
            case 0:
                btn.speedLabel.text =  NSLocalizedStringFromTableInBundle(@"Nomal", nil, resourceBundle, nil);//@"正常";
                break;
            case 1:
                btn.speedLabel.text =  NSLocalizedStringFromTableInBundle(@"1.25X", nil, resourceBundle, nil);
                break;
            case 2:
                btn.speedLabel.text =  NSLocalizedStringFromTableInBundle(@"1.5X", nil, resourceBundle, nil);
                break;
            case 3:
                btn.speedLabel.text =  NSLocalizedStringFromTableInBundle(@"2X", nil, resourceBundle, nil);
                break;
            default:
                break;
        }
        [self.containBtnView addSubview:btn];
    }
}


//倍速播放界面入场、退场动画
//倍速播放界面 入场动画
- (void)showSpeedViewMoveInAnimate{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        if ([AliyunUtil isInterfaceOrientationPortrait]) {//竖屏
            CGRect frame = self.containBtnView.frame;
            frame.origin.x = 0;
            self.containBtnView.frame = frame;
        }else{//横屏
            CGRect frame = self.containBtnView.frame;
            frame.origin.x = self.frame.size.width-310;
            self.containBtnView.frame = frame;
        }
    } completion:^(BOOL finished) {
    }];
}

//倍速播放界面  退场动画
- (void)showSpeedViewPushInAnimate{
    if (!self.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            if ([AliyunUtil isInterfaceOrientationPortrait]) {
                CGRect frame = self.containBtnView.frame;
                frame.origin.x = self.frame.size.width;
                self.containBtnView.frame = frame;
            }else{
                CGRect frame = self.containBtnView.frame;
                frame.origin.x = SCREEN_WIDTH;
                self.containBtnView.frame = frame;
            }
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}

//倍速播放界面 选中选择倍速值后退出
- (void)showSpeedViewSelectedPushInAnimateWithPlaySpeed:(float)playSpeed{
    [UIView animateWithDuration:0.3 animations:^{
        if ([AliyunUtil isInterfaceOrientationPortrait]) {
            CGRect frame = self.containBtnView.frame;
            frame.origin.x = self.containBtnView.frame.size.width;
            self.containBtnView.frame = frame;
        }else{
            CGRect frame = self.containBtnView.frame;
            frame.origin.x = SCREEN_WIDTH;
            self.containBtnView.frame = frame;
        }
    } completion:^(BOOL finished) {
        self.tipLabel.hidden = NO;
        NSString *title = [self tipMessageWithSpeed:playSpeed];
        self.tipLabel.text = title;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],};
        CGSize textSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        self.tipLabel.frame = CGRectMake((self.frame.size.width-textSize.width-10)/2, self.frame.size.height-75, textSize.width+10, 40);
        [UIView animateWithDuration:2 animations:^{
            self.tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.tipLabel.hidden = YES;
            self.tipLabel.alpha = 1.0;
            self.hidden = YES;
        }];
    }];
}

- (NSString *)tipMessageWithSpeed:(float)speed{
    NSBundle *resourceBundle = [AliyunUtil languageBundle];
    NSString *speedStr = @"";
    if (speed == 1.0) {
        speedStr = @"Nomal";
    }else if (speed == 1.25){
        speedStr = @"1.25X";
    }else if (speed == 1.5){
        speedStr = @"1.5X";
    }else if (speed == 2.0){
        speedStr = @"2X";
    }
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@",
                       NSLocalizedStringFromTableInBundle(@"the current video has swiched to", nil, resourceBundle, nil),
                       NSLocalizedStringFromTableInBundle(speedStr, nil, resourceBundle, nil),
                       NSLocalizedStringFromTableInBundle(@"speed rate", nil, resourceBundle, nil)];
    return title;
}


@end
