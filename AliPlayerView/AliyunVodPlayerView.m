//
//  AliyunVodPlayerView.m
//  AliyunVodPlayerViewSDK
//
//  Created by SMY on 16/9/8.
//  Copyright © 2016年 SMY. All rights reserved.
//

#import "AliyunVodPlayerView.h"

//public
#import "AliyunPrivateDefine.h"
#import "AliyunReachability.h"

//data
#import "AliyunDataSource.h"

#import "AliyunViewMoreView.h"
#import "AliyunPlayerViewControlView.h"
#import "AliyunPlayerViewFirstStartGuideView.h"
//tipsView
#import "AliyunPlayerViewPopLayer.h"
#import "AliyunPlayerViewErrorView.h"
#import "MBProgressHUD+AlivcHelper.h"

//loading
#import "AlilyunViewLoadingView.h"

#import "NSString+AlivcHelper.h"

#define PLAY_VIEW @"playView"


static const CGFloat AlilyunViewLoadingViewWidth  = 130;
static const CGFloat AlilyunViewLoadingViewHeight = 120;

@interface AliyunVodPlayerView () <AliyunVodPlayerDelegate,AliyunPVPopLayerDelegate,AliyunControlViewDelegate,AliyunViewMoreViewDelegate>

#pragma mark - view
@property (nonatomic, strong) UIButton *downloadButton;               //下载按钮
@property (nonatomic, strong) AliyunVodPlayer *aliPlayer;               //点播播放器
@property (nonatomic, strong) UIImageView *coverImageView;              //封面
@property (nonatomic, strong) AliyunPlayerViewControlView *controlView;
@property (nonatomic, strong) AliyunViewMoreView *moreView;             //更多界面
@property (nonatomic, strong) AliyunPlayerViewFirstStartGuideView *guideView;     //导航
@property (nonatomic, strong) AliyunPlayerViewPopLayer *popLayer;               //弹出的提示界面
@property (nonatomic, strong) AlilyunViewLoadingView *loadingView;         //loading
@property (nonatomic, strong) AlilyunViewLoadingView *qualityLoadingView;  //清晰度loading

#pragma mark - data
@property (nonatomic, strong) AliyunReachability *reachability;       //网络监听
@property (nonatomic, assign) CGRect saveFrame;                         //记录竖屏时尺寸,横屏时为全屏状态。
@property (nonatomic ,assign) ALYPVPlayMethod playMethod; //播放方式
@property (nonatomic, weak  ) NSTimer *timer;                           //计时器
@property (nonatomic, assign) NSTimeInterval currentDuration;           //记录播放时长
@property (nonatomic, copy  ) NSString *currentMediaTitle;              //设置标题，如果用户已经设置自己标题，不在启用请求获取到的视频标题信息。
@property (nonatomic, assign) BOOL isProtrait;                          //是否是竖屏
@property (nonatomic, assign) BOOL isRerty;                             //default：NO
@property (nonatomic, assign) float saveCurrentTime;                    //保存重试之前的播放时间
@property (nonatomic, assign) BOOL mProgressCanUpdate;                  //进度条是否更新，默认是NO


#pragma mark - 播放方式
@property (nonatomic, strong) AliyunLocalSource *localSource;   //url 播放方式
@property (nonatomic, strong) AliyunPlayAuthModel *playAuthModel;    //vid+playAuth 播放方式
@property (nonatomic, strong) AliyunSTSModel *stsModel;              //vid+STS 播放方式
@property (nonatomic, strong) AliyunMPSModel *mpsModel;              //vid+MPS 播放方式

@property (nonatomic, assign) AliyunVodPlayerState currentPlayStatus; //记录播放器的状态
@end

@implementation AliyunVodPlayerView

#pragma mark - 懒加载
- (AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
    }
    return _aliPlayer;
}

- (AliyunVodPlayer *)getAliPlayer{
    return self.aliPlayer;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.backgroundColor = [UIColor clearColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (AliyunPlayerViewControlView *)controlView{
    if (!_controlView) {
        _controlView = [[AliyunPlayerViewControlView alloc] init];
    }
    return _controlView;
}

- (AliyunViewMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[AliyunViewMoreView alloc] init];
    }
    return  _moreView;
}
- (AliyunPlayerViewPopLayer *)popLayer{
    if (!_popLayer) {
        _popLayer = [[AliyunPlayerViewPopLayer alloc] init];
        _popLayer.frame = self.bounds;
        _popLayer.hidden = YES;
    }
    return _popLayer;
}

- (AlilyunViewLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[AlilyunViewLoadingView alloc] init];
    }
    return _loadingView;
}

- (AlilyunViewLoadingView *)qualityLoadingView{
    if (!_qualityLoadingView) {
        _qualityLoadingView = [[AlilyunViewLoadingView alloc] init];
    }
    return _qualityLoadingView;
}

#pragma mark - init
- (instancetype)init{
    _mProgressCanUpdate = NO;
    return [self initWithFrame:CGRectZero];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    //指记录竖屏时界面尺寸
    if ([AliyunUtil isInterfaceOrientationPortrait]){
        if (!self.fixedPortrait) {
            self.saveFrame = frame;
        }
    }
}

- (void)setViewSkin:(AliyunVodPlayerViewSkin)viewSkin{
    _viewSkin = viewSkin;
    self.controlView.skin = viewSkin;
    self.guideView.skin = viewSkin;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame andSkin:AliyunVodPlayerViewSkinBlue];
}

//初始化view
- (void)initView{
    
    self.aliPlayer.delegate = self;
    [self addSubview:self.aliPlayer.playerView];
    
    [self addSubview:self.coverImageView];
    
    self.controlView.delegate = self;
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    [self addSubview:self.controlView];
    
    self.moreView.delegate = self;
    [self addSubview:self.moreView];
    
    self.popLayer.delegate = self;
    [self addSubview:self.popLayer];
    [self addSubview:self.loadingView];
    [self addSubview:self.qualityLoadingView];
}



