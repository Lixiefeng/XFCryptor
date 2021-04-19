//
//  XFViewController.m
//  XFCryptor
//
//  Created by Aron1987@126.com on 04/18/2021.
//  Copyright (c) 2021 Aron1987@126.com. All rights reserved.
//

#import "XFViewController.h"
#import <XFCryptor/RSACryptor.h>
#import <XFCryptor/NSString+Hash.h>

@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //1.加载公钥
    [[RSACryptor sharedRSACryptor] loadPublicKey:[[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil]];
    
    //2.加载私钥
    [[RSACryptor sharedRSACryptor] loadPrivateKey:[[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil] password:@"123456"];
    
    [self hashTest];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //加密
    NSData * result = [[RSACryptor sharedRSACryptor] encryptData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
    NSString * base64 =  [result base64EncodedStringWithOptions:0];
    NSLog(@"加密:%@",base64);
    
    //解密
    NSData * jiemi = [[RSACryptor sharedRSACryptor] decryptData:result];
    NSLog(@"解密:%@",[[NSString alloc] initWithData:jiemi encoding:NSUTF8StringEncoding]);
}

#pragma mark - HASH

- (void)hashTest {
    NSString *message = @"LGPerson";
    NSString *key = @"key";
    NSLog(@"string md5: %@",[message md5String]);
    NSLog(@"string sha1: %@",[message sha1String]);
    NSLog(@"string sha256: %@",[message sha256String]);
    NSLog(@"string sha512: %@",[message sha512String]);
    NSLog(@"string hmac md5: %@",[message hmacMD5StringWithKey:key]);
    NSLog(@"string hmac sha1: %@",[message hmacSHA1StringWithKey:key]);
    NSLog(@"string hmac sha256: %@",[message hmacSHA256StringWithKey:key]);
    NSLog(@"string hmac sha512: %@",[message hmacSHA512StringWithKey:key]);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"txt"];
    NSLog(@"file md5: %@",[filePath fileMD5Hash]);
    NSLog(@"file sha1: %@",[filePath fileSHA1Hash]);
    NSLog(@"file sha256: %@",[filePath fileSHA256Hash]);
    NSLog(@"file sha512: %@",[filePath fileSHA512Hash]);
}


@end
