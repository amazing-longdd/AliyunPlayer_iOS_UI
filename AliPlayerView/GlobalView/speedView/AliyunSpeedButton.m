//
//  AliyunPVSpeedButton.m
//


#import "AliyunSpeedButton.h"

static const CGFloat ALYPVSpeedButtonIVWidth        = 5;      //imageView 宽度
static const CGFloat ALYPVSpeedButtonLabelHeight    = 30;      //imageView 宽度

@implementation AliyunSpeedButton

- (UILabel *)speedLabel{
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
    }
    return _speedLabel;
}

- (UIImageView *)speedImageView{
    if (!_speedImageView) {
        _speedImageView = [[UIImageView alloc] init];
    }
    return _speedImageView;
}

#pragma mark - init
- (instancetype)init{
    return  [self  initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.speedImageView];
        [self addSubview:self.speedLabel];
    }
    return self;
}

- (void)layoutSubviews{
    CGFloat width = self.bounds.size.width;
    self.speedImageView.frame = CGRectMake((width-ALYPVSpeedButtonIVWidth)/2, 0, ALYPVSpeedButtonIVWidth, ALYPVSpeedButtonIVWidth);
    self.speedLabel.frame = CGRectMake(0, self.speedImageView.frame.origin.y+self.speedImageView.frame.size.height+ALYPVSpeedButtonIVWidth, width, ALYPVSpeedButtonLabelHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
