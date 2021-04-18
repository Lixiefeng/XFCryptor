//
//  XFViewController.m
//  XFCryptor
//
//  Created by Aron1987@126.com on 04/18/2021.
//  Copyright (c) 2021 Aron1987@126.com. All rights reserved.
//

#import "XFViewController.h"
#import <RSACryptor.h>

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



@end
