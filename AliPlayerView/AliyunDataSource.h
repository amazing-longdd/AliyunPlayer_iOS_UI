//
//  AliyunVodPlayerViewDataSource.h
//  播放器的数据源类


#import <Foundation/Foundation.h>


@interface AliyunLocalSource : NSObject

@property (nonatomic, strong) NSURL *url;

//本地播放地址判断
- (BOOL)isFileUrl;

@end

@interface AliyunPlayAuthModel : NSObject

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *playAuth;

@end

@interface AliyunSTSModel : NSObject

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessSecret;
@property (nonatomic, copy) NSString *ststoken;

@end

@interface AliyunMPSModel : NSObject

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *accessKey;
@property (nonatomic, copy) NSString *accessSecret;
@property (nonatomic, copy) NSString *stsToken;
@property (nonatomic, copy) NSString *authInfo;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *playDomain;
@property (nonatomic, copy) NSString *hlsUriToken;

@end
