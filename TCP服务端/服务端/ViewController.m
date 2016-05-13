//
//  ViewController.m
//  服务端
//
//  Created by iMac1 on 16/2/24.
//  Copyright © 2016年 iMac1. All rights reserved.
//

#import "ViewController.h"
#import "ServerSocket.h"

@interface ViewController () <ServerSocketDelegate>
@property (nonatomic, strong)ServerSocket * serverSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ServerSocket * serverSocket = [[ServerSocket alloc]init];
    self.serverSocket = serverSocket;
    serverSocket.delegate = self;
    
}

- (IBAction)open:(id)sender {
    [self.serverSocket open];
    [[NSRunLoop mainRunLoop]run];
    
}

- (void)socketDidReserveMessageFromClient:(NSString *)message{
    self.messageLabel.text = message;
}
@end
