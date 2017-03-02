//
//  DNPayManager.m
//  DNPayDemo
//
//  Created by mainone on 2017/3/2.
//  Copyright © 2017年 mainone. All rights reserved.
//

#import "DNPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface DNPayManager ()<WXApiDelegate>

@end

@implementation DNPayManager

+ (instancetype)sharedInstance {
    static DNPayManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DNPayManager alloc] init];
    });
    return sharedInstance;
}

- (void)registerPay {
    //向微信注册
    [WXApi registerApp:@"wxb4ba3c02aa476ea1"];
}

#pragma mark - 支付宝支付
- (void)aliPayWithOrderString:(NSString *)orderString {
    if (orderString.length > 0) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"alipay result: %@", resultDic);
        }];
    }
}

#pragma mark - 微信支付
- (void)weChatPayWithDict:(NSDictionary *)dict {
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
        }else{
            NSLog(@"服务器返回错误，未获取到json对象");
        }
    }
}

- (void)openURL:(NSURL *)url {
    // 支付宝回调
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        return;
    }
    
    [WXApi handleOpenURL:url delegate:self];
    
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (void) onReq:(BaseReq*)req {
    
}

@end
