//
//  DNPayManager.h
//  DNPayDemo
//
//  Created by mainone on 2017/3/2.
//  Copyright © 2017年 mainone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DNPayManager : NSObject 

+ (instancetype)sharedInstance;

/**
 支付注册
 */
- (void)registerPay;


/**
 支付宝付款

 @param orderString 商户服务端直接将组装和签名后的请求串
 */
- (void)aliPayWithOrderString:(NSString *)orderString;

/**
 微信支付

 @param dict 订单信息
 */
- (void)weChatPayWithDict:(NSDictionary *)dict;

// 支付回调
- (void)openURL:(NSURL *)url;

@end
