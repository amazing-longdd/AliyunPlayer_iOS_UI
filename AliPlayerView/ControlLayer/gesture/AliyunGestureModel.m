
#import "AliyunGestureModel.h"

@interface AliyunGestureModel ()<UIGestureRecognizerDelegate>
/*
 * 功能 ： 单击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *singleClick;

/*
 * 功能 ： 双击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleClick;

/*
 * 功能 ： 滑动手势
 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIView *tempView;

/*
 * 功能 ： 临时参数，记录touchesBegan时 手指触点。
 */
@property (nonatomic, assign) CGPoint savePoint;

@end

@implementation AliyunGestureModel

#pragma mark - 懒加载
- (UITapGestureRecognizer *)singleClick{
    if (!_singleClick) {
        _singleClick = [[UITapGestureRecognizer alloc] init];
    }
    return _singleClick;
}

- (UITapGestureRecognizer *)doubleClick{
    if (!_doubleClick) {
        _doubleClick = [[UITapGestureRecognizer alloc] init];
        [_doubleClick setNumberOfTapsRequired:2];
    }
    return _doubleClick;
}

- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] init];
    }
    return _panGesture;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.savePoint = CGPointZero;
//        self.volumePoint = CGPointZero;
        self.singleClick.delegate = self;
        self.singleClick.delegate = self;
        self.panGesture.delegate = self;
        [self.singleClick addTarget:self action:@selector(singleClickTap:)];
        [self.doubleClick addTarget:self action:@selector(doubleClickTap:)];
        [self.panGesture addTarget:self action:@selector(drapGesture:)];
        [self.singleClick requireGestureRecognizerToFail:self.doubleClick];
        
    }
    return self;
}

/*
 * 功能 ：设置手势禁用功能
 */
- (void)setEnableGesture:(BOOL)enableGesture {
    [self.singleClick setEnabled:enableGesture];
    [self.doubleClick setEnabled:enableGesture];
    [self.panGesture setEnabled:enableGesture];
}

/*
 * 功能 ：手势添加到特定的view中
 */
- (void)setView:(id)view{
    if (![view isKindOfClass:[UIView class]]) {
        return;
    }
    [view addGestureRecognizer:self.singleClick];
    [view addGestureRecognizer:self.doubleClick];
    [view addGestureRecognizer:self.panGesture];
    self.tempView = view;
}

#pragma mark - delegate
- (void)singleClickTap:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSingleClicked)]) {
        [self.delegate onSingleClicked];
    }
}

- (void)doubleClickTap:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDoubleClicked)]) {
        [self.delegate onDoubleClicked];
    }
}

static ALYPVOrientation moveOrientation = ALYPVOrientationUnknow;

static UISwipeGestureRecognizerDirection direction = UISwipeGestureRecognizerDirectionUp;
- (void)drapGesture:(UIPanGestureRecognizer *)sender{
    if (!self.tempView) {
        return;
    }
    CGPoint point= [sender locationInView:self.tempView];// 上下控制点
    CGPoint tranPoint=[sender translationInView:self.tempView];//播放进度,左右
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (moveOrientation == ALYPVOrientationUnknow) {
                CGPoint velocity = [sender velocityInView:self.tempView];
                //开始滑动时的手指在屏幕上的区域
                [self gestureRecognizerStateBeganWithpoint:point velocity:velocity];
                
                _savePoint = point;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunGestureModel:state:moveOrientation:)]) {
                    [self.delegate aliyunGestureModel:self state:sender.state moveOrientation:moveOrientation];
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (moveOrientation == ALYPVOrientationVertical) {//垂直
                [self gestureRecognizerStateChangedWithPoint:point view:self.tempView savePoint:self.savePoint];
                
                 //记录上一次移动点
                _savePoint = point;
            }else if (moveOrientation == ALYPVOrientationHorizontal){//水平
                //水平偏移量
                if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalOrientationMoveOffset:)]) {
                    [self.delegate horizontalOrientationMoveOffset:tranPoint.x];
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunGestureModel:state:moveOrientation:)]) {
                [self.delegate aliyunGestureModel:self state:sender.state moveOrientation:moveOrientation];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunGestureModel:state:moveOrientation:)]) {
                [self.delegate aliyunGestureModel:self state:sender.state moveOrientation:moveOrientation];
            }
            moveOrientation = ALYPVOrientationUnknow;
            break;
        }
        default:

            break;
    }
    
}

#pragma mark - private method
- (void)gestureRecognizerStateBeganWithpoint:(CGPoint)point velocity:(CGPoint)velocity {
    BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
    if (isVerticalGesture) {
            moveOrientation = ALYPVOrientationVertical;//垂直
        if(point.x <self.tempView.frame.size.width/2){
            
           direction = UISwipeGestureRecognizerDirectionLeft;
        
        }else{
        
           direction = UISwipeGestureRecognizerDirectionRight;
            
        }
    }else {
        
          moveOrientation = ALYPVOrientationHorizontal;//水平
        
    }
}

- (void)gestureRecognizerStateChangedWithPoint:(CGPoint)point view:(UIView*)view savePoint:(CGPoint)savePoint {
    UISwipeGestureRecognizerDirection tempDirection = UISwipeGestureRecognizerDirectionUp;
    tempDirection = (savePoint.y > point.y)?UISwipeGestureRecognizerDirectionUp : UISwipeGestureRecognizerDirectionDown;
    if(direction == UISwipeGestureRecognizerDirectionLeft){
        if(point.x > view.frame.size.width/2){
            //滑动中，手势在右侧时不做回调
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunGestureModel:brightnessDirection:)]) {
            [self.delegate aliyunGestureModel:self brightnessDirection:tempDirection];
        }
    }else if(direction == UISwipeGestureRecognizerDirectionRight){
        if(point.x < view.frame.size.width/2){
            //滑动中，手势在左侧时不做回调
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(aliyunGestureModel:volumeDirection:)]) {
            [self.delegate aliyunGestureModel:self volumeDirection:tempDirection];
        }
    }
}

#pragma mark - UIGestureRecognizer delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[UIControl class]]){
        return NO;
    }else{
        return YES;
    }
    return YES;
}


@end
