//
//  UTPushManager.h
//  UTPushService
//
//  Created by yons on 17/2/7.
//  Copyright © 2017年 liutao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import "PushApiKey.h"
#import <UIKit/UIKit.h>


@interface UTPushManager : NSObject

+ (UTPushManager *)sharedIstance;

/**
 *  注册苹果推送，获取deviceToken用于推送
 */
+ (void)UTregisterAPNS:(UIApplication *)application;
/**
 初始化SDK
 
 @param launchOptions didfinish里面的参数
 */
+ (void)UTinitCloudPush:(NSDictionary *)launchOptions;
/**
 *  打开日志推送的日志 建议上线之后关闭
 */

+ (void)UTtrunOnDebug;

/**
 *  获取SDK版本号 也可以在ClondPushSDK.h中查看
 */
+ (void)UTgetVersion;

/**
 *  推送应用内通道是否打开
 */

+ (BOOL)UTisChannelOpened;
/**
 *  获取设备的deviceId
 */

+ (NSString *)UTgetDeviceId;
/**
 账号绑定
 
 @param account 绑定的账号名
 @param callBack 回调信息
 */
+ (void)UTbindAccount:(NSString *)account withCallBack:(CallbackHandler)callBack;
/**
 解绑账号
 
 @param callback 回调
 */
+ (void)UTunbindAccount:(CallbackHandler)callback;

/**
 绑定标签
 
 @param target 目标类型，1：本设备；2：本设备的绑定账号；3：别名
 @param tags 标签（数组输入）
 @param alias 别名（仅当target = 3 时生效）
 @param callback 回调
 */
+ (void)UTbindTag:(int)target
         withTags:(NSArray *)tags
        withAlias:(NSString *)alias
     withCallback:(CallbackHandler )callback;

/**
 解绑标签
 
 @param target 目标类型，1：本设备；2：本设备的绑定账号；3：别名
 @param tags 标签（数组输入）
 @param alias 别名（仅当target = 3 时生效）
 @param callback 回调
 */
+ (void)UTunbindTag:(int)target
           withTags:(NSArray *)tags
          withAlias:(NSString *)alias
       withCallback:(CallbackHandler )callback;
/**
 查询标签
 
 @param target 目标 类型 1：本设备
 @param callback 回调
 */
+ (void)UTlistTags:(int)target
      withCallback:(CallbackHandler)callback;
/**
 添加别名
 
 @param alias 别名
 @param callback 回调
 */
+ (void)UTaddAlias:(NSString *)alias
      withCallback:(CallbackHandler)callback;

/**
 删除别名
 
 @param alias 删除设备别名（alias为nil or length = 0时，删除设备全部别名）
 @param callback 回调
 */
+ (void)UTremoveAlias:(NSString *)alias
         withCallback:(CallbackHandler)callback;

/**
 查询别名
 
 @param callback 回调
 */
+ (void)UTlistAliases:(CallbackHandler)callback;

/**
 上报设备的deviceToken到阿里云服务器
 
 @param deviceToken 向阿里云推送注册该设备的deviceToken
 @param callback 回调
 */
+ (void)UTregisterDevice:(NSData *)deviceToken
            withCallback:(CallbackHandler)callback;
/**
 上报“通知点击事件”ACK到推送服务器；
 
 @param userInfo 通知payload
 */
+ (void)UTsendNotificationAck:(NSDictionary *)userInfo;

@end
