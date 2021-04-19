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
#import <XFCryptor/EncryptionTools.h>

@interface XFViewController ()

@end

@implementation XFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadSecretKey];
    
    [self RSATest];
    
    [self hashTest];
    
    [self AESTest];
    
    [self DESTest];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - RSA

// 加载RSA的公钥 私钥
- (void)loadSecretKey {
    //1.加载公钥
    [[RSACryptor sharedRSACryptor] loadPublicKey:[[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil]];
    
    //2.加载私钥
    [[RSACryptor sharedRSACryptor] loadPrivateKey:[[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil] password:@"123456"];
}

- (void)RSATest {
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

#pragma mark - AED

- (void)AESTest {
    //key
    NSString *key = @"abc";
    //iv
    uint8_t iv[8] = {1,2,3,4,5,6,7,8};
    NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
    //message
    NSString *message = @"LGPerson";


    // AES算法
    // ECB 加密
    NSString *encAES_ECBResult = [[EncryptionTools sharedEncryptionTools] encryptString:message keyString:key iv:nil];
    NSLog(@"AES_ECB enc：%@",encAES_ECBResult);
    // ECB 解密
    NSString *decAES_ECBResult = [[EncryptionTools sharedEncryptionTools] decryptString:encAES_ECBResult keyString:key iv:nil];
    NSLog(@"AES_ECB dec：%@",decAES_ECBResult);

    // CBC 加密
    NSString *encAES_CBCResult = [[EncryptionTools sharedEncryptionTools] encryptString:message keyString:key iv:ivData];
    NSLog(@"AES_CBC enc：%@",encAES_CBCResult);
    // CBC  解密
    NSString *decAES_CBCResult = [[EncryptionTools sharedEncryptionTools] decryptString:encAES_CBCResult keyString:key iv:ivData];
    NSLog(@"AES_CBC dec：%@",decAES_CBCResult);
}

#pragma mark - DES

- (void)DESTest {
    //key
    NSString *key = @"abc";
    //iv
    uint8_t iv[8] = {1,2,3,4,5,6,7,8};
    NSData *ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
    //message
    NSString *message = @"LGPerson";
    
    //修改加密为DES
    [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmDES;

    // ECB 加密
    NSString *encDES_ECBResult = [[EncryptionTools sharedEncryptionTools] encryptString:message keyString:key iv:nil];
    NSLog(@"DES_ECB enc：%@",encDES_ECBResult);
    // ECB 解密
    NSString *decDES_ECBResult = [[EncryptionTools sharedEncryptionTools] decryptString:encDES_ECBResult keyString:key iv:nil];
    NSLog(@"DES_ECB dec：%@",decDES_ECBResult);

    // CBC 加密
    NSString *encDES_CBCResult = [[EncryptionTools sharedEncryptionTools] encryptString:message keyString:key iv:ivData];
    NSLog(@"DES_CBC enc：%@",encDES_CBCResult);
    // CBC  解密
    NSString *decDES_CBCResult = [[EncryptionTools sharedEncryptionTools] decryptString:encDES_CBCResult keyString:key iv:ivData];
    NSLog(@"DES_CBC dec：%@",decDES_CBCResult);
}
@end
