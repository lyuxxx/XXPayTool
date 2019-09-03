//
//  XXPayTool.m
//  XXPayTool
//
//  Created by yxliu on 2018/1/24.
//

#import "XXPayTool.h"

@implementation XXPayTool

+ (XXPayTool *)getInstance {
    static XXPayTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XXPayTool alloc] init];
    });
    return instance;
}

#pragma mark - Apple Pay -

+ (XXApplePaySupportStatus)canApplePay {
    LLAPPaySupportStatus status = [LLAPPaySDK canDeviceSupportApplePayPayments];
    if (status == kLLAPPayDeviceSupport) {
        return XXApplePaySupportStatusSupport;
    } else if (status == kLLAPPayDeviceNotSupport || status == kLLAPPayDeviceVersionTooLow) {
        return XXApplePaySupportStatusDeviceOrVersionNotSupport;
    } else if (status == kLLAPPayDeviceNotBindChinaUnionPayCard) {
        return XXApplePaySupportStatusSupportNotBindCard;
    }
    return XXApplePaySupportStatusUnknown;
}

+ (void)showWalletToBindCard {
    [LLAPPaySDK showWalletToBindCard];
}

- (void)applePayWithTraderInfo:(NSDictionary *)traderInfo viewController:(UIViewController *)viewController respBlock:(XXPayToolRespBlock)block {
    self.applePayRespBlock = block;
    if ([XXPayTool canApplePay] == XXApplePaySupportStatusSupport) {
        LLAPPaySDK *llAPPaySDK = [LLAPPaySDK sharedSdk];
        llAPPaySDK.sdkDelegate = self;
        [llAPPaySDK payWithTraderInfo:traderInfo inViewController:viewController];
    } else {
        if (self.applePayRespBlock) {
            self.applePayRespBlock(-4, @"设备或系统不支持，或者用户未绑卡");
        }
    }
}
#pragma mark - LLPStdSDKDelegate -

- (void)paymentEnd:(LLPStdSDKResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg;
    switch (resultCode) {
        case LLPStdSDKResultSuccess:
        {
            msg = @"支付成功";
            NSString *result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"]) {
                if (self.applePayRespBlock) {
                    self.applePayRespBlock(0, @"支付成功");
                }
            } else {
                if (self.applePayRespBlock) {
                    self.applePayRespBlock(-1, @"支付失败");
                }
            }
        }
            break;
        case LLPStdSDKResultFail:
        {
            if (self.applePayRespBlock) {
                self.applePayRespBlock(-1, @"支付失败");
            }
        }
            break;
        case LLPStdSDKResultCancel:
        {
            if (self.applePayRespBlock) {
                self.applePayRespBlock(-2, @"支付取消");
            }
        }
            break;
        case LLPStdSDKResultInitError:
        {
            if (self.applePayRespBlock) {
                self.applePayRespBlock(-1, @"支付失败");
            }
        }
            break;
        case LLPStdSDKResultInitParamError:
        {
            if (self.applePayRespBlock) {
                self.applePayRespBlock(-1, @"支付失败");
            }
        }
            break;
        default:
        {
            if (self.applePayRespBlock) {
                self.applePayRespBlock(-99, @"未知错误");
            }
        }
            break;
    }
}

#pragma mark - WeChat Pay -
+ (BOOL)isWXAppInstalled {
    return [WXApi isWXAppInstalled];
}

+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId {
    return [WXApi registerApp:appId];
}

+ (BOOL)wechatHandleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[XXPayTool getInstance]];
}

- (void)wechatPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign respBlock:(XXPayToolRespBlock)block {
    self.wechatRespBlock = block;
    if ([WXApi isWXAppInstalled]) {
        PayReq *req = [[PayReq alloc] init];
        req.openID = appId;
        req.partnerId = partnerId;
        req.prepayId = prepayId;
        req.package = package;
        req.nonceStr = nonceStr;
        req.timeStamp = (UInt32)timeStamp.integerValue;
        req.sign = sign;
        [WXApi sendReq:req];
    } else {
        if (self.wechatRespBlock) {
            self.wechatRespBlock(-3, @"未安装微信");
        }
    }
}

#pragma mark - WXApiDelegate -
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case 0:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(0, @"支付成功");
                }
                break;
            }
            case -1:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-1, @"支付失败");
                }
                break;
            }
            case -2:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-2, @"支付取消");
                }
                break;
            }
            default:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-99, @"未知错误");
                }
            }
                break;
        }
    }
}

#pragma mark - Alipay -
+ (BOOL)alipayHandleOpenURL:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        XXPayTool *manager = [XXPayTool getInstance];
        NSNumber *code = resultDic[@"resultStatus"];
        if(code.integerValue==9000)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-99, @"未知错误");
            }
        }
    }];
    return YES;
}

- (void)aliPayOrder:(NSString *)order scheme:(NSString *)scheme respBlock:(XXPayToolRespBlock)block {
    self.alipayRespBlock = block;
    __weak __typeof(&*self)ws = self;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        NSNumber *code = resultDic[@"resultStatus"];
        if(code.integerValue==9000)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-99, @"未知错误");
            }
        }
    }];
}

#pragma mark - UnionPay -

+ (BOOL)unionHandleOpenURL:(NSURL *)url {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        XXPayTool *payManager = [XXPayTool getInstance];
        if([code isEqualToString:@"success"])
        {
            if(payManager.unionPayRespBlock)
            {
                payManager.unionPayRespBlock(0, @"支付成功");
            }
        }
        else if([code isEqualToString:@"fail"])
        {
            if(payManager.unionPayRespBlock)
            {
                payManager.unionPayRespBlock(-1, @"支付失败");
            }
        }
        else if([code isEqualToString:@"cancel"])
        {
            if(payManager.unionPayRespBlock)
            {
                payManager.unionPayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(payManager.unionPayRespBlock)
            {
                payManager.unionPayRespBlock(-99, @"未知错误");
            }
        }
    }];
    return YES;
}

- (void)unionPayWithSerialNo:(NSString *)serialNo viewController:(id)viewController respBlock:(XXPayToolRespBlock)block {
    self.unionPayRespBlock = block;
    [[UPPaymentControl defaultControl] startPay:serialNo fromScheme:@"UnionPay" mode:@"00" viewController:viewController];
}

@end
