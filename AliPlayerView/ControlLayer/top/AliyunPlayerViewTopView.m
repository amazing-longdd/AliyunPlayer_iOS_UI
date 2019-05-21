//
//  AlyunVodTopView.m
//

#import "AliyunPlayerViewTopView.h"
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
static const CGFloat ALYPVTopViewTitleLabelMargin = 8;  //标题 间隙
static const CGFloat ALYPVTopViewBackButtonWidth  = 24; //返回按钮宽度
static const CGFloat ALYPVTopViewDownLoadButtonWidth  = 30; //返回按钮宽度

@interface AliyunPlayerViewTopView()
@property (nonatomic, strong) UIImageView *topBarBG;        //背景图片
@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UIButton *backButton;         //返回按钮
@property (nonatomic, strong) UIButton *speedButton;        //倍速播放界面展示按钮
@property (nonatomic, strong) UIButton *downloadButton;     //下载视频

@end
@implementation AliyunPlayerViewTopView

- (UIImageView *)topBarBG{
    if (!_topBarBG) {
        _topBarBG = [[UIImageView alloc] init];
    }
    return _topBarBG;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:kALYPVColorTextNomal];
        [_titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    }
    return _titleLabel;
}

- (UIButton *)backButton{
    if (!_backButton){
        _backButton = [[UIButton alloc] init];
        UIImage *backImage = [UIImage imageNamed:@"al_top_back_nomal"];
        [_backButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [_backButton setBackgroundImage:backImage forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)speedButton{
    if (!_speedButton) {
        _speedButton = [[UIButton alloc] init];
        [_speedButton setImage:[UIImage imageNamed:@"avcMore"] forState:UIControlStateNormal];
        [_speedButton setImage:[UIImage imageNamed:@"avcMore"] forState:UIControlStateHighlighted];
        [_speedButton addTarget:self action:@selector(speedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speedButton;
}

- (UIButton *)downloadButton{
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *downloadImage = [UIImage imageNamed:@"avcDownload"];
//        _downloadButton.frame = CGRectMake(0, 0, downloadImage.size.width, downloadImage.size.height);
        [_downloadButton setBackgroundImage:downloadImage forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:downloadImage forState:UIControlStateSelected];
        [_downloadButton addTarget:self action:@selector(downloadButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
//        _downloadButton.center = CGPointMake(self.frame.size.width - 16 - self.downloadButton.frame.size.width / 2, 44);
    }
    return _downloadButton;
}

#pragma mark - init
- (instancetype)init{
   return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topBarBG];
        [self addSubview:self.titleLabel];
        [self addSubview:self.backButton];
        [self addSubview:self.downloadButton];
        [self addSubview:self.speedButton];
    }
    return self;
}

- (void)setPlayMethod:(ALYPVPlayMethod)playMethod{
    _playMethod = playMethod;
    if (playMethod == ALYPVPlayMethodUrl) {
        self.downloadButton.hidden = true;
    }else{
        if (ScreenWidth < ScreenHeight) {
            self.downloadButton.hidden = false;
        }
    }
    if (self.playMethod == ALYPVPlayMethodLocal) {
        self.downloadButton.hidden = true;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    if ([AliyunUtil isInterfaceOrientationPortrait]) {
        //竖屏
        self.speedButton.hidden = true;
        self.downloadButton.hidden = false;
    }else{
        //横屏
        self.speedButton.hidden = false;
        self.downloadButton.hidden = true;
    }
    
    self.topBarBG.frame = self.bounds;
    
    self.backButton.frame = CGRectMake(ALYPVTopViewTitleLabelMargin, (height - ALYPVTopViewBackButtonWidth)/2.0, ALYPVTopViewBackButtonWidth, ALYPVTopViewBackButtonWidth);
    
    self.downloadButton.frame = CGRectMake(width-ALYPVTopViewTitleLabelMargin-ALYPVTopViewDownLoadButtonWidth, (height - ALYPVTopViewDownLoadButtonWidth)/2.0, ALYPVTopViewDownLoadButtonWidth, ALYPVTopViewDownLoadButtonWidth);
    
    self.speedButton.frame = CGRectMake(width-ALYPVTopViewTitleLabelMargin-ALYPVTopViewDownLoadButtonWidth, (height - ALYPVTopViewDownLoadButtonWidth)/2.0, ALYPVTopViewDownLoadButtonWidth, ALYPVTopViewDownLoadButtonWidth);
    
    CGFloat titleWidth = width - (ALYPVTopViewBackButtonWidth + 2*ALYPVTopViewTitleLabelMargin) - (ALYPVTopViewDownLoadButtonWidth+2*ALYPVTopViewTitleLabelMargin);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame)+ALYPVTopViewTitleLabelMargin, 0, titleWidth, height);
    
    if (self.playMethod == ALYPVPlayMethodLocal) {
        self.downloadButton.hidden = true;
    }
}

#pragma mark - 重写setter方法
- (void)setSkin:(AliyunVodPlayerViewSkin)skin{
    _skin = skin;
    [self.topBarBG setImage:[UIImage imageNamed:@"al_topbar_bg"]];
//    [self.backButton setBackgroundImage:[UIImage imageNamed:@"avcBackIcon"] forState:UIControlStateNormal];
//
////    [self.backButton setBackgroundImage:[AliyunUtil imageWithNameInBundle:@"avcBackIcon" skin:skin] forState:UIControlStateHighlighted];
    [self.speedButton setImage:[UIImage imageNamed:@"avcMore"] forState:UIControlStateNormal];
    [self.speedButton setImage:[UIImage imageNamed:@"avcMore"] forState:UIControlStateHighlighted];
}

- (void)setTopTitle:(NSString *)topTitle{
    _topTitle = topTitle;
    self.titleLabel.text = topTitle;
}

#pragma mark - ButtonClicked
- (void)backButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithAliyunPVTopView:)]) {
        [self.delegate onBackViewClickWithAliyunPVTopView:self];
    }
}

- (void)speedButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSpeedViewClickedWithAliyunPVTopView:)]) {
        [self.delegate onSpeedViewClickedWithAliyunPVTopView:self];
    }
}

- (void)downloadButtonTouched:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadButtonClickWithAliyunPVTopView:)]) {
        [self.delegate onDownloadButtonClickWithAliyunPVTopView:self];
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