#pragma mark - 指定初始化方法
- (instancetype)initWithFrame:(CGRect)frame andSkin:(AliyunVodPlayerViewSkin)skin {
    self = [super initWithFrame:frame];
    if (self) {
        if ([AliyunUtil isInterfaceOrientationPortrait]){
            self.saveFrame = frame;
        }else{
            self.saveFrame = CGRectZero;
        }
        _mProgressCanUpdate = YES;
        //设置view
        [self initView];
        //加载控件皮肤
        self.viewSkin = skin;
        //屏幕旋转通知
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
         ];
        
        //网络状态判定
        _reachability = [AliyunReachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged)
                                                     name:AliyunPVReachabilityChangedNotification
                                                   object:nil];
        //存储第一次触发saas
        NSString *str =   [[NSUserDefaults standardUserDefaults] objectForKey:@"aliyunVodPlayerFirstOpen"];
        if (!str) {
            [[NSUserDefaults standardUserDefaults] setValue:@"aliyun_saas_first_open" forKey:@"aliyunVodPlayerFirstOpen"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return self;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;

    self.aliPlayer.playerView.frame = self.bounds;
    self.coverImageView.frame= self.bounds;
    self.controlView.frame = self.bounds;
    self.moreView.frame = self.bounds;
    self.guideView.frame =  self.bounds;
    self.popLayer.frame = self.bounds;
    self.popLayer.center = CGPointMake(width/2, height/2);
    
    float x = (self.bounds.size.width -  AlilyunViewLoadingViewWidth)/2;
    float y = (self.bounds.size.height - AlilyunViewLoadingViewHeight)/2;
    self.qualityLoadingView.frame = self.loadingView.frame = CGRectMake(x, y, AlilyunViewLoadingViewWidth, AlilyunViewLoadingViewHeight);
}


#pragma mark - 网络状态改变
- (void)reachabilityChanged{
//    [self networkChangedToShowPopView];
    //网络状态变化交由外界的vc处理
}

//网络状态判定
- (BOOL)networkChangedToShowPopView{
    BOOL ret = NO;
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunPVNetworkStatusNotReachable://由播放器底层判断是否有网络
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            if ([self.localSource isFileUrl]) {
                return NO;
            }
            if (self.aliPlayer.autoPlay) {
                self.aliPlayer.autoPlay = NO;
            }
            [self pause];
            [self unlockScreen];
            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUseMobileNetwork popMsg:nil];
            [_loadingView dismiss];
            [self.qualityLoadingView dismiss];
            NSLog(@"播放器展示4G提醒");
            ret = YES;
        }
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark - 屏幕旋转
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
    UIDevice *device = [UIDevice currentDevice] ;
    if (self.isScreenLocked) {
        return;
    }
    
//    switch (interfaceOrientation) {
//        case UIInterfaceOrientationUnknown:
//        case UIInterfaceOrientationPortraitUpsideDown:
//        {
//            
//        }
//            break;
//        case UIInterfaceOrientationPortrait:
//        {
//            if (self.saveFrame.origin.x == 0 && self.saveFrame.origin.y==0 && self.saveFrame.size.width == 0 && self.saveFrame.size.height == 0) {
//                //开始时全屏展示，self.saveFrame = CGRectZero, 旋转竖屏时做以下默认处理
//                CGRect tempFrame = self.frame ;
//                tempFrame.size.width = self.frame.size.height;
//                tempFrame.size.height = self.frame.size.height* 9/16;
//                self.frame = tempFrame;
//            }else{
//                self.frame = self.saveFrame;
//            }
//            [self.guideView removeFromSuperview];
//            if (self.delegate &&[self.delegate respondsToSelector:@selector(aliyunVodPlayerView:fullScreen:)]) {
//                [self.delegate aliyunVodPlayerView:self fullScreen:NO];
//            }
//        }
//            break;
//        case UIInterfaceOrientationLandscapeLeft:
//        case UIInterfaceOrientationLandscapeRight:
//        {
//            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"aliyunVodPlayerFirstOpen"];
//            if ([str isEqualToString:@"aliyun_saas_first_open"]) {
//                [[NSUserDefaults standardUserDefaults] setValue:@"aliyun_saas_no_first_open" forKey:@"aliyunVodPlayerFirstOpen"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                [self addSubview:self.guideView];
//            }
//            
//            if (self.delegate &&[self.delegate respondsToSelector:@selector(aliyunVodPlayerView:fullScreen:)]) {
//                [self.delegate aliyunVodPlayerView:self fullScreen:YES];
//            }
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortraitUpsideDown:
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"aliyunVodPlayerFirstOpen"];
            if ([str isEqualToString:@"aliyun_saas_first_open"]) {
                [[NSUserDefaults standardUserDefaults] setValue:@"aliyun_saas_no_first_open" forKey:@"aliyunVodPlayerFirstOpen"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self addSubview:self.guideView];
            }

            if (self.delegate &&[self.delegate respondsToSelector:@selector(aliyunVodPlayerView:fullScreen:)]) {
                [self.delegate aliyunVodPlayerView:self fullScreen:YES];
            }
        }
            break;
        case UIDeviceOrientationPortrait:
        {
            if (self.saveFrame.origin.x == 0 && self.saveFrame.origin.y==0 && self.saveFrame.size.width == 0 && self.saveFrame.size.height == 0) {
                //开始时全屏展示，self.saveFrame = CGRectZero, 旋转竖屏时做以下默认处理
                CGRect tempFrame = self.frame ;
                tempFrame.size.width = self.frame.size.height;
                tempFrame.size.height = self.frame.size.height* 9/16;
                self.frame = tempFrame;
            }else{
                self.frame = self.saveFrame;
               
            }
            //2018-6-28 cai
            BOOL isFullScreen = YES;
            if (self.frame.size.width > self.frame.size.height) {
                isFullScreen = NO;
            }
            if (self.delegate &&[self.delegate respondsToSelector:@selector(aliyunVodPlayerView:fullScreen:)]) {
                [self.delegate aliyunVodPlayerView:self fullScreen:isFullScreen];
            }
            [self.guideView removeFromSuperview];
            
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - dealloc
- (void)dealloc {
    if (_aliPlayer) {
        [self releasePlayer];
    }
}

#pragma mark - 封面设置
- (void)setCoverUrl:(NSURL *)coverUrl{
    _coverUrl = coverUrl;
    if (coverUrl) {
        if (self.coverImageView) {

            self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:coverUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.coverImageView.image = [UIImage imageWithData:data];
                    self.coverImageView.hidden = NO;
                    NSLog(@"播放器:展示封面");
                });
            });
        }
    }
}

