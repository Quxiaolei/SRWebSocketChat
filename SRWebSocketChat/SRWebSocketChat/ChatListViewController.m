//
//  ChatListViewController.m
//  SRWebSocketChat
//
//  Created by Madis on 16/5/14.
//
//

#import "ChatListViewController.h"
#import "ChatModel.h"
@interface ChatListViewController ()
<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
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
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"chatList" ofType:@"json"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
    ChatListModel *chatList = [ChatListModel yy_modelWithJSON:json1];
    _dataArray = chatList.messageArray;
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"user_table";
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
    [_store putObjectTopById:@"691" fromTable:@"user_table"];
    //查询所有对象并排序(YTKKeyValueItem)
    NSArray *itemArray = [_store getAllItemsFromTableDESC:@"user_table"];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    for (YTKKeyValueItem *item in itemArray) {
        ChatModel *model = [ChatModel yy_modelWithJSON:item.itemObject];
        [mutableArray addObject:model];
    }
    _dataArray = [mutableArray copy];
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
    }
    ChatModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld,%@,:%llu",indexPath.row,model.userName,model.userID];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",model.content,model.sendDate];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        ChatListViewController *vc = [[ChatListViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
}
@end
