//
//  User.h
//  SRWebSocketChat
//
//  Created by Madis on 16/5/13.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,copy  ) NSString *userID;
@property (nonatomic,copy  ) NSString *userName;
@property (nonatomic,assign) BOOL     sex;
@property (nonatomic,copy  ) NSString *other;

@end