#pragma mark - 清晰度
- (void)setQuality:(AliyunVodPlayerVideoQuality)quality{
    self.aliPlayer.quality = quality;
}
- (AliyunVodPlayerVideoQuality)quality{
    return self.aliPlayer.quality;
}
#pragma mark - MTS清晰度
- (void)setVideoDefinition:(NSString *)videoDefinition{
    self.aliPlayer.videoDefinition = videoDefinition;
}
- (NSString*)videoDefinition{
    return self.aliPlayer.videoDefinition;
}
#pragma mark - 缓冲的时长，毫秒
- (NSTimeInterval)bufferPercentage{
    return self.aliPlayer.bufferPercentage;
}
#pragma mark - 自动播放
- (void)setAutoPlay:(BOOL)autoPlay {
    [self.aliPlayer setAutoPlay:autoPlay];
}
#pragma mark - 循环播放
- (void)setCirclePlay:(BOOL)circlePlay{
    [self.aliPlayer setCirclePlay:circlePlay];
}
- (BOOL)circlePlay{
    return self.aliPlayer.circlePlay;
}
#pragma mark - 截图
- (UIImage *)snapshot{
    return  [self.aliPlayer snapshot];
}
#pragma mark - 浏览方式
- (void)setDisplayMode:(AliyunVodPlayerDisplayMode)displayMode{
    [self.aliPlayer setDisplayMode:displayMode];
}
- (void)setMuteMode:(BOOL)muteMode{
    [self.aliPlayer setMuteMode: muteMode];
}
#pragma mark - 是否正在播放中
- (BOOL)isPlaying{
    return [self.aliPlayer isPlaying];
}
#pragma mark - 播放总时长
- (NSTimeInterval)duration{
    return  [self.aliPlayer duration];
}
#pragma mark - 当前播放时长
- (NSTimeInterval)currentTime{
    return  [self.aliPlayer currentTime];
}
#pragma mark - 缓冲的时长，秒
- (NSTimeInterval)loadedTime{
    return  [self.aliPlayer loadedTime];
}
#pragma mark - 播放器宽度
- (int)videoWidth{
    return [self.aliPlayer videoWidth];
}
#pragma mark - 播放器高度
- (int)videoHeight{
    return [self.aliPlayer videoHeight];
}
#pragma mark - 设置绝对竖屏
- (void)setFixedPortrait:(BOOL)fixedPortrait{
    _fixedPortrait = fixedPortrait;
    if(fixedPortrait){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }else{
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDeviceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil
         ];
    }
}

#pragma mark - timeout
- (void)setTimeout:(int)timeout{
    [self.aliPlayer setTimeout:timeout];
}
- (int)timeout{
    return  self.aliPlayer.timeout;
}

/****************推荐播放方式*******************/
- (void)playDataSourcePropertySetEmpty{
    //保证仅存其中一种播放参数
    self.localSource = nil;
    self.playAuthModel = nil;
    self.stsModel = nil;
    self.mpsModel = nil;
}

#pragma mark - url
- (void)playViewPrepareWithURL:(NSURL *)url{
    [self playDataSourcePropertySetEmpty];
    self.localSource = [[AliyunLocalSource alloc] init];
    self.localSource.url = url;

    self.playMethod = ALYPVPlayMethodUrl;
    self.controlView.playMethod = ALYPVPlayMethodUrl;
    
    if ([self networkChangedToShowPopView]) {
        return;
    }
    
    [_loadingView show];
    [self.aliPlayer prepareWithURL:url];
    NSLog(@"播放器prepareWithURL");
}

- (void)playViewPrepareWithLocalURL:(NSURL *)url{
    [self playDataSourcePropertySetEmpty];
    self.localSource = [[AliyunLocalSource alloc] init];
    self.localSource.url = url;
    
    self.playMethod = ALYPVPlayMethodUrl; //本界面本地url播放和url播放统一处理
    self.controlView.playMethod = ALYPVPlayMethodLocal;
    [_loadingView show];
    self.aliPlayer.autoPlay = YES;
    [self.aliPlayer prepareWithURL:url];
}

#pragma mark - vid+playauth
- (void)playViewPrepareWithVid:(NSString *)vid playAuth : (NSString *)playAuth{
    
    [self playDataSourcePropertySetEmpty];
    self.playAuthModel = [[AliyunPlayAuthModel alloc] init];
    self.playAuthModel.videoId = vid;
    self.playAuthModel.playAuth = playAuth;
    
    self.playMethod = ALYPVPlayMethodPlayAuth;
    self.controlView.playMethod = ALYPVPlayMethodPlayAuth;
    if ([self networkChangedToShowPopView]) {
        return;
    }
    
    [_loadingView show];
    [self.aliPlayer prepareWithVid:vid playAuth:playAuth];
    NSLog(@"播放器playAuth");
}

