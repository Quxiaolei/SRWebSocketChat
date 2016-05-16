//
//  ChatDetailViewController.m
//  SRWebSocketChat
//
//  Created by Madis on 16/5/14.
//
//

#import "ChatDetailViewController.h"
@interface ChatDetailViewController ()
<JSQMessagesComposerTextViewPasteDelegate,
UIActionSheetDelegate
>
@property (nonatomic, strong) NSMutableArray *messageArray;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

//为了双方头像
@property (strong, nonatomic) ChatDetailModel *chatDetail;
@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initView];
}
- (void)initData
{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"chatDetail" ofType:@"json"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
    ChatDetailModel *chatDetail = [ChatDetailModel yy_modelWithJSON:json1];
    _chatDetail = chatDetail;
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    for (ChatModel * model in chatDetail.messageArray) {
        JSQMessage *message = [[JSQMessage alloc]initWithSenderId:[NSString stringWithFormat:@"%llu",model.userID] senderDisplayName:model.userName date:model.sendDate text:model.content];
        [mutableArray addObject:message];
    }
    _messageArray = mutableArray;

    //!!!: 必须
    //发送者id
    self.senderId = [NSString stringWithFormat:@"%llu",chatDetail.fromUserID];
    //发送者name
    self.senderDisplayName = [NSString stringWithFormat:@"%@",chatDetail.fromUserName];
}

- (void)initView
{
    self.navigationItem.title = [NSString stringWithFormat:@"与%@聊天中...",self.senderDisplayName];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(rightBarBtn)];
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc]initWithTitle:@"发消息" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtn)],
                                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refRightBarBtn)]];
    //绘制气泡
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    //更早消息
    self.showLoadEarlierMessagesHeader = YES;
    //输入框
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    //隐藏左侧多媒体输入按钮
    self.inputToolbar.contentView.leftBarButtonItemWidth = CGFLOAT_MIN;
    self.inputToolbar.contentView.leftContentPadding = CGFLOAT_MIN;
    //单元格自定义点击操作
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"自定义操作"
                                                                                      action:@selector(customAction:)] ];
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    //collectionCell布局
    //    messageBubbleLeftRightMargin
    //    messageBubbleFont
//    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont systemFontOfSize:100];
    //根据显示情况?--改变topLabel的高度

}
//???: 卵用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
    [self.inputToolbar.contentView.textView endEditing:YES];
}
- (void)refRightBarBtn
{
    //切换数据
    NSLog(@"李磊----发送数据");
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"chatDetail" ofType:@"json"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary *json1 = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"test.db"];
    NSString *tableName = @"chatDetail_table";
    // 创建名为user_table的表，如果已存在，则忽略该操作
    [store createTableWithName:tableName];
    
    //!!!: 祈祷返回json数据是时间排好序的
    NSArray *array = json1[@"chatList"];
    for (NSDictionary *modelDict in array) {
        NSString *userID = modelDict[@"userid"];
        [store putObject:modelDict withId:userID intoTable:tableName];
    }
    
    //查询所有对象并排序(YTKKeyValueItem)
    NSArray *itemArray = [store getAllObjectsFromTableASC:@"chatDetail_table"];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *objectDict in itemArray) {
        ChatModel *model = [ChatModel yy_modelWithJSON:objectDict];
        JSQMessage *message = [[JSQMessage alloc]initWithSenderId:[NSString stringWithFormat:@"%llu",model.userID] senderDisplayName:model.userName date:model.sendDate text:model.content];
        [mutableArray addObject:message];
    }
//    for (YTKKeyValueItem *item in itemArray) {
//        ChatModel *model = [ChatModel yy_modelWithJSON:item.itemObject];
//        JSQMessage *message = [[JSQMessage alloc]initWithSenderId:[NSString stringWithFormat:@"%llu",model.userID] senderDisplayName:model.userName date:model.sendDate text:model.content];
//        [mutableArray addObject:message];
//    }
    _messageArray = mutableArray;
    [self finishReceivingMessageAnimated:YES];
    NSLog(@"李磊----数据切换成功");
    [self.collectionView reloadData];
}
- (void)rightBarBtn
{
    //收消息测试
    self.showTypingIndicator = !self.showTypingIndicator;
    [self scrollToBottomAnimated:YES];
    JSQMessage *copyMessage = [[_messageArray lastObject] copy];
    if (!copyMessage) {
        copyMessage = [JSQMessage messageWithSenderId:@"11111111"
                                          displayName:@"我是填充的"
                                                 text:@"First received!"];
    }
    [_messageArray addObject:copyMessage];
    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
    [self finishReceivingMessageAnimated:YES];
    [self.collectionView reloadData];
}


#pragma mark - JSQMessagesViewController method overrides

//发送按钮点下
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    [self.messageArray addObject:message];
    [self finishSendingMessageAnimated:YES];
}

//左侧多媒体出入按钮
- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
    [sheet showFromToolbar:self.inputToolbar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
        return;
    }
    switch (buttonIndex) {
        case 0:
//            [self.demoData addPhotoMediaMessage];
            break;
        case 1:
        {
//            __weak UICollectionView *weakView = self.collectionView;
//            [self.demoData addLocationMediaMessageCompletion:^{
//                [weakView reloadData];
//            }];
        }
            break;
        case 2:
//            [self.demoData addVideoMediaMessage];
            break;
    }
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - JSQMessages CollectionView DataSource
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messageArray objectAtIndex:indexPath.item];
}

//删除某条消息
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messageArray removeObjectAtIndex:indexPath.item];
}
//头像
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageArray objectAtIndex:indexPath.item];
    
    //    _chatDetail.fromHeadImgURL
    JSQMessagesAvatarImage *cookImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:[message.senderId isEqualToString:self.senderId] ?@"demo_avatar_cook":@"demo_avatar_jobs"]
                                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    return cookImage;
}
//消息气泡
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageArray objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.incomingBubbleImageData;
}
//顶部显示时间label
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messageArray objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
//    }
    return nil;
}
//顶部显示发送者名称label
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageArray objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messageArray objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}
//底部label
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messageArray count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messageArray objectAtIndex:indexPath.item];
    if (!msg.isMediaMessage) {
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}

#pragma mark - Custom menu items
//是否允许单元格自定义点击
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}
//单元格自定义点击事件
- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    [[[UIAlertView alloc] initWithTitle:@"单元格的自定义操作"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}

#pragma mark - Adjusting cell label heights
//设置时间label高度
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messageArray objectAtIndex:indexPath.item];
    
    //默认显示第一个发送时间
    if (indexPath.item - 1>= 0) {
        JSQMessage *reMessage = [self.messageArray objectAtIndex:indexPath.item-1];
        NSLog(@"李磊--%@--%@--%d",message.date,reMessage.date,[message.date isEqualToDate:reMessage.date]);
        if([message.date isEqualToDate:reMessage.date]){
            return CGFLOAT_MIN;
        }
    }
//    if (indexPath.item % 3 == 0) {
        //!!!: 和上边的topLabel对应
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
//    }
//    return 0.0f;
}
//设置消息气泡上label的高度
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *currentMessage = [self.messageArray objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messageArray objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}
//单元格底部label高度
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

//点击加载之前消息
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}
//点击头像
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}
//点击消息气泡
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}
//点击单元格
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods
//输入框粘贴
- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.messageArray addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}
@end
