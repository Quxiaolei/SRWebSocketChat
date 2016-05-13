//
//  ServerSocket.m
//  Socket服务端
//
//  Created by iMac1 on 16/2/24.
//  Copyright © 2016年 iMac1. All rights reserved.
//

#import "ServerSocket.h"

@implementation ServerSocket

- (void)open{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    GCDAsyncSocket * serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:queue];
    
    NSError * error ;
    [serverSocket acceptOnPort:ServerSocketPort error:&error];
    self.serverSocket = serverSocket;
    if (error) {
        NSLog(@"服务端打开失败");
    }else{
        NSLog(@"服务端打开成功");
    }
}

- (void)socket:(GCDAsyncSocket *)serverSockket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{
    [self.clientSockets addObject:clientSocket];
    
    NSLog(@"当前有%ld个客户端连接 serverSockket:%@   clientSocket:%@",self.clientSockets.count,serverSockket,clientSocket);
    
    NSString * message = @"此消息由服务端发出!\n";
    NSData * data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [clientSocket writeData:data withTimeout:-1 tag:0];
    
    [clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"clientSocket:%@  host:%@  port:%d",clientSocket,clientSocket.connectedHost,clientSocket.connectedPort);
    
    NSString * message = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"来自客户端的消息:%@",message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(socketDidReserveMessageFromClient:)]) {
            [self.delegate socketDidReserveMessageFromClient:[NSString stringWithFormat:@"来自客户端的消息:%@",message]];
        }
    });
    
    if ([message isEqualToString:@"disconnect"]) {
        [self.clientSockets removeObject:clientSocket];
    }else{
        for (GCDAsyncSocket * socket in self.clientSockets) {
            if (socket != clientSocket) {
                [socket writeData:data withTimeout:-1 tag:0];
            }
        }
    }
    
    [clientSocket readDataWithTimeout:-1 tag:0];
}

- (NSMutableArray *)clientSockets{
    if (!_clientSockets) {
        _clientSockets = [[NSMutableArray alloc]init];
    }return _clientSockets;
}

- (void)disconnect{
    [self.clientSockets removeAllObjects];
}

@end
