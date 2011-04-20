//
//  NSURL+MD5.m
//  WhiteLabel
//
//  Created by Barry Burton on 4/19/11.
//  Copyright 2011 Fonetik. All rights reserved.
//

#import "NSURL+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSURL (MD5)

- (NSString *)hexadecimalMD5Value {
    const char *urlString = [[self absoluteString] UTF8String];
    unsigned char hashBytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(urlString, strlen(urlString), hashBytes);
    
    NSMutableString *hashString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for ( NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        [hashString appendFormat:@"%02x", hashBytes[i]];
    }
    
    return hashString;
}
@end
