//
//  UTPushManager.m
//  UTPushService
//
//  Created by yons on 17/2/7.
//  Copyright © 2017年 liutao. All rights reserved.
//

#import "UTPushManager.h"
#import <UserNotifications/UserNotifications.h>

#define IOS_VERSION_10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)
#define IOS_VERSION_8 (NSFoundationVersionNumber_iOS_8_0 < NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)

@implementation UTPushManager

+ (UTPushManager *)sharedIstance{
    
    static UTPushManager *_sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstace = [[UTPushManager alloc] init];
    });
    
    return _sharedInstace;
}


#pragma mark - 基本信息获取
/**
 *  打开推送的日志 App上线之后关闭
 */
+ (void)UTtrunOnDebug {
    
    [CloudPushSDK turnOnDebug];
    
}

/**
 *  获取SDK版本号 也可以在ClondPushSDK.h中查看
 */
+ (void)UTgetVersion {
    
    [CloudPushSDK getVersion];

}

/**
 *  推送应用内通道是否打开
 */

+ (BOOL)UTisChannelOpened {

    return [CloudPushSDK isChannelOpened];

}

/**
 *  获取设备的deviceId
 */

+ (NSString *)UTgetDeviceId {

    return [CloudPushSDK getDeviceId];

}


#pragma mark - 绑定/解绑 账号

/**
 账号绑定

 @param account 绑定的账号名
 @param callBack 回调信息
 */
+ (void)UTbindAccount:(NSString *)account withCallBack:(CallbackHandler)callBack {

    [CloudPushSDK bindAccount:account withCallback:callBack];
}

/**
 解绑账号

 @param callback 回调
 */
+ (void)UTunbindAccount:(CallbackHandler)callback {

    [CloudPushSDK unbindAccount:callback];

}
#pragma mark - 标签/别名 绑定解绑



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
     withCallback:(CallbackHandler )callback {

    [CloudPushSDK bindTag:target
                 withTags:tags
                withAlias:alias
             withCallback:callback];
}

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
       withCallback:(CallbackHandler )callback {

    [CloudPushSDK unbindTag:target
                   withTags:tags
                  withAlias:alias
               withCallback:callback];

}

/**
 查询标签

 @param target 目标 类型 1：本设备
 @param callback 回调
 */
+ (void)UTlistTags:(int)target
      withCallback:(CallbackHandler)callback {

    [CloudPushSDK listTags:target
              withCallback:callback];

}

#pragma mark - 别名API

/**
 添加别名

 @param alias 别名
 @param callback 回调
 */
+ (void)UTaddAlias:(NSString *)alias
      withCallback:(CallbackHandler)callback {

    [CloudPushSDK addAlias:alias
              withCallback:callback];

}

/**
 删除别名

 @param alias 删除设备别名（alias为nil or length = 0时，删除设备全部别名）
 @param callback 回调
 */
+ (void)UTremoveAlias:(NSString *)alias
         withCallback:(CallbackHandler)callback {
    [CloudPushSDK removeAlias:alias
                 withCallback:callback];

}

/**
 查询别名

 @param callback 回调
 */
+ (void)UTlistAliases:(CallbackHandler)callback {
    [CloudPushSDK listAliases:callback];

}
#pragma mark - deviceToken API

/**
 上报设备的deviceToken到阿里云服务器

 @param deviceToken 向阿里云推送注册该设备的deviceToken
 @param callback 回调
 */
+ (void)UTregisterDevice:(NSData *)deviceToken
            withCallback:(CallbackHandler)callback {

    [CloudPushSDK registerDevice:deviceToken
                    withCallback:callback];

}
/**
 *  获取APNS 返回的DeviceToken
 */

+ (NSString *)UTgetDeviceTokenFromAPNS {
    
    return [CloudPushSDK getApnsDeviceToken];
    
}
#pragma mark - 上报”通知点击事件“API

/**
 上报“通知点击事件”ACK到推送服务器；

 @param userInfo 通知payload
 */
+ (void)UTsendNotificationAck:(NSDictionary *)userInfo {

    [CloudPushSDK sendNotificationAck:userInfo];

}
#pragma mark SDK Init
/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *
 */
+ (void)UTregisterAPNS:(UIApplication *)application {
    if (IOS_VERSION_10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded");
            }
        }];
    }else {
        
        // iOS 8 Notifications
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)categories:nil];
        [application registerUserNotificationSettings:
         settings];
        [application registerForRemoteNotifications];
    }
}


/**
 初始化SDK

 @param launchOptions didfinish里面的参数
 */
+ (void)UTinitCloudPush:(NSDictionary *)launchOptions{
    // SDK初始化
        [CloudPushSDK asyncInit:CloudPushKey appSecret:CloudPushSecret callback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSString *deviceId = [CloudPushSDK getDeviceId];
                NSLog(@"－－－－－－－－－－－－－－Push SDK init success, deviceId: %@.", deviceId);
            } else {
                
                NSLog(@"Push SDK init failed, error: %@", res.error);
                
            }
        }];
}

#pragma mark - 消息接收监听
/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}
#pragma mark - 通知打开监听

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}
/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知相关字段信息
    [self handleiOS10Notification:notification];
    // 通知不弹出
    //completionHandler(UNNotificationPresentationOptionNone);
    // 通知弹出，且带有声音、内容和角标（App处于前台时不建议弹出通知）
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}


/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
    }
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}
@end
