//
//  AliyunPVGifView.m
//

#import "AliyunPlayerViewGifView.h"
#import "AliyunUtil.h"
#import <ImageIO/ImageIO.h>

static const CGFloat ALYPVGifViewAnimationRepeatCount = 3600;  //动画循环次数

@interface AliyunPlayerViewGifView () <CAAnimationDelegate>
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) NSMutableArray *frameDelayTimes;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, strong) CAKeyframeAnimation *animation;
@end

@implementation AliyunPlayerViewGifView

#pragma mark - init
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _totalTime = 0.0f;
        _animation = nil;
        _frames = [[NSMutableArray alloc] init];
        _frameDelayTimes = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - public method
/*
 * 功能 ：设定gif动画图片
 */
- (void)setGifImageWithName:(NSString *)name {
    [self reset];
    NSURL *url = [[NSBundle mainBundle] URLForResource:name withExtension:@"gif"];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) url, NULL);
    size_t frameCount = CGImageSourceGetCount(gifSource);
    for (size_t i = 0; i < frameCount; ++i) {
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        [_frames addObject:(__bridge id)(frame)];
        CGImageRelease(frame);
        NSDictionary *dict = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, i, NULL));
        NSDictionary *gifDict = [dict valueForKey:(NSString *) kCGImagePropertyGIFDictionary];
        [_frameDelayTimes addObject:[gifDict valueForKey:(NSString *) kCGImagePropertyGIFDelayTime]];
        _totalTime += [[gifDict valueForKey:(NSString *) kCGImagePropertyGIFDelayTime] floatValue];
    }
    if (gifSource) {
        CFRelease(gifSource);
    }
    _animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:3];
    CGFloat currentTime = 0;
    int count = (int) _frameDelayTimes.count;
    for (int i = 0; i < count; ++i) {
        [times addObject:[NSNumber numberWithFloat:(currentTime / _totalTime)]];
        currentTime += [[_frameDelayTimes objectAtIndex:i] floatValue];
    }
    [_animation setKeyTimes:times];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < count; ++i) {
        [images addObject:[_frames objectAtIndex:i]];
    }
    [_animation setValues:images];
    [_animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    _animation.duration = _totalTime;
    _animation.delegate = self;
    _animation.repeatCount = ALYPVGifViewAnimationRepeatCount;
}

/*
 * 功能 ：开始动画
 */
- (void)startAnimation {    
    [self.layer addAnimation:_animation forKey:@"gifAnimation"];
}

/*
 * 功能 ：停止动画
 */
- (void)stopAnimation {
    [self.layer removeAllAnimations];
}

#pragma mark - reset清理数据
- (void)reset {
    [_frames removeAllObjects];
    [_frameDelayTimes removeAllObjects];
    _totalTime = 0;
}

@end
