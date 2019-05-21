//
//  AlyunVodBottomView.m
//  playtset
//

#import "AliyunPlayerViewBottomView.h"
#import "AliyunPrivateDefine.h"
#import <SnapKit/SnapKit-Swift.h>
static const CGFloat ALYPVBottomViewPlayButtonWidth         = 48;                         //播放按钮宽度
static const CGFloat ALYPVBottonViewFullScreenTimeWidth     = 80 + 40;                    //全屏时间宽度
static const CGFloat ALYPVBottomViewTextSizeFont            = 12.0f;                      //字体字号
static NSString * const ALYPVBottomViewDefaultTime          = @"00:00:00";                //默认时间样式

@interface AliyunPlayerViewBottomView()<AliyunVodProgressViewDelegate>
@property (nonatomic, strong) UIImageView *bottomBarBG;             //背景图片
@property (nonatomic, strong) UIButton *playButton;                 //播放按钮
@property (nonatomic, strong) UILabel *leftTimeLabel;               //左侧时间
@property (nonatomic, strong) UILabel *rightTimeLabel;              //右侧时间
@property (nonatomic, strong) UILabel *fullScreenTimeLabel;         //全屏时时间
@property (nonatomic, strong) UIButton *fullScreenButton;           //全屏按钮
@property (nonatomic, strong) AliyunPlayerViewProgressView *progressView;  //进度条
@end

@implementation AliyunPlayerViewBottomView

- (UIImageView *)bottomBarBG{
    if (!_bottomBarBG) {
        _bottomBarBG = [[UIImageView alloc] init];
    }
    return _bottomBarBG;
}

- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"avcPlayIcon"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"avcPause"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (void)playButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithAliyunPVBottomView:)]) {
        [self.delegate onClickedPlayButtonWithAliyunPVBottomView:self];
    }
}

- (UILabel *)leftTimeLabel{
    if (!_leftTimeLabel) {
        _leftTimeLabel = [[UILabel alloc] init];
        _leftTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_leftTimeLabel setFont:[UIFont systemFontOfSize:ALYPVBottomViewTextSizeFont]];
        [_leftTimeLabel setTextColor:kALYPVColorTextNomal];
        _leftTimeLabel.text = ALYPVBottomViewDefaultTime;
    }
    return _leftTimeLabel;
}

- (UILabel *)rightTimeLabel{
    if (!_rightTimeLabel) {
        _rightTimeLabel = [[UILabel alloc] init];
        _rightTimeLabel.textAlignment = NSTextAlignmentRight;
        [_rightTimeLabel setFont:[UIFont systemFontOfSize:ALYPVBottomViewTextSizeFont]];
        [_rightTimeLabel setTextColor:kALYPVColorTextNomal];
        _rightTimeLabel.text = ALYPVBottomViewDefaultTime;
    }
    return _rightTimeLabel;
}

- (UILabel *)fullScreenTimeLabel{
    if (!_fullScreenTimeLabel) {
        _fullScreenTimeLabel = [[UILabel alloc] init];
        _fullScreenTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_fullScreenTimeLabel setFont:[UIFont systemFontOfSize:ALYPVBottomViewTextSizeFont]];
        NSString *curTimeStr = @"00:00:00";
        NSString *totalTimeStr = @"00:00:00";
        NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
        [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextNomal range:NSMakeRange(0, curTimeStr.length)];
        [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextGray range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
        [_fullScreenTimeLabel setAttributedText:str];
    }
    return _fullScreenTimeLabel;
}

- (UIButton *)qualityButton{
    if (!_qualityButton) {
        _qualityButton = [[UIButton alloc] init];
        [_qualityButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_qualityButton setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
        [_qualityButton setTitleColor:kALYPVColorBlue forState:UIControlStateSelected];
        [_qualityButton setTag:1003];
        [_qualityButton addTarget:self action:@selector(qualityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qualityButton;
}

- (void)qualityButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunPVBottomView:qulityButton:)]) {
        [self.delegate aliyunPVBottomView:self qulityButton:sender];
        sender.selected = !sender.isSelected;
    }
}