#pragma mark - 临时ak
- (void)playViewPrepareWithVid:(NSString *)vid
                   accessKeyId:(NSString *)accessKeyId
               accessKeySecret:(NSString *)accessKeySecret
                 securityToken:(NSString *)securityToken {
    [self playDataSourcePropertySetEmpty];
    self.stsModel = [[AliyunSTSModel alloc] init];
    self.stsModel.videoId = vid;
    self.stsModel.accessKeyId = accessKeyId;
    self.stsModel.accessSecret = accessKeySecret;
    self.stsModel.ststoken = securityToken;
    self.playMethod = ALYPVPlayMethodSTS;
    self.controlView.playMethod = ALYPVPlayMethodSTS;
    if ([self networkChangedToShowPopView]) {
        return;
    }
    
    [_loadingView show];
    [self.aliPlayer prepareWithVid:vid accessKeyId:accessKeyId accessKeySecret:accessKeySecret securityToken:securityToken];
    NSLog(@"播放器securityToken");
}



#pragma mark - 媒体处理
- (void)playViewPrepareWithVid:(NSString *)vid
                     accessId : (NSString *)accessId
                 accessSecret : (NSString *)accessSecret
                     stsToken : (NSString *)stsToken
                     autoInfo : (NSString *)autoInfo
                       region : (NSString *)region
                   playDomain : (NSString *)playDomain
                mtsHlsUriToken:(NSString *)mtsHlsUriToken{
    self.playMethod = ALYPVPlayMethodMPS;
    self.controlView.playMethod = ALYPVPlayMethodMPS;
    [self playDataSourcePropertySetEmpty];
    self.mpsModel = [[AliyunMPSModel alloc] init];
    self.mpsModel.videoId = vid;
    self.mpsModel.accessKey = accessId;
    self.mpsModel.accessSecret = accessSecret;
    self.mpsModel.stsToken = stsToken;
    self.mpsModel.authInfo = autoInfo;
    self.mpsModel.region = region;
    self.mpsModel.playDomain = playDomain;
    self.mpsModel.hlsUriToken = mtsHlsUriToken;
    
    if ([self networkChangedToShowPopView]) {
        return;
    }
    
    [_loadingView show];
    [self.aliPlayer prepareWithVid:vid
                             accId:accessId
                         accSecret:accessSecret
                          stsToken:stsToken
                          authInfo:autoInfo
                            region:region
                        playDomain:playDomain
                    mtsHlsUriToken:mtsHlsUriToken ];
    NSLog(@"播放器mtsHlsUriToken");
}

/*******************************************/
#pragma mark - playManagerAction
- (void)start {
    [self.aliPlayer start];
    NSLog(@"播放器start");
}

- (void)pause{
    [self.aliPlayer pause];
    NSLog(@"播放器pause");
}

- (void)resume{
    [self.aliPlayer resume];
    if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:onResume:)]) {
        NSTimeInterval time = self.aliPlayer.currentTime;
        [self.delegate aliyunVodPlayerView:self onResume:time];
    }
    NSLog(@"播放器resume");
}

- (void)stop {
    [self.aliPlayer stop];
    NSLog(@"播放器stop");
}

- (void)replay{
    [self.aliPlayer replay];
    NSLog(@"播放器replay");
}

- (void)reset{
    [self.aliPlayer reset];
    NSLog(@"播放器reset");
}

- (void)releasePlayer {
    [_reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliyunPVReachabilityChangedNotification object:self.aliPlayer];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (_aliPlayer) {
        [_aliPlayer releasePlayer];
        _aliPlayer = nil;
    }
    //开启休眠
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

#pragma mark - 播放器当前状态
- (AliyunVodPlayerState)playerViewState {
    return _currentPlayStatus;
}

#pragma mark - 媒体信息
- (AliyunVodPlayerVideo *)getAliyunMediaInfo{
    return  [self.aliPlayer getAliyunMediaInfo];
}

#pragma mark - 边播边下判定
- (void) setPlayingCache:(BOOL)bEnabled saveDir:(NSString*)saveDir maxSize:(int64_t)maxSize maxDuration:(int)maxDuration{
    [self.aliPlayer setPlayingCache:bEnabled saveDir:saveDir maxSize:maxSize maxDuration:maxDuration];
}

#pragma mark - AliyunVodPlayerDelegate

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    NSLog(@"播放器事件回调:事件%ld,播放器状态:%ld",(long)event,(long)vodPlayer.playerState);
    //接收onEventCallback回调时，根据当前播放器事件更新UI播放器UI数据
    [self updateVodPlayViewDataWithEvent:event vodPlayer:vodPlayer];
    if(event == AliyunVodPlayerEventPlay || event == AliyunVodPlayerEventPrepareDone){
        //让错误的提示消失
        [self.loadingView dismiss];
        self.popLayer.hidden = YES;
    }
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    //取消屏幕锁定旋转状态
    [self unlockScreen];
    //关闭loading动画
    [_loadingView dismiss];
    
    //根据播放器状态处理seek时thumb是否可以拖动
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    //根据错误信息，展示popLayer界面
    [self showPopLayerWithErrorModel:errorModel];
    if(self.printLog) {
        NSLog(@" errorCode:%d errorMessage:%@",errorModel.errorCode,errorModel.errorMsg);
    }
}

- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer newPlayerState:(AliyunVodPlayerState)newState{
    _currentPlayStatus = newState;
    NSString *playStatusString = @"other";
    if (newState == AliyunVodPlayerStatePause) {
        playStatusString = @"暂停";
    }
    if (newState == AliyunVodPlayerStatePlay) {
        playStatusString = @"播放";
    }
    NSLog(@"播放器状态更新：%@",playStatusString);
    //更新UI状态
    [self.controlView updateViewWithPlayerState:_currentPlayStatus isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer willSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition {
    [self.qualityLoadingView show];
    self.mProgressCanUpdate = NO;
    //根据状态设置 controllayer 清晰度按钮 可用？
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    
    NSArray *ary = [AliyunUtil allQualities];
    [self.controlView setQualityButtonTitle:ary[quality]];
    //选中切换
    [self.controlView.listView setCurrentQuality:quality];
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer didSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition {
    [self.qualityLoadingView dismiss];
    self.mProgressCanUpdate = YES;
    
    NSArray *ary = [AliyunUtil allQualities];
    [self.controlView setQualityButtonTitle:ary[quality]];
    //选中切换
    [self.controlView.listView setCurrentQuality:quality];
    NSString *showString = [NSString stringWithFormat:@"已为你切换至%@",[AliyunVodPlayerView stringWithQuality:quality]];
    [MBProgressHUD showMessage:showString inView:self];
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition {
    [self.qualityLoadingView dismiss];
    [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeLoadDataError popMsg:nil];
    [self unlockScreen];
    
    NSArray *ary = [AliyunUtil allQualities];
    [self.controlView setQualityButtonTitle:ary[quality]];
    //选中切换
    [self.controlView.listView setCurrentQuality:quality];
}

- (void)onCircleStartWithVodPlayer:(AliyunVodPlayer *)vodPlayer{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onCircleStartWithVodPlayerView:)]) {
        [self.delegate onCircleStartWithVodPlayerView:self];
    }
}

- (void)onTimeExpiredErrorWithVodPlayer:(AliyunVodPlayer *)vodPlayer {
    //取消屏幕锁定旋转状态
    [self unlockScreen];
    //关闭loading动画
    [_loadingView dismiss];
    //根据播放器状态处理seek时thumb是否可以拖动
    [self.controlView updateViewWithPlayerState:self.aliPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    //根据错误信息，展示popLayer界面
    NSBundle *resourceBundle = [AliyunUtil languageBundle];
    AliyunPlayerVideoErrorModel *errorModel = [[AliyunPlayerVideoErrorModel alloc] init];
    errorModel.errorCode = ALIVC_ERR_AUTH_EXPIRED;
    errorModel.errorMsg = NSLocalizedStringFromTableInBundle(@"ALIVC_ERR_AUTH_EXPIRED", nil, resourceBundle, nil);
    [self showPopLayerWithErrorModel:errorModel];
    if(self.printLog) {
        NSLog(@" errorCode:%d errorMessage:%@",errorModel.errorCode,errorModel.errorMsg);
    }
}

- (void)vodPlayerPlaybackAddressExpiredWithVideoId:(NSString *)videoId quality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString *)videoDefinition{
    NSLog(@"播放地址过期");
}


#pragma mark - popdelegate
- (void)showPopViewWithType:(ALYPVErrorType)type{
    self.popLayer.hidden = YES;
    switch (type) {
        case ALYPVErrorTypeReplay:
            {
                //重播
                [self.aliPlayer replay];
                [self.aliPlayer seekToTime:self.saveCurrentTime];
            }
            break;
        case ALYPVErrorTypeRetry:
            {
                [self stop];
                if (self.aliPlayer.autoPlay == NO) {
                    self.aliPlayer.autoPlay = YES;
                }
                //重试播放
                if ([self networkChangedToShowPopView]) {
                    return;
                }
                [self updatePlayDataReplayWithPlayMethod:self.playMethod];
                
//                //记录事件和时间
//                self.isRerty = YES;
//                self.saveCurrentTime = self.aliPlayer.currentTime;
            }
            break;
        case ALYPVErrorTypePause:
            {
                if (self.aliPlayer.playerState == AliyunVodPlayerStatePause){
                    [self.aliPlayer resume];
                } else {
                    if (self.aliPlayer.autoPlay == NO) {
                        self.aliPlayer.autoPlay = YES;
                    }
                    
                    [self updatePlayDataReplayWithPlayMethod:self.playMethod];
                }
            }
            break;
        default:
            break;
    }
}

/*
 * 功能 ：播放器
 * 参数 ：playMethod 播放方式
 */
- (void)updatePlayDataReplayWithPlayMethod:(ALYPVPlayMethod) playMethod{
    switch (playMethod) {
        case ALYPVPlayMethodUrl:
        {
            [self.aliPlayer prepareWithURL:self.localSource.url];
        }
            break;
        case ALYPVPlayMethodMPS:
        {
            [self.aliPlayer prepareWithVid:self.mpsModel.videoId
                                     accId:self.mpsModel.accessKey
                                 accSecret:self.mpsModel.accessSecret
                                  stsToken:self.mpsModel.stsToken
                                  authInfo:self.mpsModel.authInfo
                                    region:self.mpsModel.region
                                playDomain:self.mpsModel.playDomain
                            mtsHlsUriToken:self.mpsModel.hlsUriToken];
        }
            break;
        case ALYPVPlayMethodPlayAuth:
        {
            [self.aliPlayer prepareWithVid:self.playAuthModel.videoId
                                  playAuth:self.playAuthModel.playAuth];
        }
            break;
        case ALYPVPlayMethodSTS:
        {
            [self.aliPlayer prepareWithVid:self.stsModel.videoId
                               accessKeyId:self.stsModel.accessKeyId
                           accessKeySecret:self.stsModel.accessSecret
                             securityToken:self.stsModel.ststoken];
        }
            break;
        default:
            break;
    }
}

- (void)onBackClickedWithAlPVPopLayer:(AliyunPlayerViewPopLayer *)popLayer{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithAliyunVodPlayerView:)]){
        [self.delegate onBackViewClickWithAliyunVodPlayerView:self];
    }else{
        [self stop];
    }
}

