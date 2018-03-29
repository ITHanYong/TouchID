//
//  TouchIDManager.m
//  TouchID
//
//  Created by HanYong on 2018/3/29.
//  Copyright © 2018年 HanYong. All rights reserved.
//

#import "TouchIDManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define DeviceVersion [[UIDevice currentDevice]systemVersion].doubleValue
/*
 * 授权成功
 */
NSString *const ValidateTouchIDSuccess = @"ValidateTouchIDSuccess";
/*
 * 取消按钮
 */
NSString *const ValidateTouchIDCancel = @"ValidateTouchIDCancel";
/*
 * 输入密码
 */
NSString *const ValidateTouchIDInputPassword = @"ValidateTouchIDInputPassword";
/*
 * 授权失败
 */
NSString *const ValidateTouchIDAuthenticationFailed = @"ValidateTouchIDAuthenticationFailed";
/*
 * 设备指纹不可用
 */
NSString *const ValidateTouchIDNotAvailable = @"ValidateTouchIDNotAvailable";
/*
 * 设备未设置指纹
 */
NSString *const ValidateTouchIDNotEnrolled = @"ValidateTouchIDNotEnrolled";
/*
 * 设备未设置密码
 */
NSString *const ValidateTouchIDErrorPasscodeNotSet = @"ValidateTouchIDErrorPasscodeNotSet";
/*
 * 指纹设备被锁定
 */
NSString *const ValidateTouchIDLockout = @"ValidateTouchIDLockout";

@implementation TouchIDManager

+ (void)validateTouchID
{
    // 判断系统是否是iOS8.0以上 8.0以上可用
    if (!([[UIDevice currentDevice]systemVersion].doubleValue >= 8.0)) {
        NSLog(@"系统不支持");
        return;
    }
    // 创建LAContext对象
    LAContext *authenticationContext = [[LAContext alloc]init];
    NSError *error = nil;
    authenticationContext.localizedFallbackTitle = @"";
    
    [authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (error.code == LAErrorTouchIDLockout && DeviceVersion >= 9.0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDLockout object:nil];
        [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [self validateTouchID];
            }
        }];
        return;
    }
    [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 指纹识别错误调用分为以下情况,
            // 点击取消按钮 : domain = com.apple.LocalAuthentication code = -2
            // 点击输入密码按钮 : domain = com.apple.LocalAuthentication code = -3
            // 输入密码重新进入指纹系统 : domain = com.apple.LocalAuthentication code = -8
            // 指纹三次错误 : domain = com.apple.LocalAuthentication code = -1
            // 指纹验证成功 : error = nil
            if (error) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        NSLog(@"LAErrorAuthenticationFailed");
                        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDAuthenticationFailed object:nil];
                        break;
                    case LAErrorUserCancel:
                        // 点击取消按钮
                        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDCancel object:nil];
                        break;
                    case LAErrorUserFallback:
                        // 用户点击输入密码按钮
                        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDInputPassword object:nil];
                        break;
                    case LAErrorPasscodeNotSet:
                        //没有在设备上设置密码
                        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDErrorPasscodeNotSet object:nil];
                        break;
                    case LAErrorTouchIDNotAvailable:
                        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDNotAvailable object:nil];
                        //设备不支持TouchID
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDNotEnrolled object:nil];
                        break;
                        //设备没有注册TouchID
                    case LAErrorTouchIDLockout:
                        [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDLockout object:nil];
                        if (DeviceVersion >= 9.0) {
                            [self validateTouchID];
                        }
                        break;
                    default:
                        break;
                }
                return ;
            }
            // 说明验证成功,如果要刷新UI必须在这里回到主线程
            [[NSNotificationCenter defaultCenter]postNotificationName:ValidateTouchIDSuccess object:nil];
        });
    }];
}


@end
