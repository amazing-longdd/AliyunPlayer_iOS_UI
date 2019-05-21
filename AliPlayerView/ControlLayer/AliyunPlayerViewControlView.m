//
//  AliyunControlView.m
//

#import "AliyunPlayerViewControlView.h"


static const CGFloat ALYControlViewTopViewHeight    = 48;   //topView 高度
static const CGFloat ALYControlViewBottomViewHeight = 48;   //bottomView 高度
static const CGFloat ALYControlViewLockButtonLeft   = 20;   //lockButton 左侧距离父视图距离
static const CGFloat ALYControlViewLockButtonHeight = 40;   //lockButton 高度

@interface AliyunPlayerViewControlView()<AliyunPVTopViewDelegate,AliyunVodBottomViewDelegate,AliyunPVGestureViewDelegate,AliyunPVQualityListViewDelegate>
@property (nonatomic, strong) AliyunPlayerViewTopView *topView;             //topView
@property (nonatomic, strong) AliyunPlayerViewBottomView *bottomView;       //bottomView
@property (nonatomic, strong) AliyunPlayerViewGestureView *guestureView;    //手势view

@property (nonatomic, assign) BOOL isHiddenView;                    //是否需要隐藏topView、bottomView
@end
@implementation AliyunPlayerViewControlView

- (AliyunPlayerViewTopView *)topView{
    if (!_topView) {
        _topView = [[AliyunPlayerViewTopView alloc] init];
    }
    return _topView;
}

- (AliyunPlayerViewBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[AliyunPlayerViewBottomView alloc] init];
    }
    return _bottomView;
}

- (AliyunPlayerViewGestureView *)guestureView{
    if (!_guestureView) {
        _guestureView = [[AliyunPlayerViewGestureView alloc] init];
    }
    return _guestureView;
}

//- (AliyunPlayerViewQualityListView *)listView{
//    if (!_listView) {
//        _listView = [[AliyunPlayerViewQualityListView alloc] init];
//    }
//    return _listView;
//}

- (UIButton *)lockButton{
    if (!_lockButton) {
        _lockButton = [[UIButton alloc] init];
    }
    return _lockButton;
}

#pragma mark - init
- (instancetype)init {
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.isHiddenView = NO;
        
        self.guestureView.delegate = self;
        [self addSubview:self.guestureView];
        
        self.topView.delegate = self;
        [self addSubview:self.topView];
        
        self.bottomView.delegate = self;
        [self addSubview:self.bottomView];
        
        self.listView.delegate = self;
        
        [self.lockButton setImage:[UIImage imageNamed:@"alivc_unlock"] forState:UIControlStateNormal];
        [self.lockButton addTarget:self action:@selector(lockButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.lockButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float topBarHeight = ALYControlViewTopViewHeight;
    float bottomBarHeight = ALYControlViewBottomViewHeight;
    float bottomBarY = height - bottomBarHeight;
    self.guestureView.frame = self.bounds;
    self.topView.frame = CGRectMake(0, 0, width, topBarHeight);
    self.bottomView.frame = CGRectMake(0, bottomBarY, width, bottomBarHeight);
    self.lockButton.frame = CGRectMake(ALYControlViewLockButtonLeft, (height-ALYControlViewLockButtonHeight)/2.0, 2*ALYControlViewLockButtonLeft, ALYControlViewLockButtonHeight);
    
    float tempX = width - (ALYPVBottomViewFullScreenButtonWidth + ALYPVBottomViewQualityButtonWidth);
    float tempW = ALYPVBottomViewQualityButtonWidth;
    
    if (self.isProtrait) {
        self.lockButton.hidden = NO;
        self.listView.frame = CGRectMake(tempX, height-[self.listView estimatedHeight]-bottomBarHeight, tempW, [self.listView estimatedHeight]);
        return;
    }
    
    if ([AliyunUtil isInterfaceOrientationPortrait]) {
        self.lockButton.hidden = YES;
        self.listView.hidden = YES;
    }else{
        self.lockButton.hidden = NO;
        self.listView.hidden = !self.bottomView.qualityButton.selected;
    }
    self.listView.frame = CGRectMake(tempX, height-[self.listView estimatedHeight]-bottomBarHeight, tempW, [self.listView estimatedHeight]);
}

#pragma mark - 锁屏按钮 action
- (void)lockButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLockButtonClickedWithAliyunControlView:)]) {
        [self.delegate onLockButtonClickedWithAliyunControlView:self];
    }
}

#pragma mark - 重写setter方法
- (void)setIsProtrait:(BOOL)isProtrait{
    _isProtrait = isProtrait;
    self.bottomView.isPortrait = isProtrait;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSkin:(AliyunVodPlayerViewSkin)skin{
    _skin = skin;
    self.topView.skin = skin;
    self.bottomView.skin = skin;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self.topView setTopTitle:title];
}

