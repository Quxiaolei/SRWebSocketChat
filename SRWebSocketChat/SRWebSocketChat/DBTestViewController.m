//
//  DBTestViewController.m
//  SRWebSocketChat
//
//  Created by Madis on 16/5/14.
//
//

#import "DBTestViewController.h"
#import "User.h"
#import "ChatModel.h"

@interface DBTestViewController ()

@end

@implementation DBTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"DBTest";

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"DB" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.frame = CGRectMake(0, 0, 50, 50);
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)buttonClick{
    NSLog(@"李磊---");
    
#pragma mark  YYModel
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
    YYGHUser *user = [YYGHUser yy_modelWithJSON:json1];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"weibo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    @autoreleasepool {
        YYWeiboStatus *feed = [YYWeiboStatus yy_modelWithJSON:json];
        NSString *str = feed.scheme;
    }
    
    //校验json格式对不对
    //    if ([NSJSONSerialization isValidJSONObject:[feed yy_modelToJSONObject]]) {
    ////        [holder addObject:feed];
    //    }
    
#pragma mark  JSQMessage
    
    JSQMessage *message = [JSQMessage messageWithSenderId:@"1" displayName:@"张三" text:@"hello,我是张三"];
    
    
    // 将 Model 转换为 JSON 对象:
    //    NSDictionary *json = [user yy_modelToJSONObject];
    
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"user_table";
    // 创建名为user_table的表，如果已存在，则忽略该操作
    [store createTableWithName:tableName];
    // 保存
    NSString *key = @"1";
    NSDictionary *user1 = @{@"userid": @1, @"name": @"tangqiao我测试下大小", @"age": @30};
    NSDictionary *user2 = @{@"userid": @11, @"name": @"tangqiao1111", @"age": @130};
    NSDictionary *user3 = @{@"userid": @1111, @"name": @"tangqiao111", @"age": @11130};
    
    NSDictionary *messageDict = @{@"userid":@1,
                                  @"userName":@"微风",
                                  @"content":@"：麻蛋！！！[投降][投降][投降]",
                                  @"imageURL":@"http://c.hiphotos.baidu.com/zhidao/pic/item/ac345982b2b7d0a29ef1efc8cbef76094b369aaf.jpg"};
    
    /*!
     *  @author madis, 16-05-14 15:05:33
     *
     *  置顶操作改变--创建时间
     *
     *  收到消息时置顶位置变化也改变--创建时间
     *
     *  保存用户对象,使用userid做标示,排序使用创建时间
     */
    for (int i= 0; i<10; i++) {
        //保存对象
        [store putObject:user1 withId:[NSString stringWithFormat:@"%d",i+1] intoTable:tableName];
    }
    
    //删除对象
    //    [store deleteObjectById:5 fromTable:tableName];
    
    //查询所有对象并排序(YTKKeyValueItem)
    NSArray *array = [store getAllItemsFromTableDESC:tableName];
    //查询某个对象的数据(YTKKeyValueItem.itemObject)
    NSDictionary *queryUser = [store getObjectById:key fromTable:tableName];
    
    [store close];
    
    
    /*DataBaseTool *DBTool = [DataBaseTool shareInstance];
     
     [DBTool createDBTable:@"CREATE TABLE IF NOT EXISTS user (id integer PRIMARY KEY AUTOINCREMENT, userID text NOT NULL,userName text,sex boolean,other text);"];
     [DBTool createDBTable:@"CREATE TABLE IF NOT EXISTS chatDetail (id integer PRIMARY KEY AUTOINCREMENT, userID text NOT NULL,userName text,sex boolean,other text);"];
     [DBTool createDBTable:@"CREATE TABLE IF NOT EXISTS chatList (id integer PRIMARY KEY AUTOINCREMENT, userID text NOT NULL,userName text,sex boolean,other text);"];
     
     for (int i= 0; i< 1; i++) {
     User *user = [[User alloc]init];
     user.userID = [NSString stringWithFormat:@"%d",i];
     user.userName = [NSString stringWithFormat:@"%d 张三",i];
     user.sex = arc4random()%2;
     user.other = [NSString stringWithFormat:@"%d 其他",i];;
     
     [DBTool insertDataWithTable:[NSString stringWithFormat:@"INSERT INTO user (userID,userName,other,sex) VALUES ('%@', '%@','%@','%ld')",user.userID,user.userName,user.other,(long)user.sex]];
     }
     
     NSMutableArray *arry = [DBTool queryDataWithTable:@"SELECT * FROM user WHERE userID = 1" withDataObject:@"User"];*/
    
    //    [NSString stringWithFormat:@"INSERT INTO user (userID,userName,other) VALUES ('%@', '%@','%@')",@"1",@"张三",@"其他"]
}

@end
