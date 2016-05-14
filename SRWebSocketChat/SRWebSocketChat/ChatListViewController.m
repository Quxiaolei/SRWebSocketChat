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
@property (nonatomic,strong) ChatListModel *chatList;

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
    _chatList = [ChatListModel yy_modelWithJSON:json1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"chatDetail" ofType:@"json"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    NSDictionary *json2 = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
    ChatDetailModel *chatDetail = [ChatDetailModel yy_modelWithJSON:json2];
}
- (void)createUI
{
    self.navigationItem.title = @"聊天列表";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chatList.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"chatListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    ChatModel *model = _chatList.messageArray[indexPath.row];
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
