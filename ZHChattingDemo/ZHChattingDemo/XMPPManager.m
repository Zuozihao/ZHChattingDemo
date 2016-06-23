//
//  XMPPManager.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/23.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "XMPPManager.h"
#import <SVProgressHUD.h>

@implementation XMPPManager
{
    XMPPStream *_xmppStream;
    BOOL _isRegiste;
}

//创建单例
+ (instancetype)shareManager {
    
    static XMPPManager *instance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[[self class] alloc] init];
        
        [instance setupStream];
    });
    
    return instance;
}


- (void)setupStream {
    
    //1.创建XMPPStream对象
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    //2.创建
    XMPPReconnect *xmmppReconnect = [[XMPPReconnect alloc] init];
    [xmmppReconnect activate:_xmppStream];
    
    //3.创建花名册对象，用于维护好友关系的
    XMPPRosterCoreDataStorage *xmppRosterStoage = [[XMPPRosterCoreDataStorage alloc] init];
    XMPPRoster *xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStoage];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster activate:_xmppStream];
    
    //4.设置xmpp服务器信息： ip\端口
    [_xmppStream setHostName:kHostname];
    //服务器端口
    [_xmppStream setHostPort:5222];
}

- (void)goOnline {
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [_xmppStream sendElement:presence];
    
}

- (void)goOffline {
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
    
}


//1.登陆
- (void)login:(NSString *)username
     password:(NSString *)password
 successBlock:(SuccesBlock)block {
    
    self.username = username;
    self.password = password;
    self.loginSucessBlock = block;
    
    _isRegiste = NO;
    
    //1.发送连接请求
    
    //2.创建用于登陆的JID
    NSString *jidstring = [NSString stringWithFormat:@"%@@%@",username,kHostname];
    XMPPJID *jid = [XMPPJID jidWithString:jidstring];
    
    [_xmppStream setMyJID:jid];
    
    
    //3.发送连接
    [_xmppStream connectWithTimeout:30 error:nil];
    
}

//2.注册
- (void)registe:(NSString *)username
       password:(NSString *)password
   successBlock:(SuccesBlock)block {
    
    self.username = username;
    self.password = password;
    self.registeSucessBlock = block;
    
    _isRegiste = YES;
    
    //因为没有账号，需要发送匿名连接
    NSString *jidString = [NSString stringWithFormat:@"anonymous@%@",kHostname];
    XMPPJID *jid = [XMPPJID jidWithString:jidString];
    
    [_xmppStream setMyJID:jid];
    
    
    [_xmppStream connectWithTimeout:30 error:nil];
    
    
}

//3.获取好友列表
/*
 获取好友 XML格式：
 <iq type="get"
 　　from="xiaoming@example.com"
 　　to="example.com"
 　　id="1234567">
 　　<query xmlns="jabber:iq:roster"/>
 <iq />
 
 type 属性，说明了该 iq 的类型为 get，与 HTTP 类似，向服务器端请求信息
 from 属性，消息来源，这里是你的 JID
 to 属性，消息目标，这里是服务器域名
 id 属性，标记该请求 ID，当服务器处理完毕请求 get 类型的 iq 后，响应的 result 类型 iq 的 ID 与 请求 iq 的 ID 相同
 <query xmlns="jabber:iq:roster"/> 子标签，说明了客户端需要查询 roster
 
 
 */
- (void)getFreind:(GETFreindBlock)block {
    
    self.getFreindBlock = block;
    
    XMPPJID *jid = _xmppStream.myJID;
    
    DDXMLElement *iq = [[DDXMLElement alloc] initWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"from" stringValue:jid.description];
    [iq addAttributeWithName:@"to" stringValue:jid.domain];
    [iq addAttributeWithName:@"id" stringValue:@"123456"];
    
    DDXMLElement *query = [DDXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    [iq addChild:query];
    
    //异步发送获取好友列表的请求
    [_xmppStream sendElement:iq];
}

//5.发消息
/*
 
 发送消息的XML格式：
 
 <message type="chat" to="xiaoming@example.com">
 
 　　<body>Hello World!</body>
 
 </message>
 
 */
- (void)sendMessage:(NSString *)msg toUser:(NSString *)userJID {
    
    if (msg.length == 0 || userJID.length == 0) {
        
        return;
    }
    
    DDXMLElement *message = [DDXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:userJID];
    
    DDXMLElement *body = [DDXMLElement elementWithName:@"body" stringValue:msg];
    
    [message addChild:body];
    
    NSLog(@"发送：%@",message.XMLString);
    
    [_xmppStream sendElement:message];
//    DDXMLElement *body = [DDXMLElement elementWithName:@"body"];
//    [body setStringValue:msg];
//    DDXMLElement *message = [DDXMLElement elementWithName:@"message"];
//    [message addAttributeWithName:@"type" stringValue:@"chat"];
//    NSString *to = [NSString stringWithFormat:@"%@127.0.0.1", userJID];
//    [message addAttributeWithName:@"to" stringValue:to];
//    [message addChild:body];
//    [_xmppStream sendElement:message];
}



#pragma mark - XMPPStream delegate
//1.连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    if (_isRegiste) {
        
        NSString *jidstring = [NSString stringWithFormat:@"%@@%@",self.username,kHostname];
        XMPPJID *jid = [XMPPJID jidWithString:jidstring];
        [_xmppStream setMyJID:jid];
        
        //发送注册
        [_xmppStream registerWithPassword:_password error:nil];
        
        
    } else {
        
        //发送登陆请求
        
        //验证登陆密码
        [_xmppStream authenticateWithPassword:_password error:nil];
    }
    
    
}

