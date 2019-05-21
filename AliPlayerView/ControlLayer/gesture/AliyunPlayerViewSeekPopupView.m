//
//  ALYPVSeekPopupView.m
//  AliyunVodPlayerViewSDK
//


#import "AliyunPlayerViewSeekPopupView.h"
#import "AliyunPrivateDefine.h"

static const CGFloat ALYPVSeekPopupViewRadius          = 8;   //弧度
static const CGFloat ALYPVSeekPopupViewWidth           = 155; //view 宽度
static const CGFloat ALYPVSeekPopupViewWidthHeight     = 155; //view 高度
static const CGFloat ALYPVSeekPopupViewImageWidth      = 75;  //imageView 宽度
static const CGFloat ALYPVSeekPopupViewImageHeight     = 75;  //imageView 高度
static const CGFloat ALYPVSeekViewImageTop             = 25;  //imageView origin.y
static const CGFloat ALYPVSeekPopupViewTextSize        = 29;  //文字font
static const CGFloat ALYPVSeekPopupViewLabelMargin     = 18;  //显示时间，与图片的间隙

#define kALYPVSeekPopupViewBackGroundColor  [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]

@interface AliyunPlayerViewSeekPopupView ()

@property (nonatomic, strong) UIImage *forwardImg;      //快进图片
@property (nonatomic, strong) UIImage *backwardImg;     //后退图片
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) NSMutableParagraphStyle *textStyle;

//seek手势方向
@property (nonatomic, assign) UISwipeGestureRecognizerDirection direction;

//seekTo 时间
@property (nonatomic, assign) NSTimeInterval time;
@end

@implementation AliyunPlayerViewSeekPopupView

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0,ALYPVSeekPopupViewWidth,ALYPVSeekPopupViewWidthHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _forwardImg = [UIImage imageNamed:@"al_fingerGesture_forward"];
        _backwardImg = [UIImage imageNamed:@"al_fingerGesture_backward"];
        _textFont = [UIFont systemFontOfSize:ALYPVSeekPopupViewTextSize];
        _textStyle = [[NSMutableParagraphStyle alloc] init];
        _textStyle.alignment = kCTTextAlignmentRight;
        _textStyle.lineBreakMode = NSLineBreakByClipping;
        _direction = UISwipeGestureRecognizerDirectionRight;
        _time = 0.0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [AliyunUtil drawFillRoundRect:rect radius:ALYPVSeekPopupViewRadius color:kALYPVSeekPopupViewBackGroundColor context:context];
    float imgWidth = ALYPVSeekPopupViewImageWidth;
    float imgHeight = ALYPVSeekPopupViewImageHeight;
    float imgX = (rect.size.width - imgWidth)/2;
    float imgY = ALYPVSeekViewImageTop;
    
    if (self.direction == UISwipeGestureRecognizerDirectionRight) {
        [_forwardImg drawInRect:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    }else if (self.direction == UISwipeGestureRecognizerDirectionLeft){
        [_backwardImg drawInRect:CGRectMake(imgX, imgY, imgWidth, imgHeight)];
    }
    NSString *time = [AliyunUtil timeformatFromSeconds:self.time];
    if (time && _textStyle) {
        [time drawInRect:CGRectMake(0, imgY + imgHeight + ALYPVSeekPopupViewLabelMargin, rect.size.width, ALYPVSeekPopupViewTextSize) withAttributes:@{NSFontAttributeName:_textFont, NSForegroundColorAttributeName:kALYPVPopSeekTextColor, NSParagraphStyleAttributeName:_textStyle}];
    }
    CGContextRestoreGState(context);
}

#pragma mark - public method
/*
 * 功能 ： 当前时间点的滑动方向，并展示
 * 参数 ： time：当前播放时间，秒
 direciton ： 滑动方向，左右
 */
- (void)setSeekTime:(NSTimeInterval)time direction :(UISwipeGestureRecognizerDirection)direciton{
    self.time = time;
    self.direction = direciton;
    [self setNeedsDisplay];
}

/*
 * 功能 ： 展示view
 */
- (void)showWithParentView:(UIView *)parent {
    if (!parent) {
        return;
    }
    [parent addSubview:self];
    self.center = parent.center;
}

/*
 * 功能 ： 1秒后移除 view
 */
- (void)dismiss {
    if (self) {
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0f];
    }
}


@end
