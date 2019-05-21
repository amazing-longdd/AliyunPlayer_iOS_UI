//
//  AliyunPVPopLayer.m
//

#import "AliyunPlayerViewPopLayer.h"
#import "AliyunUtil.h"

static const CGFloat ALYPVPopBackButtonWidth  = 24;  //返回按钮宽度
//static const CGFloat ALYPVPopBackButtonHeight = 96;  //返回按钮高度

@interface AliyunPlayerViewPopLayer () <AliyunPVErrorViewDelegate>
@property (nonatomic, strong) UIButton *backBtn;            //返回按钮
@property (nonatomic, strong) AliyunPlayerViewErrorView *errorView; //错误view

@end
@implementation AliyunPlayerViewPopLayer

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"al_top_back_nomal"];
        [_backBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_backBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    return _backBtn;
}

- (AliyunPlayerViewErrorView *)errorView{
    if (!_errorView) {
        _errorView = [[AliyunPlayerViewErrorView alloc] init];
    }
    return _errorView;
}

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.backBtn];
        self.errorView.delegate = self;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backBtn.frame = CGRectMake(8, (44-ALYPVPopBackButtonWidth)/2.0,ALYPVPopBackButtonWidth,ALYPVPopBackButtonWidth);
    self.errorView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

#pragma makr - 重写setter方法
- (void)setSkin:(AliyunVodPlayerViewSkin)skin{
    _errorView.skin = skin;
}

#pragma mark - onClick
- (void)onClick:(UIButton *)btn {
    if (![AliyunUtil isInterfaceOrientationPortrait]) {
        [AliyunUtil setFullOrHalfScreen];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onBackClickedWithAlPVPopLayer:)]) {
            [self.delegate onBackClickedWithAlPVPopLayer:self];
        }
    }
}


#pragma mark - public method
/*
 #define ALIYUNVODVIEW_UNKNOWN              @"未知错误"
 #define ALIYUNVODVIEW_PLAYFINISH           @"再次观看，请点击重新播放"
 #define ALIYUNVODVIEW_NETWORKTIMEOUT       @"当前网络不佳，请稍后点击重新播放"
 #define ALIYUNVODVIEW_NETWORKUNREACHABLE   @"无网络连接，检查网络后点击重新播放"
 #define ALIYUNVODVIEW_LOADINGDATAERROR     @"视频加载出错，请点击重新播放"
 #define ALIYUNVODVIEW_USEMOBILENETWORK     @"当前为移动网络，请点击播放"
 */
- (void)showPopViewWithCode:(ALYPVPlayerPopCode)code popMsg:(NSString *)popMsg {
    if ([_errorView isShowing]) {
        [_errorView dismiss];
    }
    NSBundle *resourceBundle = [AliyunUtil languageBundle];
    NSString *tempString = @"unknown";
    ALYPVErrorType type = ALYPVErrorTypeRetry;
    switch (code) {
        case ALYPVPlayerPopCodePlayFinish:
        {
            tempString = [AliyunUtil playFinishTips];
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"Watch again, please click replay", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeReplay;
        }
            break;
        case ALYPVPlayerPopCodeNetworkTimeOutError :
        {
            tempString = [AliyunUtil networkTimeoutTips];
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"The current network is not good. Please click replay later", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeReplay;
        }
            break;
        case ALYPVPlayerPopCodeUnreachableNetwork:
        {
            tempString = [AliyunUtil networkUnreachableTips];
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"No network connection, check the network, click replay", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeReplay;
        }
            break;
        case ALYPVPlayerPopCodeLoadDataError :
        {
            tempString = [AliyunUtil loadingDataErrorTips];
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"Video loading error, please click replay", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypeRetry;
        }
            break;
        case ALYPVPlayerPopCodeServerError:
        {
            tempString = popMsg;
            type = ALYPVErrorTypeRetry;
        }
            break;
        case ALYPVPlayerPopCodeUseMobileNetwork:
        {
            
            tempString = [AliyunUtil switchToMobileNetworkTips];
            if (!tempString) {
                tempString = NSLocalizedStringFromTableInBundle(@"For mobile networks, click play", nil, resourceBundle, nil);
            }
            type = ALYPVErrorTypePause;
            
        }
            break;
        default:
            break;
    }
    if(popMsg){
        tempString = popMsg;
    }
    self.errorView.message = tempString;
    self.errorView.type = type;
    [_errorView showWithParentView:self];
}

#pragma mark - AliyunPVErrorViewDelegate
- (void)onErrorViewClickedWithType:(ALYPVErrorType)type{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPopViewWithType:)]) {
        [self.delegate showPopViewWithType:type];
    }
}

@end
