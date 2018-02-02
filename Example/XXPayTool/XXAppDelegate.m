//
//  XXAppDelegate.m
//  XXPayTool
//
//  Created by lyxiel@163.com on 01/24/2018.
//  Copyright (c) 2018 lyxiel@163.com. All rights reserved.
//

#import "XXAppDelegate.h"
#import <XXPayTool.h>

@implementation XXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //注册微信appId
    [XXPayTool wechatRegisterAppWithAppId:@""];
    return YES;
}

//iOS9之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if([url.scheme hasPrefix:@"wx"])//微信
    {
        return [XXPayTool wechatHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"UnionPay"])//银联
    {
        return [XXPayTool unionHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"safepay"])//支付宝
    {
        return [XXPayTool alipayHandleOpenURL:url];
    }
    return YES;
}

//iOS9之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if([url.scheme hasPrefix:@"wx"])//微信
    {
        return [XXPayTool wechatHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"UnionPay"])//银联
    {
        return [XXPayTool unionHandleOpenURL:url];
    }
    else if([url.scheme hasPrefix:@"safepay"])//支付宝
    {
        return [XXPayTool alipayHandleOpenURL:url];
    }
    return YES;
}

@end
