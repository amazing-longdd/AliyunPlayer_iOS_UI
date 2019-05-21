//
//  AliyunVodPlayerViewDataSource.m
//

#import "AliyunDataSource.h"


@implementation AliyunLocalSource

- (instancetype)init{
    if (self = [super init]) {
        _url = nil;
    }
    return self;
}

- (BOOL)isFileUrl{
    if (_url && _url.fileURL) {
        return YES;
    }
    return NO;
}

@end


@implementation AliyunPlayAuthModel

- (instancetype)init{
    if (self = [super init]) {
        _videoId = @"";
        _playAuth = @"";
    }
    return self;
}

@end

@implementation AliyunSTSModel

- (instancetype)init{
    if (self = [super init]) {
        _videoId = @"";
        _accessKeyId = @"";
        _accessSecret = @"";
        _ststoken = @"";
    }
    return self;
}

@end

@implementation AliyunMPSModel

- (instancetype)init{
    if (self = [super init]) {
        _videoId = @"";
        _accessKey = @"";
        _accessSecret = @"";
        _stsToken = @"";
        _authInfo = @"";
        _region = @"";
        _playDomain = @"";
        _hlsUriToken = @"";
    }
    return self;
}

@end