//2.登陆验证密码成功
//XMPP
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    //    NSLog(@"登陆成功");
    
    //需要将登陆成功的事件 ----> 控制器对象
    //block   代理   通知
    self.loginSucessBlock();
    
    [self goOnline];
    
    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
}

//3.登陆密码验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    
    NSLog(@"%@",error);
}


//4.注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    
    self.registeSucessBlock();
    
}

//5.注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    NSLog(@"注册失败：%@",error);
}

//6.获取好友列表
/*
 好友列表的XML格式：
 
 <iq type="result"
 　　id="1234567"
 　　to="xiaoming@example.com">
 　　<query xmlns="jabber:iq:roster">
 　　　　<item jid="xiaoyan@example.com" name="小燕" />
 　　　　<item jid="xiaoqiang@example.com" name="小强"/>
 　　<query />
 <iq />
 
 type 属性，说明了该 iq 的类型为 result，查询的结果
 <query xmlns="jabber:iq:roster"/> 标签的子标签 <item />，为查询的子项，即为 roster
 item 标签的属性，包含好友的 JID，和其它可选的属性，例如昵称等。
 
 */
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    /*
     [
     {name:zhangsan,id:11122},
     {name:zhangsan,id:11122},
     {name:zhangsan,id:11122}
     ]
     */
    
    NSMutableArray *freindArray = [NSMutableArray array];
    if ([iq.type isEqualToString:@"result"]) {
        
        DDXMLElement *query = [iq childElement];
        if ([query.name isEqualToString:@"query"]) {
            
            NSArray *childrens = [query children];
            
            [childrens enumerateObjectsUsingBlock:^(DDXMLElement *e, NSUInteger idx, BOOL *stop) {
                
                NSString *jid = [e attributeStringValueForName:@"jid"];
                NSString *name = [e attributeStringValueForName:@"name"];
                
                if (jid.length == 0) {
                    return;
                }
                
                if (name.length == 0) {
                    name = jid;
                }
                
                NSDictionary *freind = @{
                                         @"name":name,
                                         @"jid":jid
                                         };
                
                [freindArray addObject:freind];
            }];
            
            if (self.getFreindBlock != nil) {
                //回调block，将好友数据返回给外部
                self.getFreindBlock(freindArray);
            }
        }
        
    }
    
    return YES;
}

//接受好友的消息
/*
 消息的XML格式：
 
 <message xmlns="jabber:client"
 id="37Moq-35"
 to="study20@xmpp.wxhl.com/e5c18b0d"
 from="wxhl@xmpp.wxhl.com/spark"
 type="chat">
 
 <body>haha</body>  //消息内容
 
 <thread>69TU9u</thread>
 <x xmlns="jabber:x:event">
 <offline/>
 <composing/>
 </x>
 </message>
 
 */
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    /*
     {
     “text”:消息内容
     “jid”:好友的id
     }
     */
    
    // block  代理  是1对1通讯
    //通知         1对象多
    
    
    XMPPJID *fromJID = message.from;
    NSString *fromUsername = fromJID.user;
    NSString *fromJIDString = fromJID.description;
    NSArray *items = [fromJIDString componentsSeparatedByString:@"/"];
    fromJIDString = items.firstObject;
    
    if (fromUsername == nil) {
        fromUsername = fromJIDString;
    }
    
    NSString *body = message.body;
    if (body.length == 0 || fromJIDString.length == 0) {
        return;
    }
    
    NSDictionary *msg = @{
                          @"jid":fromJIDString,
                          @"fromUser":fromUsername,
                          @"text":body
                          };
    
    
    //发送收到消息的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveMessageNotification object:msg];
}


@end
