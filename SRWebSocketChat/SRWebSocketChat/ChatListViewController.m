//
//  ChatListViewController.m
//  SRWebSocketChat
//
//  Created by Madis on 16/5/14.
//
//

#import "ChatListViewController.h"
#import "ChatDetailViewController.h"
#import "ChatListPreViewController.h"
@interface ChatListViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIViewControllerPreviewingDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic,strong) ChatListModel *chatList;
@property (nonatomic,strong) YTKKeyValueStore *store;
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
}

- (void)initData
{
    [self getTimeWithTimestamp:@"1463384109"];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"chatList" ofType:@"json"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
    ChatListModel *chatList = [ChatListModel yy_modelWithJSON:json1];
    _dataArray = [chatList.messageArray mutableCopy];
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"chatList_table";
    // 创建名为user_table的表，如果已存在，则忽略该操作
    [store createTableWithName:tableName];
    _store = store;
    /*!
     *  @author madis, 16-05-14 15:05:33
     *
     *  置顶操作改变--创建时间
     *
     *  收到消息时置顶位置变化也改变--创建时间
     *
     *  保存用户对象,使用userid做标示,排序使用创建时间
     */
    for (int i= 0; i<chatList.messageArray.count; i++) {
        //保存对象
        ChatModel *model = chatList.messageArray[i];
        NSDictionary *json = [model yy_modelToJSONObject];
//        NSDate *date =
        NSString *str = json[@"messageTime"];
        [store putObject:json withId:[NSString stringWithFormat:@"%llu",model.userID] intoTable:tableName];
    }
    
//    [store close];
    
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"chatDetail" ofType:@"json"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    NSDictionary *json2 = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    ChatDetailModel *chatDetail = [ChatDetailModel yy_modelWithJSON:json2];
}
- (void)createUI
{
    self.navigationItem.title = @"聊天列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightBarBtn)];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)rightBarBtn
{
    //置顶某条
    [_store putObjectTopById:@"691" fromTable:@"chatList_table"];
    NSDictionary *dict = [_store getObjectById:@"1" fromTable:@"chatList_table"];
    [_store putObject:dict withId:@"111111111" andCreateTime:[NSDate date] intoTable:@"chatList_table"];
    //查询所有对象并排序(YTKKeyValueItem.itemObject)
//    NSArray *itemObjectArray = [_store getAllItemsFromTableASC:@"chatList_table"];
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
//    for (NSDictionary *itemObject in itemObjectArray) {
//        ChatModel *model = [ChatModel yy_modelWithJSON:itemObject];
//        [mutableArray addObject:model];
//    }
    //查询所有对象并排序(YTKKeyValueItem)
    NSArray *itemObjectArray = [_store getAllItemsFromTableASC:@"chatList_table"];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    for (YTKKeyValueItem *item in itemObjectArray) {
        ChatModel *model = [ChatModel yy_modelWithJSON:item.itemObject];
        [mutableArray addObject:model];
    }
    _dataArray = mutableArray;
//    [_store close];
    [_tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"chatListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    ChatModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld,%@,:%llu",indexPath.row,model.userName,model.userID];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",model.content,model.sendDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatDetailViewController *vc = [[ChatDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UIViewControllerPreviewingDelegate
//peek手势
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    NSLog(@"李磊-section:%ld,index:%ld",(long)indexPath.section,(long)indexPath.row);
    
    ChatListPreViewController *childVC = [[ChatListPreViewController alloc] init];
    
    //在子视图中显示的某些部分
    //    childVC.preferredContentSize = CGSizeMake(0.0f,300.0f);
    //高亮区域
    //    CGRect rect = CGRectMake(0, indexPath.row * _tableView.rowHeight, kScreenWidth,_tableView.rowHeight);
    //    previewingContext.sourceRect = rect;
    return childVC;
}
//pop的代理方法，在此处可对将要进入的vc进行处理，比如隐藏tabBar；
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    viewControllerToCommit.hidesBottomBarWhenPushed = YES;
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark - 事件处理
- (void)changeDate:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YY/MM/dd,HH:mm"];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSinceNow:<#(NSTimeInterval)#>];
}
//获得时间戳
- (NSString * )getTimeWithTimestamp:(NSString *)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YY/MM/dd,HH:mm"];
    //    时间戳转时间的方法
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //获取当前时间
    NSDate *dateNow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:dateNow];
    //转换为本地时间,加上时区
    NSDate *localeDate = [dateNow  dateByAddingTimeInterval:interval];
    //转换时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    return confromTimespStr;
}
@end
