//
//  XXPayTool.h
//  XXPayTool
//
//  Created by yxliu on 2018/1/24.
//

#import <Foundation/Foundation.h>

#import <LLAPPaySDK.h>

#import <WXApi.h>
#import <WechatAuthSDK.h>

#import <AlipaySDK/AlipaySDK.h>

#import <UPPaymentControl.h>

/**
 respCode:

 @param respCode
 0    -    支付成功
 -1   -    支付失败
 -2   -    支付取消
 -3   -    未安装App(适用于微信)
 -4   -    设备或系统不支持，或者用户未绑卡(适用于ApplePay)
 -99  -    未知错误
 @param respMsg 返回信息
 */
typedef void(^XXPayToolRespBlock)(NSInteger respCode, NSString *respMsg);

typedef NS_ENUM(NSUInteger, XXApplePaySupportStatus) {
    XXApplePaySupportStatusSupport,                     //完全支持
    XXApplePaySupportStatusDeviceOrVersionNotSupport,   //设备或系统不支持
    XXApplePaySupportStatusSupportNotBindCard,          //设备和系统支持，用户未绑卡
    XXApplePaySupportStatusUnknown                      //未知状态
};

@interface XXPayTool : NSObject <LLPaySdkDelegate, WXApiDelegate>

+ (XXPayTool *)getInstance;

#pragma mark - Apple Pay -

/**
 Apple Pay支付结果回调
 */
@property (nonatomic, copy) XXPayToolRespBlock applePayRespBlock;

/**
 是否支持Apple Pay

 @return XXApplePaySupportStatus
 */
+ (XXApplePaySupportStatus)canApplePay;

/**
 跳转wallet系统app进行绑卡
 */
+ (void)showWalletToBindCard;

/**
 发起Apple Pay支付

 @param traderInfo 订单信息
 @param viewController 页面
 @param block 回调
 */
- (void)applePayWithTraderInfo:(NSDictionary *)traderInfo
                viewController:(UIViewController *)viewController
                     respBlock:(XXPayToolRespBlock)block;

#pragma mark - WeChat Pay -

/**
 微信支付结果回调
 */
@property (nonatomic, copy) XXPayToolRespBlock wechatRespBlock;

/**
 检查是否安装微信

 @return 是否安装微信
 */
+ (BOOL)isWXAppInstalled;

/**
 注册微信appId

 @param appId appId
 @return 返回值
 */
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId;

/**
 处理微信通过URL启动App时传递回来的数据

 @param url URL
 @return 返回值
 */
+ (BOOL)wechatHandleOpenURL:(NSURL *)url;

/**
 发起微信支付

 @param appId appId
 @param partnerId partnerId
 @param prepayId prepayId
 @param package package
 @param nonceStr nonceStr
 @param timeStamp timeStamp
 @param sign sign
 @param block block
 */
- (void)wechatPayWithAppId:(NSString *)appId
                 partnerId:(NSString *)partnerId
                  prepayId:(NSString *)prepayId
                   package:(NSString *)package
                  nonceStr:(NSString *)nonceStr
                 timeStamp:(NSString *)timeStamp
                      sign:(NSString *)sign
                 respBlock:(XXPayToolRespBlock)block;

#pragma mark - Alipay -

/**
 支付宝结果回调
 */
@property (nonatomic, copy) XXPayToolRespBlock alipayRespBlock;

/**
 处理支付宝通过URL启动App时传递回来的数据

 @param url url
 @return 返回值
 */
+ (BOOL)alipayHandleOpenURL:(NSURL *)url;

/**
 发起支付宝支付

 @param order order
 @param scheme scheme
 @param block block
 */
- (void)aliPayOrder:(NSString *)order
             scheme:(NSString *)scheme
          respBlock:(XXPayToolRespBlock)block;

#pragma mark - UnionPay -

/**
 银联支付结果回调
 */
@property (nonatomic, copy) XXPayToolRespBlock unionPayRespBlock;

/**
 处理银联通过URL启动App时传递回来的数据

 @param url url
 @return 返回值
 */
+ (BOOL)unionHandleOpenURL:(NSURL*)url;

/**
 发起银联支付

 @param serialNo serialNo
 @param viewController viewController
 @param block block
 */
- (void)unionPayWithSerialNo:(NSString *)serialNo
              viewController:(id)viewController
                   respBlock:(XXPayToolRespBlock)block;

@end