#pragma mark - timerRun
- (void)timerRun{
    if (self.aliPlayer && self.mProgressCanUpdate) {
        NSTimeInterval loadTime = self.aliPlayer.loadedTime;
        float changeLoadTime = (self.currentDuration == 0) ?: (loadTime / self.currentDuration);
        NSTimeInterval currentTime = self.aliPlayer.currentTime;
        NSTimeInterval durationTime = self.aliPlayer.duration;
        AliyunVodPlayerState state = (AliyunVodPlayerState)self.aliPlayer.playerState;
        self.controlView.state = state;
        self.controlView.loadTimeProgress = changeLoadTime;
        if (self.aliPlayer.currentTime > 0) {
            self.saveCurrentTime = self.aliPlayer.currentTime;
        }
        
        NSLog(@"播放时间记录:%0.2f",self.saveCurrentTime);
        if (state == AliyunVodPlayerStatePlay || state == AliyunVodPlayerStatePause) {
//            if(self.isRerty){
//                [self.aliPlayer seekToTime:self.saveCurrentTime];
//                self.isRerty = NO;
//                return;
//            }
            [self.controlView updateProgressWithCurrentTime:currentTime durationTime:durationTime];
        }
    }
}

#pragma mark - 暂不开放该接口
- (void)setTitle:(NSString *)title {
    self.currentMediaTitle = title;
}

#pragma mark - loading动画
- (void)loadAnimation {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.5;
    [self.layer addAnimation:animation forKey:nil];
}

//取消屏幕锁定旋转状态
- (void)unlockScreen{
    //弹出错误窗口时 取消锁屏。
    if (self.delegate &&[self.delegate respondsToSelector:@selector(aliyunVodPlayerView:lockScreen:)]) {
        if (self.isScreenLocked == YES||self.fixedPortrait) {
            [self.delegate aliyunVodPlayerView:self lockScreen:NO];
            //弹出错误窗口时 取消锁屏。
            [self.controlView cancelLockScreenWithIsScreenLocked:self.isScreenLocked fixedPortrait:self.fixedPortrait];
            self.isScreenLocked = NO;
        }
    }
}

/**
 * 功能：声音调节,调用系统MPVolumeView类实现，并非视频声音;volume(0~1.0)
 */
- (void)setVolume:(float)volume{
    [self.aliPlayer setVolume:volume];
}

/**
 * 功能：亮度,调用brightness系统属性，brightness(0~1.0)
 */
- (void)setBrightness :(float)brightness{
    [self.aliPlayer setBrightness:brightness];
}

#pragma mark - 版本号
- (NSString*) getSDKVersion{
    return [self.aliPlayer getSDKVersion];
}

/**
 * 功能：
 * 参数：设置渲染视图角度
 */
- (void) setRenderRotate:(RenderRotate)rotate{
    [self.aliPlayer setRenderRotate:rotate];
}

/**
 * 功能：
 * 参数：设置渲染镜像
 */
- (void) setRenderMirrorMode:(RenderMirrorMode)mirrorMode{
    [self.aliPlayer setRenderMirrorMode:mirrorMode];
}

/**
 * 功能：
 * 参数：block:音频数据回调
 *
 */
- (void) getAudioData:(void (^)(NSData *data))block{
    [self.aliPlayer getAudioData:block];
}

#pragma mark - 设置提示语
- (void)setPlayFinishDescribe:(NSString *)des{
    [AliyunUtil setPlayFinishTips:des];
}

- (void)setNetTimeOutDescribe:(NSString *)des{
    [AliyunUtil setNetworkTimeoutTips:des];
}

- (void)setNoNetDescribe:(NSString *)des{
    [AliyunUtil setNetworkUnreachableTips:des];
}
- (void)setLoaddataErrorDescribe:(NSString *)des{
    [AliyunUtil setLoadingDataErrorTips:des];
}
- (void)setUseWanNetDescribe:(NSString *)des{
    [AliyunUtil setSwitchToMobileNetworkTips:des];
}

#pragma mark - public method
/*
 * 功能 ： 接收onEventCallback回调时，根据当前播放器事件更新UI播放器UI数据
 * 参数：
 */
- (void)updateVodPlayViewDataWithEvent:(AliyunVodPlayerEvent)event vodPlayer:(AliyunVodPlayer *)vodPlayer{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:happen:)]){
        [self.delegate aliyunVodPlayerView:self happen:event];
    }
    [self.controlView updateViewWithPlayerState:vodPlayer.playerState isScreenLocked:self.isScreenLocked fixedPortrait:self.isProtrait];
    
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
        {
            //关闭loading动画
            [_loadingView dismiss];
            
            //保存获取的的播放器信息 ，需要优化。
            self.currentDuration = vodPlayer.duration;
            
            //更新controlLayer界面ui数据
            if (self.playMethod == ALYPVPlayMethodUrl) {
                [self updateControlLayerDataWithMediaInfo:nil];
            }else{
                [self updateControlLayerDataWithMediaInfo:[self.aliPlayer getAliyunMediaInfo]];
            }
            
        }
            break;
        case  AliyunVodPlayerEventFirstFrame:
        {
            //sdk内部无计时器，需要获取currenttime；注意 NSRunLoopCommonModes
            NSTimer * tempTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:tempTimer forMode:NSRunLoopCommonModes];
            self.timer = tempTimer;
            
            [self.controlView setEnableGesture:YES];
            if((int)self.aliPlayer.quality >= 0){
                [self.controlView setCurrentQuality:self.aliPlayer.quality];
            }else{
                [self.controlView setCurrentDefinition:self.aliPlayer.videoDefinition];
            }
            
            //开启常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            //隐藏封面
            if (self.coverImageView) {
                self.coverImageView.hidden = YES;
                NSLog(@"播放器:首帧加载完成封面隐藏");
            }
        }
            break;
        case AliyunVodPlayerEventPlay:
