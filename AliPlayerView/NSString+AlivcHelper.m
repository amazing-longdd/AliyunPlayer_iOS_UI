//
//  NSString+AlivcHelper.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "NSString+AlivcHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (AlivcHelper)

- (NSString *)localString{
    return NSLocalizedString(self, nil);
}

/**
 Because of nil cannot response message,
 `isEmpty` method fail to return `YES` when string is nil.
 */
- (BOOL)isNotEmpty {
    if (!self) return YES;
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

/*
 * 功能 ： 检查字符串是否是nil/null，返回判断后的字符串
 * 参数 : inputString : 输入字符串
 * return : 返回判断后的字符串
 */
+ (NSString *)aliyun_checkString:(NSString *)inputString {
    NSString *string = inputString;
    if([string isKindOfClass:[NSNull class]]){
        return @"";
    }
    if (string == nil) {
        return @"";
    }
    if ([string isEqualToString:@"(null)"]) {
        return @"";
    }
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text length] == 0) {
        return @"";
    }
    return string;
}


+ (BOOL)aliyun_checkStringIsEmpty:(NSString *)inputString {
    NSString *string = inputString;
    if([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    if (string == nil) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([text length] == 0) {
        return YES;
    }
    return NO;
}

/*
 * 功能 ： MD5
 * 参数 : inputString : 输入字符串
 * return : 返回MD5后的字符串
 */
+ (NSString *)aliyun_MD5:(NSString *) inputString{
    const char *cStr = [inputString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

/*
 * 功能 ： 编码
 * 参数 : inputString : 输入字符串
 * return : 返回编码后的字符串
 */
+ (NSString *)aliyun_encodeToPercentEscapeString: (NSString *) inputString{
    CFStringRef cfString = CFURLCreateStringByAddingPercentEscapes(
                                                                   NULL, /* allocator */
                                                                   (__bridge CFStringRef)inputString,
                                                                   NULL, /* charactersToLeaveUnescaped */
                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                   kCFStringEncodingUTF8);
    NSString *outputStr = [NSString stringWithString:(__bridge NSString *)cfString];
    CFRelease(cfString);
    return outputStr;
}

/*
 * 功能 ： 解码
 * 参数 : inputString : 输入字符串
 * return : 返回解码后的字符串
 */
+ (NSString *)aliyun_decodeFromPercentEscapeString: (NSString *) inputString{
    NSMutableString *outputStr = [NSMutableString stringWithString:inputString];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@""
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/*
 * 功能 : 获取UUID
 * return : 返回UUID的字符串
 */
+ (NSString*)aliyun_generateUUID{
    CFUUIDRef  uuidObj = CFUUIDCreate(nil);
    NSString  *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

/*
 * 功能 : 获取UTC时间
 * return : 返回UTC时间的字符串
 */
+ (NSString *)aliyun_getDateUTCTime{
    char date_str[21] = {0};
    time_t t = time(NULL)-28800;  // UTC秒数
    struct tm *tp = localtime(&t);
    sprintf(date_str, "%04d", tp->tm_year+1900);
    sprintf(date_str+4, "%s", "-");
    sprintf(date_str+5, "%02d", tp->tm_mon+1);
    sprintf(date_str+7, "%s", "-");
    sprintf(date_str+8, "%02d", tp->tm_mday);
    sprintf(date_str+10, "%s", "T");
    sprintf(date_str+11, "%02d", tp->tm_hour);
    sprintf(date_str+13, "%s", ":");
    sprintf(date_str+14, "%02d", tp->tm_min);
    sprintf(date_str+16, "%s", ":");
    sprintf(date_str+17, "%02d", tp->tm_sec);
    sprintf(date_str+19, "%s", "Z");
    NSString *output = [NSString stringWithFormat:@"%s",date_str];
    return output;
}


//HmacSHA1加密；
+(NSString *)HmacSha1:(NSString *)key input:(NSString *)input
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [input cStringUsingEncoding:NSASCIIStringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];//将加密结果进行一次BASE64编码。
    return hash;
}

//密码加密方式：SHA1
+(NSString *)EncriptPassword_SHA1:(NSString *)password{
    const char *cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:password.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result uppercaseString];
}

@end