- (UIButton *)fullScreenButton{
    if (!_fullScreenButton) {
        _fullScreenButton = [[UIButton alloc] init];
        [_fullScreenButton setTag:1004];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenButton;
}

- (void)fullScreenButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedfullScreenButtonWithAliyunPVBottomView:)]) {
        [self.delegate onClickedfullScreenButtonWithAliyunPVBottomView:self];
    }
}

- (AliyunPlayerViewProgressView *)progressView{
    if (!_progressView){
        _progressView = [[AliyunPlayerViewProgressView alloc] init];
    }
    return _progressView;
}

#pragma mark - init
- (instancetype)init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.bottomBarBG];
    [self addSubview:self.playButton];
    [self addSubview:self.leftTimeLabel];
    [self addSubview:self.rightTimeLabel];
    [self addSubview:self.fullScreenTimeLabel];
    [self addSubview:self.qualityButton];
//    [self.qualityButton setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.fullScreenButton];
    self.progressView.delegate = self;
    [self addSubview:self.progressView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.bottomBarBG.frame = self.bounds;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    self.playButton.frame = CGRectMake(0, 0,ALYPVBottomViewPlayButtonWidth, height);
    self.fullScreenButton.frame = CGRectMake(width - ALYPVBottomViewFullScreenButtonWidth + 5, 5 ,ALYPVBottomViewFullScreenButtonWidth * 0.8, height * 0.8);
    
    
    if (self.isPortrait) {
        self.fullScreenButton.selected = YES;
        self.qualityButton.hidden = NO;
        self.leftTimeLabel.hidden = NO;
        self.rightTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.hidden = YES;
    
        int qualityWidth = ALYPVBottomViewQualityButtonWidth;
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
            qualityWidth = 0;
        }
        
        self.progressView.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth, height,
                                             width - (ALYPVBottomViewPlayButtonWidth + ALYPVBottomViewFullScreenButtonWidth+qualityWidth),
                                             height);
        
        CGRect progressFrame = self.progressView.frame;
        self.leftTimeLabel.frame = CGRectMake(progressFrame.origin.x, height/2, progressFrame.size.width/2, height/2);
        self.rightTimeLabel.frame = CGRectMake(progressFrame.origin.x + progressFrame.size.width/2,height/2, progressFrame.size.width/2, height/2);
        return;
    }
    
    if ([AliyunUtil isInterfaceOrientationPortrait]) {
        self.fullScreenButton.selected = NO;
        self.qualityButton.hidden = YES;
        self.qualityButton.selected = NO;
        
        self.leftTimeLabel.hidden = NO;
        self.rightTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.hidden = YES;
        
        self.progressView.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth, 0,
                                             width - (ALYPVBottomViewPlayButtonWidth + ALYPVBottomViewFullScreenButtonWidth),
                                             height);
        
        CGRect progressFrame = self.progressView.frame;
        self.leftTimeLabel.frame = CGRectMake(progressFrame.origin.x, height/2, progressFrame.size.width/2, height/2);
        self.rightTimeLabel.frame = CGRectMake(progressFrame.origin.x + progressFrame.size.width/2,height/2, progressFrame.size.width/2, height/2);
        
    } else {
        self.fullScreenButton.selected = YES;
        self.qualityButton.hidden = NO;
//        self.qualityButton.selected = NO;
        
        self.leftTimeLabel.hidden = YES;
        self.rightTimeLabel.hidden = YES;
        self.fullScreenTimeLabel.hidden = NO;
        self.fullScreenTimeLabel.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth, 0,ALYPVBottonViewFullScreenTimeWidth, height);
        
        int qualityWidth = ALYPVBottomViewQualityButtonWidth;
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
            qualityWidth = 0;
        }
        self.qualityButton.frame = CGRectMake(width - (ALYPVBottomViewQualityButtonWidth + ALYPVBottomViewFullScreenButtonWidth), 0, ALYPVBottomViewQualityButtonWidth, height);
        self.progressView.frame = CGRectMake(ALYPVBottomViewPlayButtonWidth + ALYPVBottonViewFullScreenTimeWidth + ALYPVBottomViewMargin, 0, width - (ALYPVBottomViewPlayButtonWidth + ALYPVBottonViewFullScreenTimeWidth + 2 * ALYPVBottomViewMargin  + qualityWidth + ALYPVBottomViewFullScreenButtonWidth), height);
    }
}