- (void)setVideoInfo:(AliyunVodPlayerVideo *)videoInfo{
    _videoInfo = videoInfo;
    self.bottomView.videoInfo = videoInfo;
    [self.listView removeFromSuperview];
    self.listView = nil;
    self.listView = [[AliyunPlayerViewQualityListView alloc] init];
    self.listView.allSupportQualities = videoInfo.allSupportQualitys;
    self.listView.delegate = self;
    self.bottomView.qualityButton.selected = NO;
    [self setNeedsLayout];
}

- (void)setLoadTimeProgress:(float)loadTimeProgress{
    _loadTimeProgress = loadTimeProgress;
    self.bottomView.loadTimeProgress = loadTimeProgress;
}

- (void)setPlayMethod:(ALYPVPlayMethod)playMethod{
    _playMethod = playMethod;
    _topView.playMethod = playMethod;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - AliyunPVTopViewDelegate
- (void)onBackViewClickWithAliyunPVTopView:(AliyunPlayerViewTopView *)topView{
    if (![AliyunUtil isInterfaceOrientationPortrait]) {
        [AliyunUtil setFullOrHalfScreen];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithAliyunControlView:)]) {
            [self.delegate onBackViewClickWithAliyunControlView:self];
        }
    }
}

- (void)onDownloadButtonClickWithAliyunPVTopView:(AliyunPlayerViewTopView *)topView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithAliyunControlView:)]) {
        [self.delegate onDownloadButtonClickWithAliyunControlView:self];
    }
}

- (void)onSpeedViewClickedWithAliyunPVTopView:(AliyunPlayerViewTopView *)topView{
    [self checkDelayHideMethod];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSpeedViewClickedWithAliyunControlView:)]) {
        [self.delegate onSpeedViewClickedWithAliyunControlView:self];
    }
}


#pragma mark - AliyunPVBottomViewDelegate
- (void)aliyunVodBottomView:(AliyunPlayerViewBottomView *)bottomView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event{
    switch (event) {
        case UIControlEventTouchDown:
        {
            //slider 手势按下时，不做隐藏操作
            self.isHiddenView = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
        }
            break;
        case UIControlEventValueChanged:
            {
                
            }
            break;
        case UIControlEventTouchUpInside:
            {
                //slider滑动结束后，
                self.isHiddenView = YES;
                [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
            }
            break;
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunControlView:dragProgressSliderValue:event:)]) {
        [self.delegate aliyunControlView:self dragProgressSliderValue:progressValue event:event];
    }
}

- (void)onClickedPlayButtonWithAliyunPVBottomView:(AliyunPlayerViewBottomView *)bottomView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
    [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedPlayButtonWithAliyunControlView:)]) {
        [self.delegate onClickedPlayButtonWithAliyunControlView:self];
    }
}

- (void)aliyunPVBottomView:(AliyunPlayerViewBottomView *)bottomView qulityButton:(UIButton *)qulityButton{
    if (!qulityButton.selected) {
        self.listView.hidden = NO;
        [self addSubview:self.listView];
    } else {
        [self.listView removeFromSuperview];
    }
}

- (void)onClickedfullScreenButtonWithAliyunPVBottomView:(AliyunPlayerViewBottomView *)bottomView {
    [self.listView removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedfullScreenButtonWithAliyunControlView:)]) {
        [self.delegate onClickedfullScreenButtonWithAliyunControlView:self];
    }
}


#pragma mark - AliyunPVGestureViewDelegate
- (void)onSingleClickedWithAliyunPVGestureView:(AliyunPlayerViewGestureView *)gestureView {
    //单击界面 显示时，快速隐藏；隐藏时，快速展示，并延迟5秒后隐藏
    [self checkDelayHideMethod];
}

- (void)onDoubleClickedWithAliyunPVGestureView:(AliyunPlayerViewGestureView *)gestureView {
    [self.bottomView playButtonClicked:nil];
}

- (void)horizontalOrientationMoveOffset:(float)moveOffset{
    UISwipeGestureRecognizerDirection direction = UISwipeGestureRecognizerDirectionLeft;
    if (moveOffset >= 0) {
        direction = UISwipeGestureRecognizerDirectionRight;
    }
    float x =  moveOffset;
    double duration = self.duration;
    float width = self.bounds.size.width;
    double seekTime = self.currentTime;
    
    if (duration > 3600) {
        seekTime += x / width * duration * 0.1;
    } else if (1800 < duration && duration <= 3600) {
        seekTime += x / width * duration * 0.2;
    } else if (600 < duration && duration <= 1800) {
        seekTime += x / width * duration * 0.34;
    } else if (240 < duration && duration <= 600) {
        seekTime += x / width * duration * 0.5;
    } else {
        seekTime += x / width * duration;
    }
    if (seekTime < 0) {
        seekTime = 0;
    } else if (seekTime > duration) {
        seekTime = duration;
    }

    [self.guestureView setSeekTime:seekTime direction:direction];
    
    self.bottomView.progress = seekTime/duration;
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunControlView:dragProgressSliderValue:event:)]) {
        [self.delegate aliyunControlView:self dragProgressSliderValue:seekTime/duration event:UIControlEventTouchUpInside];
    }
}