//            //隐藏封面
//            if (self.coverImageView) {
//                self.coverImageView.hidden = YES;
//            }
            break;
        case AliyunVodPlayerEventPause:
        {
            //播放器暂停回调
            if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:onPause:)]) {
                NSTimeInterval time = vodPlayer.currentTime;
                [self.delegate aliyunVodPlayerView:self onPause:time];
            }
        }
            break;
        case AliyunVodPlayerEventFinish:{
            //播放完成回调
            if (self.delegate && [self.delegate respondsToSelector:@selector(onFinishWithAliyunVodPlayerView:)]) {
                [self.delegate onFinishWithAliyunVodPlayerView:self];
            }
            //播放完成
//            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodePlayFinish popMsg:nil];
            [self unlockScreen];
        }
            break;
        case AliyunVodPlayerEventStop: {
            //stop 回调
            if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:onStop:)]) {
                NSTimeInterval time = vodPlayer.currentTime;
                [self.delegate aliyunVodPlayerView:self onStop:time];
            }
            //取消常亮状态
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            //隐藏封面
            if (self.coverImageView) {
                self.coverImageView.hidden = YES;
                NSLog(@"播放器:播放停止封面隐藏");
            }
        }
            break;
        case AliyunVodPlayerEventSeekDone :{
            self.mProgressCanUpdate = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunVodPlayerView:onSeekDone:)]) {
                [self.delegate aliyunVodPlayerView:self onSeekDone:vodPlayer.currentTime];
            }
        }
            break;
        case AliyunVodPlayerEventBeginLoading: {
            //展示loading动画
            [_loadingView show];
        }
            break;
        case AliyunVodPlayerEventEndLoading: {
            //关闭loading动画
            [_loadingView dismiss];
            self.mProgressCanUpdate = YES;
        }
            break;
        default:
            break;
    }
}

//更新封面图片
- (void)updateCoverWithCoverUrl:(NSString *)coverUrl{
    //以用户设置的为先，标题和封面,用户在控制台设置coverurl地址
    if (self.coverImageView) {
        
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:coverUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.coverImageView.image = [UIImage imageWithData:data];
                if (!self.coverImageView.hidden) {
                    self.coverImageView.hidden = NO;
                    NSLog(@"播放器:展示封面");
                }
            });
        });
    }
}

//更新controlLayer界面ui数据
- (void)updateControlLayerDataWithMediaInfo:(AliyunVodPlayerVideo *)mediaInfo{
    //以用户设置的为先，标题和封面,用户在控制台设置coverurl地址
    if (!self.coverUrl && mediaInfo.coverUrl && mediaInfo.coverUrl.length>0) {
        [self updateCoverWithCoverUrl:mediaInfo.coverUrl];
    }
    //设置数据
    self.controlView.videoInfo = mediaInfo;
    //标题, 未播放URL 做备用判定
    if (!self.currentMediaTitle) {
        if (mediaInfo.title && mediaInfo.title.length>0) {
            self.controlView.title = mediaInfo.title;
        }else if(self.localSource.url){
            NSArray *ary = [[self.localSource.url absoluteString] componentsSeparatedByString:@"/"];
            self.controlView.title = ary.lastObject;
        }
    }else{
        self.controlView.title = self.currentMediaTitle;
    }
}

//根据错误信息，展示popLayer界面
- (void)showPopLayerWithErrorModel:(AliyunPlayerVideoErrorModel *)errorModel{
    switch (errorModel.errorCode) {
        case ALIVC_SUCCESS:
            break;
        case ALIVC_ERR_LOADING_TIMEOUT:
        {
            [self.popLayer showPopViewWithCode:    ALYPVPlayerPopCodeNetworkTimeOutError popMsg:nil];
            [self unlockScreen];
        }
            break;
        case ALIVC_ERR_REQUEST_DATA_ERROR:
        case ALIVC_ERR_INVALID_INPUTFILE:
        case ALIVC_ERR_INVALID_PARAM:
        case ALIVC_ERR_AUTH_EXPIRED:
        case ALIVC_ERR_NO_INPUTFILE:
        case ALIVC_ERR_VIDEO_FORMAT_UNSUPORTED:
        case ALIVC_ERR_PLAYAUTH_PARSE_FAILED:
        case ALIVC_ERR_DECODE_FAILED:
        case ALIVC_ERR_NO_SUPPORT_CODEC:
        case ALIVC_ERR_REQUEST_ERROR:
        case ALIVC_ERR_QEQUEST_SAAS_SERVER_ERROR:
        case ALIVC_ERR_QEQUEST_MTS_SERVER_ERROR:
        case ALIVC_ERR_SERVER_INVALID_PARAM:
        case ALIVC_ERR_NO_VIEW:
        case ALIVC_ERR_NO_MEMORY:
        case ALIVC_ERR_ILLEGALSTATUS:
        {
            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeServerError popMsg:errorModel.errorMsg];
            [self unlockScreen];
        }
            break;
        case ALIVC_ERR_READ_DATA_FAILED:
        {
            [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeLoadDataError popMsg:nil];
            [self unlockScreen];
        }
            break;
        default:
            break;
    }
}

#pragma mark - AliyunControlViewDelegate
- (void)onBackViewClickWithAliyunControlView:(AliyunPlayerViewControlView *)controlView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithAliyunVodPlayerView:)]){
         [self.delegate onBackViewClickWithAliyunVodPlayerView:self];
    } else {
        [self stop];
    }
}

- (void)onDownloadButtonClickWithAliyunControlView:(AliyunPlayerViewControlView *)controlViewP{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithAliyunVodPlayerView:)]) {
        [self.delegate onDownloadButtonClickWithAliyunVodPlayerView:self];
    }
}

- (void)onClickedPlayButtonWithAliyunControlView:(AliyunPlayerViewControlView *)controlView{
    AliyunVodPlayerState state = [self playerViewState];
    if (state == AliyunVodPlayerStatePlay){
        [self pause];
    }else if (state == AliyunVodPlayerStatePrepared){
        [self start];
    }else if(state == AliyunVodPlayerStatePause){
        [self resume];
    }
}