#pragma mark - 重写属性setter方法
- (void)setSkin:(AliyunVodPlayerViewSkin)skin{
    _skin = skin;
    [self.bottomBarBG setImage:[UIImage imageNamed:@"al_playbar_bg"]];
    
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"avcPlayIcon"] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"avcPause"] forState:UIControlStateSelected];
    
//    [self.fullScreenButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_play_screen" skin:skin] forState:UIControlStateSelected];
//    [self.fullScreenButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_play_screen_full" skin:skin] forState:UIControlStateNormal];
    
    [self.fullScreenButton setImage:[UIImage imageNamed:@"alivc_fullScreen"] forState:UIControlStateSelected];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"alivc_fullScreen"] forState:UIControlStateNormal];
    
    [self.qualityButton setBackgroundImage:[UIImage imageNamed:@"al_quality_btn_nomal"] forState:UIControlStateNormal];
    [self.qualityButton setBackgroundImage:[UIImage imageNamed:@"al_quality_btn_press_blue"] forState:UIControlStateSelected];
    
    self.progressView.skin = skin;
}



- (void)setVideoInfo:(AliyunVodPlayerVideo *)videoInfo{
    _videoInfo = videoInfo;
    NSArray *ary = [AliyunUtil allQualities];
    if (videoInfo) {
        if ((int)videoInfo.videoQuality < 0) {
            [self.qualityButton setTitle:videoInfo.videoDefinition forState:UIControlStateNormal];
        }else{
            [self.qualityButton setTitle:ary[videoInfo.videoQuality] forState:UIControlStateNormal];
        }
        self.qualityButton.hidden = NO;
    }
    [self setNeedsLayout];
}

- (void)setProgress:(float)progress{
    _progress = progress;
    self.progressView.progress = progress;
}

- (void)setLoadTimeProgress:(float)loadTimeProgress{
    _loadTimeProgress = loadTimeProgress;
    self.progressView.loadTimeProgress = loadTimeProgress;
}

- (void)setIsPortrait:(BOOL)isPortrait{
    _isPortrait = isPortrait;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - progressDelegate
- (void)aliyunVodProgressView:(AliyunPlayerViewProgressView *)progressView dragProgressSliderValue:(float)value event:(UIControlEvents)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodBottomView:dragProgressSliderValue:event:)]) {
        [self.delegate aliyunVodBottomView:self dragProgressSliderValue:value event:event];
    }
}

#pragma mark -  public method
/*
 * 功能 ：更新进度条
 * 参数 ：currentTime 当前播放时间
 durationTime 播放总时长
 */
