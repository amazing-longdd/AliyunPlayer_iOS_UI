
#import "AliyunPlayerViewGestureView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AliyunPrivateDefine.h"
#import "AliyunPlayerViewSeekPopupView.h"
#import "AliyunGestureModel.h"

static const CGFloat ALYPVGestureViewBrightImageViewWidth        = 125;    //亮度view宽度
static const CGFloat ALYPVGestureViewBrightProgressHeight        = 20;     //亮度进度条高度
static const CGFloat ALYPVGestureViewBrightProgressLeft          = 15;     //亮度进度条 相对父试图左侧距离
static const CGFloat ALYPVGestureViewBrightProgressBottom        = 10;     //亮度进度条 距离父视图底边距离

@interface AliyunPlayerViewGestureView ()<UIGestureRecognizerDelegate,ALYPVGestureModelDelegate>
/*
 * 功能 ： 声音
 */
@property (nonatomic, assign) float systemVolume;

/*
 * 功能 ： 亮度
 */
@property (nonatomic, assign) float systemBrightness;

/*
 * 功能 ： 声音设置
 */
@property (nonatomic, strong) MPMusicPlayerController *musicPlayer;

/*
 * 功能 ：亮度
 */
@property (nonatomic, strong) UIImageView *brightImageView;
@property (nonatomic, strong) UIProgressView *brightProgress;

/*
 * 功能 ：前进、后退
 */
@property (nonatomic, strong) AliyunPlayerViewSeekPopupView *seekView;

/*
 * 功能 ：手势
 */
@property (nonatomic, strong) AliyunGestureModel *gestureModel;


@end

@implementation AliyunPlayerViewGestureView

#pragma mark - 懒加载
- (MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    }
    return _musicPlayer;
}

- (UIImageView *)brightImageView{
    if (!_brightImageView) {
        _brightImageView = [[UIImageView alloc] init];
        _brightImageView.alpha = 0.0;
    }
    return _brightImageView;
}

- (UIProgressView *)brightProgress{
    if (!_brightProgress) {
        _brightProgress = [[UIProgressView alloc] init];
        _brightProgress.backgroundColor = [UIColor clearColor];
        _brightProgress.trackTintColor = [UIColor blackColor];
        _brightProgress.progressTintColor = [UIColor whiteColor];
        _brightProgress.progress = [UIScreen mainScreen].brightness;
        _brightProgress.transform = CGAffineTransformMakeScale(1.0f,2.0f);
    }
    return _brightProgress;
}

- (AliyunPlayerViewSeekPopupView *)seekView{
    if (!_seekView) {
        _seekView = [[AliyunPlayerViewSeekPopupView alloc] init];
    }
    return _seekView;
}

- (AliyunGestureModel *)gestureModel{
    if (!_gestureModel) {
        _gestureModel = [[AliyunGestureModel alloc] init];
    }
    return _gestureModel;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.brightImageView.image = [UIImage imageNamed:@"al_video_brightness_bg"];
        [self addSubview:self.brightImageView];
        [self.brightImageView addSubview:self.brightProgress];
        
        [self.gestureModel setView: self];
        self.gestureModel.delegate = self;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    self.brightImageView.frame = CGRectMake((SCREEN_HEIGHT-ALYPVGestureViewBrightImageViewWidth)/2,(SCREEN_WIDTH-ALYPVGestureViewBrightImageViewWidth)/2, ALYPVGestureViewBrightImageViewWidth, ALYPVGestureViewBrightImageViewWidth);
    self.brightImageView.center = CGPointMake(width/2, height/2);
    self.brightProgress.frame = CGRectMake(ALYPVGestureViewBrightProgressLeft,self.brightImageView.frame.size.height-ALYPVGestureViewBrightProgressBottom,self.brightImageView.frame.size.width-2*ALYPVGestureViewBrightProgressLeft,ALYPVGestureViewBrightProgressHeight);
}


- (void)setEnableGesture:(BOOL)enableGesture {
    [self.gestureModel setEnableGesture:enableGesture];
}

- (void)setSeekTime:(NSTimeInterval)time direction : (UISwipeGestureRecognizerDirection)direction{
    [self.seekView setSeekTime:time direction:direction];
}

#pragma mark - private method
- (void)setBrightnessUp{
    if ([UIScreen mainScreen].brightness >=1) {
        return;
    }
    [UIScreen mainScreen].brightness += 0.01;
    self.brightImageView.alpha = 1.0f;
    self.brightProgress.progress = [UIScreen mainScreen].brightness;
}

- (void)setBrightnessDown{
    if ([UIScreen mainScreen].brightness <=0) {
        return;
    }
    [UIScreen mainScreen].brightness -= 0.01;
    self.brightImageView.alpha = 1.0f;
    self.brightProgress.progress = [UIScreen mainScreen].brightness;
}

- (void)setVolumeUp{
    self.systemVolume = self.musicPlayer.volume;
    if (self.musicPlayer.volume >=1) {
        return;
    }
    self.systemVolume = _systemVolume+0.01;
    [self.musicPlayer setVolume:_systemVolume];
    self.musicPlayer.volume += 0.01;
}

- (void)setVolumeDown{
    self.systemVolume = self.musicPlayer.volume;
    if (_systemVolume <=0) {
        return;
    }
    self.systemVolume = self.systemVolume-0.01;
    [self.musicPlayer setVolume:self.systemVolume];
}

#pragma mark - delegate
-(void)aliyunGestureModel:(AliyunGestureModel *)aliyunGestureModel state:(UIGestureRecognizerState)state moveOrientation:(ALYPVOrientation)moveOrientation{
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (moveOrientation == ALYPVOrientationHorizontal) {
                if (self.seekView.superview == nil) {
                    [self.seekView showWithParentView:self];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:{
            if (moveOrientation == ALYPVOrientationVertical) {
                [UIView animateWithDuration:0.5f animations:^{
                    self.brightImageView.alpha =0.0f;
                }];
            }
            [self.seekView dismiss];
            break;
        }
        default:
            break;
    }
}

- (void)aliyunGestureModel:(AliyunGestureModel *)aliyunGestureModel volumeDirection:(UISwipeGestureRecognizerDirection)direction{
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        [self setVolumeUp];
    }else if (direction == UISwipeGestureRecognizerDirectionDown){
        [self setVolumeDown];
    }
}

- (void)aliyunGestureModel:(AliyunGestureModel *)aliyunGestureModel brightnessDirection:(UISwipeGestureRecognizerDirection)direction{
    if (direction == UISwipeGestureRecognizerDirectionUp) {
        [self setBrightnessUp];
    }else if (direction == UISwipeGestureRecognizerDirectionDown){
        [self setBrightnessDown];
    }
}

- (void)horizontalOrientationMoveOffset:(float)moveOffset {
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalOrientationMoveOffset:)]) {
        [self.delegate horizontalOrientationMoveOffset:moveOffset];
    }
}

- (void)onDoubleClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDoubleClickedWithAliyunPVGestureView:)]) {
        [self.delegate onDoubleClickedWithAliyunPVGestureView:self];
    }
}

- (void)onSingleClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSingleClickedWithAliyunPVGestureView:)]) {
        [self.delegate onSingleClickedWithAliyunPVGestureView:self];
    }
}

@end