- (void)onClickedfullScreenButtonWithAliyunControlView:(AliyunPlayerViewControlView *)controlView{
    if(self.fixedPortrait){
        
        controlView.lockButton.hidden = self.isProtrait;
        
        if(!self.isProtrait){
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            self.isProtrait = YES;
        }else{
            self.frame = self.saveFrame;
            self.isProtrait = NO;
        }
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(aliyunVodPlayerView:fullScreen:)]) {
            [self.delegate aliyunVodPlayerView:self fullScreen:self.isProtrait];
        }
    }else{
        if(self.isScreenLocked){
            return;
        }
        [AliyunUtil setFullOrHalfScreen];
    }
    controlView.isProtrait = self.isProtrait;
    [self setNeedsLayout];
}

- (void)aliyunControlView:(AliyunPlayerViewControlView *)controlView dragProgressSliderValue:(float)progressValue event:(UIControlEvents)event{
   
    switch (event) {
        case UIControlEventTouchDown:
        {
            self.mProgressCanUpdate = NO;
        }
            break;
        case UIControlEventValueChanged:
        {
            self.mProgressCanUpdate = NO;
            //更新UI上的当前时间
            [self.controlView updateCurrentTime:progressValue*self.aliPlayer.duration durationTime:self.aliPlayer.duration];
        }
            break;
        case UIControlEventTouchUpInside:
        {
            
            [self.aliPlayer seekToTime:progressValue*self.aliPlayer.duration];
            NSLog(@"t播放器测试：TouchUpInside 跳转到%.1f",progressValue*self.aliPlayer.duration);
            AliyunVodPlayerState state = [self playerViewState];
            if (state == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //在播放器回调的方法里，防止sdk异常不进行seekdone的回调，在3秒后增加处理，防止ui一直异常
                self.mProgressCanUpdate = YES;
            });
        }
            break;
        case UIControlEventTouchUpOutside:{
            
            [self.aliPlayer seekToTime:progressValue*self.aliPlayer.duration];
            NSLog(@"t播放器测试：TouchUpOutside 跳转到%.1f",progressValue*self.aliPlayer.duration);
            AliyunVodPlayerState state = [self playerViewState];
            if (state == AliyunVodPlayerStatePause) {
                [self.aliPlayer resume];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //在播放器回调的方法里，防止sdk异常不进行seekdone的回调，在3秒后增加处理，防止ui一直异常
                self.mProgressCanUpdate = YES;
            });
        }
            break;
            //点击事件
        case UIControlEventTouchDownRepeat:{
            
            [self.aliPlayer seekToTime:progressValue*self.aliPlayer.duration];
            NSLog(@"t播放器测试：DownRepeat跳转到%.1f",progressValue*self.aliPlayer.duration);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //在播放器回调的方法里，防止sdk异常不进行seekdone的回调，在3秒后增加处理，防止ui一直异常
                self.mProgressCanUpdate = YES;
            });
        }
            break;
            
        default:
            self.mProgressCanUpdate = YES;
            break;
    }
    
   
    
}

- (void)aliyunControlView:(AliyunPlayerViewControlView *)controlView qualityListViewOnItemClick:(int)index{
    //暂停状态切换清晰度
    if(self.aliPlayer.playerState == AliyunVodPlayerStatePause){
        [self.aliPlayer resume];;
    }
    //切换清晰度
    [self.aliPlayer setQuality:index];
    
}

#pragma mark - controlViewDelegate
- (void)onLockButtonClickedWithAliyunControlView:(AliyunPlayerViewControlView *)controlView{
    controlView.lockButton.selected = !controlView.lockButton.isSelected;
    self.isScreenLocked =controlView.lockButton.selected;
    //锁屏判定
    [controlView lockScreenWithIsScreenLocked:self.isScreenLocked fixedPortrait:self.fixedPortrait];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(aliyunVodPlayerView:lockScreen:)]) {
        BOOL lScreen = self.isScreenLocked;
        if (self.isProtrait) {
            lScreen = YES;
        }
        [self.delegate aliyunVodPlayerView:self lockScreen:lScreen];
    }
}

- (void)onSpeedViewClickedWithAliyunControlView:(AliyunPlayerViewControlView *)controlView {
    [self.moreView showSpeedViewMoveInAnimate];
}

#pragma mark AliyunViewMoreViewDelegate
- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView clickedDownloadBtn:(UIButton *)downloadBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithAliyunVodPlayerView:)]) {
        [self.delegate onDownloadButtonClickWithAliyunVodPlayerView:self];
    }
}

- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView clickedAirPlayBtn:(UIButton *)airPlayBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedAirPlayButtonWithVodPlayerView:)]) {
        [self.delegate onClickedAirPlayButtonWithVodPlayerView:self];
    }
}

- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView clickedBarrageBtn:(UIButton *)barrageBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickedBarrageBtnWithVodPlayerView:)]) {
        [self.delegate onClickedBarrageBtnWithVodPlayerView:self];
    }
}

- (void)aliyunViewMoreView:(AliyunViewMoreView *)moreView speedChanged:(float)speedValue{
    [self.aliPlayer setPlaySpeed:speedValue];
}





#pragma mark - Custom

- (void)setUIStatusToReplay{
    [self.popLayer showPopViewWithCode:ALYPVPlayerPopCodeUseMobileNetwork  popMsg:@"重播"];
}

+ (NSString *)stringWithQuality:(AliyunVodPlayerVideoQuality )quality{
    switch (quality) {
        case AliyunVodPlayerVideoFD:
            return [@"流畅" localString];
            break;
        case AliyunVodPlayerVideoLD:
            return [@"标清" localString];
            break;
        case AliyunVodPlayerVideoSD:
            return [@"高清" localString];
            break;
        case AliyunVodPlayerVideoHD:
            return [@"超清" localString];
            break;
        case AliyunVodPlayerVideo2K:
            return [@"2K" localString];
            break;
        case AliyunVodPlayerVideo4K:
            return [@"4K" localString];
            break;
        case AliyunVodPlayerVideoOD:
            return [@"原画" localString];
            break;
            
        default:
            break;
    }
    return @"";
}


@end
