//
//  ServerSocket.h
//  Socket服务端
//
//  Created by iMac1 on 16/2/24.
//  Copyright © 2016年 iMac1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import <CFNetwork/CFNetwork.h>

#define ServerSocketPort 9000

@protocol ServerSocketDelegate <NSObject>

- (void)socketDidReserveMessageFromClient:(NSString *)message;

@end


@interface ServerSocket : NSObject <GCDAsyncSocketDelegate>
@property (nonatomic, weak)id <ServerSocketDelegate> delegate;

@property (nonatomic, strong)GCDAsyncSocket * serverSocket;

@property (nonatomic, strong)NSMutableArray * clientSockets;

- (void)open;

- (void)disconnect;

@end
