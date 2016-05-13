//
//  MessageManager.m
//  MsgTest
//
//  Created by Madis on 16/2/18.
//  Copyright © 2016年 Madis. All rights reserved.
//

#import "MessageManager.h"

@implementation MessageManager

+ (MessageManager *)sharedInstance
{
    static MessageManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

//连接
//需要回调
-(void)socketConnect
{
    self.socket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.socketHost]]];
    self.socket.delegate =self;
    [self.socket open];
}

//重连
-(void)socketReconnect{

//    SR_CONNECTING   = 0,
//    SR_OPEN         = 1,
//    SR_CLOSING      = 2,
//    SR_CLOSED       = 3,

    if(self.socket.readyState != SR_OPEN){
        //重连
        [self.socket open];
        [self.connectTimer invalidate];
        self.connectTimer = nil;
    }
}
//断开
-(void)socketCutOff
{
    self.offlineStyle = SocketOfflineByUser;
    [self.connectTimer invalidate];
    self.connectTimer = nil;
    [self.socket close];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"已连接");
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(socketReconnect) userInfo:nil repeats:YES];
    [self.connectTimer fire];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败");
    if (self.offlineStyle == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self socketReconnect];
    }else if (self.offlineStyle == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"接收消息:\n %@",message);
    self.receivedMessage = (NSString *)message;
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    /**
     *  收到消息直接保存在sql中,不需要回调
     */
}
@end
