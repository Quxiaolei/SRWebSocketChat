//
//  MessageManager.h
//  MsgTest
//
//  Created by Madis on 16/2/18.
//  Copyright © 2016年 Madis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SocketOfflineStyle)
{
    SocketOfflineByServer  = 0,
    SocketOfflineByUser  = 1,
};

//typedef void (^ReceivedMessageCallBack)(BOOL isSucessed, NSString *eMsg);

@interface MessageManager : NSObject<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket        *socket;// socket
@property (nonatomic, assign) SocketOfflineStyle offlineStyle;
@property (nonatomic, copy  ) NSString           * socketHost;// socket的Host
@property (nonatomic, retain) NSTimer            * connectTimer;// 重连计时器
@property (nonatomic, copy  ) NSString           * receivedMessage;// 收到的消息内容(进一步封装)
+ (MessageManager *)sharedInstance;

-(void)socketConnect;// socket连接

-(void)socketCutOff;// 断开socket连接

@end