- (void)updateProgressWithCurrentTime:(float)currentTime durationTime:(float)durationTime{
    
    //左右全屏时间
    NSString *curTimeStr = [AliyunUtil timeformatFromSeconds:roundf(currentTime)];
    NSString *totalTimeStr = [AliyunUtil timeformatFromSeconds:roundf(durationTime)];
    self.rightTimeLabel.text = totalTimeStr;
    self.leftTimeLabel.text = curTimeStr;
    NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
    [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextNomal range:NSMakeRange(0, curTimeStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextGray range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
    self.fullScreenTimeLabel.attributedText = str;
    
    //进度条
    [self.progressView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
    
    //
//    NSLog(@"playtimetest当前播放时间:%f",currentTime);
//    
//    NSLog(@"playtimetest当前播放时间字符串:%@",curTimeStr);
//    
//    NSLog(@"playtimetest总时间:%f",durationTime);
//    
//    NSLog(@"playtimetest总时间字符串:%@",totalTimeStr);
}

- (void)updateCurrentTime:(float)currentTime durationTime:(float)durationTime{
    //左右全屏时间
    NSString *curTimeStr = [AliyunUtil timeformatFromSeconds:roundf(currentTime)];
    NSString *totalTimeStr = [AliyunUtil timeformatFromSeconds:roundf(durationTime)];
    self.rightTimeLabel.text = totalTimeStr;
    self.leftTimeLabel.text = curTimeStr;
    NSString *time = [NSString stringWithFormat:@"%@/%@", curTimeStr, totalTimeStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time];
    [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextNomal range:NSMakeRange(0, curTimeStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:kALYPVColorTextGray range:NSMakeRange(curTimeStr.length, curTimeStr.length + 1)];
    self.fullScreenTimeLabel.attributedText = str;
}

/*
 * 功能 ：根据播放器状态，改变状态
 * 参数 ：state 播放器状态
 */
- (void)updateViewWithPlayerState:(AliyunVodPlayerState)state {
    switch (state) {
        case AliyunVodPlayerStateIdle:
        {
            [self.playButton setSelected:NO];
//            [self.qualityButton setUserInteractionEnabled:NO];
//            [self.progressView setUserInteractionEnabled:NO];
        }
            break;
        case AliyunVodPlayerStateError:
        {
            [self.playButton setSelected:NO];
            //cai 错误也应该让用户点击按钮重试
//            [self.playButton setUserInteractionEnabled:NO];
//            [self.progressView setUserInteractionEnabled:NO];
        }
            break;
        case AliyunVodPlayerStatePrepared:
        {
            [self.playButton setSelected:NO];
            [self.qualityButton setUserInteractionEnabled:YES];
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStatePlay:
        {
            [self.playButton setSelected:YES];
            [self.qualityButton  setUserInteractionEnabled:YES];
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStatePause:
        {
            [self.playButton setSelected:NO];
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStateStop:
        {
            [self.playButton setSelected:NO];
            [self.qualityButton setUserInteractionEnabled:NO];
            [self.progressView setUserInteractionEnabled:NO];
            
        }
            break;
        case AliyunVodPlayerStateLoading:
        {
            [self.progressView setUserInteractionEnabled:YES];
        }
            break;
        case AliyunVodPlayerStateFinish:
        {
            [self.progressView setUserInteractionEnabled:NO];
        }
            break;
            
        default:
            break;
    }
}

/*
 * 功能 ：锁屏状态
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    if (!isScreenLocked) {
        self.playButton.hidden = NO;
        self.fullScreenButton.hidden = NO;
        self.fullScreenTimeLabel.hidden = NO;
        self.qualityButton.hidden = NO;
        if (fixedPortrait) {
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = NO;
        }else{
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = YES;
        }
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
        }
        self.progressView.hidden = NO;
    }else{
        self.playButton.hidden = YES;
        self.fullScreenButton.hidden = YES;
        self.fullScreenTimeLabel.hidden = YES;
        self.qualityButton.hidden = YES;
        self.progressView.hidden = YES;
        self.leftTimeLabel.hidden = YES;
        self.rightTimeLabel.hidden = YES;
    }
}

/*
 * 功能 ：取消锁屏
 * 参数 ：isScreenLocked 是否是锁屏状态
 fixedPortrait 是否是绝对竖屏状态
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    if (isScreenLocked||fixedPortrait) {
        if (fixedPortrait) {
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = NO;
        }else{
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = YES;
        }
        self.fullScreenButton.hidden =  NO;
        self.fullScreenTimeLabel.hidden = NO;
        self.qualityButton.hidden = NO;
        self.playButton.hidden = NO;
        
        NSArray *qualityAry = [self.videoInfo.allSupportQualitys copy];
        if (qualityAry && qualityAry.count>0) {
            self.qualityButton.hidden = NO;
        }else{
            self.qualityButton.hidden = YES;
        }
        self.progressView.hidden = NO;
    }
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
