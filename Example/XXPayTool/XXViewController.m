//
//  XXViewController.m
//  XXPayTool
//
//  Created by lyxiel@163.com on 01/24/2018.
//  Copyright (c) 2018 lyxiel@163.com. All rights reserved.
//

#import "XXViewController.h"
#import <XXPayTool.h>

@interface XXViewController ()

@end

@implementation XXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)applePayFunc
{
    //先获取Apple Pay支付参数
    //...
    
    XXPayTool *manager = [XXPayTool getInstance];
    [manager applePayWithTraderInfo:nil viewController:self respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)wechatPayFunc
{
    //先获取微信支付参数
    //...
    
    XXPayTool *manager = [XXPayTool getInstance];
    [manager wechatPayWithAppId:@"" partnerId:@"" prepayId:@"" package:@"" nonceStr:@"" timeStamp:@"" sign:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)aliPayFunc
{
    //先获取支付宝支付参数
    //...
    
    XXPayTool *manager = [XXPayTool getInstance];
    [manager aliPayOrder:@"" scheme:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)unionPayFunc
{
    //先获取银联支付参数
    //...
    
    XXPayTool *manager = [XXPayTool getInstance];
    [manager unionPayWithSerialNo:@"" viewController:self respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

@end