#pragma mark - AliyunPVQualityListViewDelegate
- (void)qualityListViewOnItemClick:(int)index {
//    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
//    NSArray *ary = [AliyunUtil allQualities];
//    [self.bottomView.qualityButton setTitle:ary[index] forState:UIControlStateNormal];
//
    self.bottomView.qualityButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(aliyunControlView:qualityListViewOnItemClick:)]) {
        [self.delegate aliyunControlView:self qualityListViewOnItemClick:index];
    }
}

- (void)setQualityButtonTitle:(NSString *)title{
//    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
    [self.bottomView.qualityButton setTitle:title forState:UIControlStateNormal];
    self.bottomView.qualityButton.selected = NO;
}


- (void)qualityListViewOnDefinitionClick:(NSString*)videoDefinition {
    self.bottomView.qualityButton.selected = !self.bottomView.qualityButton.isSelected;
    [self.bottomView.qualityButton setTitle:videoDefinition forState:UIControlStateNormal];
}

#pragma mark - public method

- (void)updateViewWithPlayerState:(AliyunVodPlayerState)state isScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    if (state == AliyunVodPlayerStateIdle || state == AliyunVodPlayerStateLoading) {
        [self.guestureView setEnableGesture:NO];
    }else{
        [self.guestureView setEnableGesture:YES];
    }
    
    if (isScreenLocked || fixedPortrait) {
        [self.guestureView setEnableGesture:NO];
    }

    [self.bottomView updateViewWithPlayerState: state];
    
}

/*
 * 功能 ：更新进度条
 */
- (void)updateProgressWithCurrentTime:(NSTimeInterval)currentTime durationTime : (NSTimeInterval)durationTime{
    self.currentTime = currentTime;
    self.duration = durationTime;
    [self.bottomView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
}

- (void)updateCurrentTime:(NSTimeInterval)currentTime durationTime:(NSTimeInterval)durationTime{
    self.currentTime = currentTime;
    self.duration = durationTime;
    [self.bottomView updateCurrentTime:currentTime durationTime:durationTime];
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality{
    [self.listView setCurrentQuality:quality];
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition{
    [self.listView setCurrentDefinition:videoDefinition];
}

/*
 * 功能 ：是否禁用手势（双击、滑动)
 */
- (void)setEnableGesture:(BOOL)enableGesture{
    [self.guestureView setEnableGesture:enableGesture];
}

/*
 * 功能 ：隐藏topView、bottomView
 */
- (void)hiddenView{
    self.isHiddenView = YES;
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    self.listView.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayHideControlLayer) object:nil];
}

/*
 * 功能 ：展示topView、bottomView
 */
- (void)showView{
    self.isHiddenView = NO;
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    
    if ([AliyunUtil isInterfaceOrientationPortrait]) {
        self.listView.hidden = YES;
    }else{
        self.listView.hidden = !self.bottomView.qualityButton.selected;
    }
    
    [self performSelector:@selector(delayHideControlLayer) withObject:nil afterDelay:5];
}

- (void)delayHideControlLayer{
    [self hiddenView];
}

- (void)checkDelayHideMethod{
    if (self.isHiddenView) {
        [self showView];
    }else{
        [self hiddenView];
    }
}

/*
 * 功能 ：锁屏
 */
- (void)lockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait{
    [self.bottomView lockScreenWithIsScreenLocked:isScreenLocked fixedPortrait:fixedPortrait];
    if (!isScreenLocked) {
//        [self.lockButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_left_unlock"] forState:UIControlStateNormal];
         [self.lockButton setImage:[UIImage imageNamed:@"alivc_unlock"] forState:UIControlStateNormal];
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        self.listView.hidden= NO;
        [self setEnableGesture:YES];
    }else{
//        [self.lockButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"al_left_lock"] forState:UIControlStateNormal];
        [self.lockButton setImage:[UIImage imageNamed:@"alivc_lock"] forState:UIControlStateNormal];
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.listView.hidden= YES;
        [self setEnableGesture:NO];
    }
}

/*
 * 功能 ：取消锁屏
 */
- (void)cancelLockScreenWithIsScreenLocked:(BOOL)isScreenLocked fixedPortrait:(BOOL)fixedPortrait {
    if (isScreenLocked||fixedPortrait) {
        [self.bottomView cancelLockScreenWithIsScreenLocked:isScreenLocked fixedPortrait:fixedPortrait];
        [self.lockButton setImage:[UIImage imageNamed:@"alivc_unlock"] forState:UIControlStateNormal];
        self.lockButton.selected = NO;
        self.topView.hidden = NO;
        self.listView.hidden= NO;
        [self setEnableGesture:YES];
    }
}


@end
