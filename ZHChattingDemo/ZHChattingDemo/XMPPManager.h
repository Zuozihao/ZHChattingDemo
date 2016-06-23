//
//  XMPPManager.h
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/23.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kReceiveMessageNotification @"kReceiveMessageNotification"

typedef void(^SuccesBlock)(void);
typedef void(^GETFreindBlock)(NSArray *freinds);

@interface XMPPManager : NSObject

+ (instancetype)shareManager;

@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *password;

//@property(nonatomic,copy)void(^loginSuccesBlock)(void);

@property(nonatomic,copy)SuccesBlock loginSucessBlock;  //登陆回调block
@property(nonatomic,copy)SuccesBlock registeSucessBlock; //注册回调block
@property(nonatomic,copy)GETFreindBlock getFreindBlock;   //获取好友回调block

- (void)goOnline;  //上线
- (void)goOffline; //下线


//1.登陆
- (void)login:(NSString *)username
     password:(NSString *)password
 successBlock:(SuccesBlock)block;

//2.注册
- (void)registe:(NSString *)username
       password:(NSString *)password
   successBlock:(SuccesBlock)block;

//3.获取好友列表
- (void)getFreind:(GETFreindBlock)block;

//4.添加好友

//5.发消息
- (void)sendMessage:(NSString *)msg toUser:(NSString *)userJID;


@end
