//
//  DataBaseTool.m
//  SRWebSocketChat
//
//  Created by Madis on 16/5/13.
//
//

#import "DataBaseTool.h"

@implementation DataBaseTool
{
    FMDatabase *_dataBase;
}

static DataBaseTool *_instance;

+ (id)shareInstance
{
    //里面的代码永远都只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (BOOL)getDBTable:(NSString *)tableName
{
    if(!_dataBase){
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [doc stringByAppendingPathComponent:@"chat.sqlite"];
        NSLog(@"李磊---%@",filePath);
        _dataBase = [FMDatabase databaseWithPath:filePath];
    }
    
    if ([_dataBase open]) {
        BOOL result=[_dataBase executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (id integer PRIMARY KEY AUTOINCREMENT, userID text NOT NULL,userName text,sex blob,other text);",tableName]];
        if (result) {
            NSLog(@"创表%@成功",tableName);
        }else{
            NSLog(@"创表%@失败",tableName);
            return NO;
        }
    }else{
        [_dataBase close];
        return NO;
    }
    [_dataBase close];
    return YES;
}
- (BOOL)insertDataWithObject:(id *)object
{
    if (![_dataBase open]) {
        [_dataBase close];
        return NO;
    }else{
        BOOL res = [_dataBase executeUpdate:[NSString stringWithFormat:@"INSERT INTO user (userID,userName,other) VALUES ('%@', '%@','%@')",@"1",@"张三",@"其他"]];
        if (res) {
            NSLog(@"成功插入数据");
        } else {
            NSLog(@"插入数据失败");
        }
        [_dataBase close];
    }
    return YES;
}

- (BOOL)deleteDataWithCreateTime:(NSString *)string
{
    if ([_dataBase open]) {
        // 1.执行查询语句
        BOOL res = [_dataBase executeUpdate:@"DELETE FROM localData WHERE createTime = ?;",string];
        if (!res) {
            NSLog(@"删除失败");
        } else {
            NSLog(@"删除成功");
        }
    }
    [_dataBase close];
    return YES;
}

- (NSMutableArray *)queryDataWithString:(NSString *)string
{
    NSMutableArray * arry = [[NSMutableArray alloc]initWithCapacity:0];
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath= [doc stringByAppendingPathComponent:@"LoanSQL.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:filePath];
    if ([db open]) {
        // 1.执行查询语句
        //@"SELECT * FROM localData WHERE createTime = ?"
        FMResultSet * resultSet = [db executeQuery:string];
        // 2.遍历结果
        while ([resultSet next]) {
//            SMLoan * loan = [[SMLoan alloc]init];
//            loan.ID = [resultSet intForColumn:@"id"];
//            loan.createTime = [[resultSet stringForColumn:@"createTime"]integerValue];
//            loan.myLoanID = [resultSet stringForColumn:@"loanID"];
//            //            loan.myLoanID = [NSString stringWithFormat:@"%ld%d%d%d",(long)loan.createTime,arc4random()%10,arc4random()%10,arc4random()%10];
//            //            loan.loanID = [NSString stringWithFormat:@"%ld%d%d%d",(long)loan.createTime,arc4random()%10,arc4random()%10,arc4random()%10];
//            loan.file1 = [resultSet dataForColumn:@"file1"];
//            loan.file2 = [resultSet dataForColumn:@"file2"];
//            loan.file3 = [resultSet dataForColumn:@"file3"];
//            loan.file4 = [resultSet dataForColumn:@"file4"];
//            loan.file5 = [resultSet dataForColumn:@"file5"];
//            //6为数组的data类型
//            loan.file6 = [resultSet dataForColumn:@"file6"];
//            loan.mutableImageData = [resultSet dataForColumn:@"mutableImageData"];
//            loan.tagArrayData = [resultSet dataForColumn:@"tagArrayData"];
//            //            NSLog(@"%ld %ld %@", (long)loan.ID, (long)loan.createTime, loan.file1);
//            [arry addObject:loan];
        }
        [resultSet close];
    }
    [db close];
    return arry;
}

#pragma mark - 解档/归档
- (BOOL)setUserDefaultsWithObjectArray:(NSArray *)objectArray keyArray:(NSArray *)keyArray
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < objectArray.count; i++){
        [userDefault setObject:objectArray[i] forKey:keyArray[i]];
    }
    [userDefault synchronize];
    return YES;
}

- (BOOL)archiverWithObjectArray:(NSArray *)objectArray keyArray:(NSArray *)keyArray
{
    //    NSArray *array = [NSArray arrayWithObjects:@"zhangsan",@"lisi",nil];
    /**
     *  先从文件中解档,获得数据,然后追加数据
     */
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    //编码
    for (int i = 0; i < objectArray.count; i++){
        [archiver encodeObject:objectArray[i] forKey:keyArray[i]];
    }
    //完成编码，将上面的归档数据填充到data中，此时data中已经存储了归档对象的数据
    [archiver finishEncoding];
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/userData"];
    BOOL success = [data writeToFile:filePath atomically:YES];
    if(success){
        NSLog(@"用户信息,归档成功");
        return YES;
    }
    return NO;
}
- (NSMutableArray * )getUserDefaultsWithKeyArray:(NSArray *)keyArray
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:keyArray.count];
    
    for (int i = 0; i < keyArray.count; i++){
        if (![userDefault stringForKey:keyArray[i]]) {
            return nil;
        }
        [array addObject:[userDefault stringForKey:keyArray[i]]];
    }
    return array;
}

- (NSMutableArray *)unarchiverWithKeyArray:(NSArray *)keyArray
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/userData"];
    //读取归档数据
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    if (!data) {
        return nil;
    }
    //创建解归档对象，对data中的数据进行解归档
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:keyArray.count];
    //解归档
    
    for (int i = 0; i < keyArray.count; i++){
        NSLog(@"%@",keyArray[i]);
        [array addObject:[unarchiver decodeObjectForKey:keyArray[i]]];
    }
    return array;
}

#pragma mark - 时间戳处理
//获取当前时间戳
- (NSString * )getCurrentTimeStamp
{
    //获取当前时间
    NSDate *dateNow = [NSDate date];
    NSTimeInterval aInterval =[dateNow timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f",aInterval];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dateNow];
    //转换为本地时间,加上时区
    NSDate *localeDate = [dateNow  dateByAddingTimeInterval: interval];
    //转换时间戳
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    
    //    NSLog(@"localeDate:%@", localeDate);
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}
@end
