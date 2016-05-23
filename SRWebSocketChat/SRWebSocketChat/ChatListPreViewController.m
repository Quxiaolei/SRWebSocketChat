//
//  ChatListPreViewController.m
//  SRWebSocketChat
//
//  Created by Madis on 16/5/21.
//
//

#import "ChatListPreViewController.h"

@interface ChatListPreViewController ()

@end

@implementation ChatListPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *bgView =[[UIView alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, kScreenHeight - 20 - 64 * 2)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    [self.view addSubview:bgView];
    UILabel *label = [[UILabel alloc] initWithFrame:bgView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"有种再按重一点...";
    [bgView addSubview:label];
}
-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"标题1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"标题1");
    }];
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"标题2" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"标题2");
    }];
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"标题3" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"标题3");
    }];
    
    NSArray * actions = @[action1,action2,action3];
    return actions;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
