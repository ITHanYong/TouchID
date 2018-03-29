//
//  TouchIDManager.h
//  TouchID
//
//  Created by HanYong on 2018/3/29.
//  Copyright © 2018年 HanYong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TouchIDManager : NSObject
// 当识别出现每一种情况是会发出通知
+ (void)validateTouchID;
@end
/*
 * 授权成功
 */
UIKIT_EXTERN NSString *const ValidateTouchIDSuccess;
/*
 * 取消按钮
 */
UIKIT_EXTERN NSString *const ValidateTouchIDCancel;
/*
 * 输入密码
 */
UIKIT_EXTERN NSString *const ValidateTouchIDInputPassword;
/*
 * 授权失败
 */
UIKIT_EXTERN NSString *const ValidateTouchIDAuthenticationFailed;
/*
 * 设备不可用
 */
UIKIT_EXTERN NSString *const ValidateTouchIDNotAvailable;
/*
 * 设备未设置指纹
 */
UIKIT_EXTERN NSString *const ValidateTouchIDNotEnrolled;
/*
 * 设备未设置密码
 */
UIKIT_EXTERN NSString *const ValidateTouchIDErrorPasscodeNotSet;
/*
 * 指纹设备被锁定
 */
UIKIT_EXTERN NSString *const ValidateTouchIDLockout;

