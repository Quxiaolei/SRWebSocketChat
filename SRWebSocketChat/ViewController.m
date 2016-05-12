//
//  ViewController.m
//  SRWebSocketChat
//
//  Created by Madis on 16/5/11.
//
//

#import "ViewController.h"
#import "MessageManager.h"

@interface ViewController ()
<SRWebSocketDelegate
>
@property (nonatomic,strong)SRWebSocket *webSocket;
@property (weak, nonatomic) IBOutlet UITextField *sendMsgTextField;
@property (weak, nonatomic) IBOutlet UITextView *receiveMsgTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self connectServer:@"" port:21];
}

//- (void) connectServer: (NSString *) hostIP port:(int) hostPort{
//
//    if (client == nil) {
//        client = [[AsyncSocket alloc] initWithDelegate:self];
//        NSError *err = nil;
//        //192.168.110.128
//        if (![client connectToHost:hostIP onPort:hostPort error:&err]) {
//            NSLog(@"%@ ", [err localizedDescription]);
//        } else {
//            NSLog(@"Conectou!");
//        }
//    }
//    else {
//        [client readDataWithTimeout:-1 tag:0];
//    }
//}


- (void)connectSocket
{
    /**
     1的
     31343753536E37343563133F38313935F39064363C66537A613321D6362837372BD34312336123D6134666382DD3962433383766337E39343556337F2B77695623105F633C53765A6263313332D831623B2382D23465331342D662613D9322D439373713862E61643553433F3538
     
     11的
     
     31343753536E37333503035F35343975F32031303C03662A633221D6135865352BD34352626423D6136637302DD6335466393716130E61333583939F2B77695623105F306C16237A6564312632D865303B1382D23433631322D638306D4332D439373706234E62353546436F3837
     */
    _webSocket.delegate = nil;
    [_webSocket close];
//    ws://172.168.1.49:9006/ws/bind?sid=a&did=daifw
    //Facebook服务
//    ws://127.0.0.1:9000/chat
    _webSocket = [[SRWebSocket alloc]initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://172.16.101.39:9000/chat"]]];
    
     
     //                                                                                      self.textField.text]]];
     
     _webSocket.delegate =self;
     [_webSocket open];
    
//    MessageManager *messageManager = [MessageManager sharedInstance];
//    messageManager.socketHost = @"http://127.0.0.1:9000/";
//    //手动下线
//    //    messageManager.offlineStyle = SocketOfflineByUser;
//    //    [messageManager socketCutOff];
//    //
//    //    messageManager.offlineStyle = SocketOfflineByServer;
//    [messageManager socketConnect];
}
#pragma mark - webSocket delegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"已连接1111");
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"连接成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败111----%@",error.localizedDescription);
    [[[UIAlertView alloc]initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"接受消息:\n %@",message);
    
    _receiveMsgTextView.text = (NSString *)message;
}

#pragma mark - touch
- (IBAction)connectClick:(id)sender {
    [self connectSocket];
}
- (IBAction)sendClick:(id)sender {
    
    if (_webSocket == nil || _webSocket.readyState != SR_CONNECTING) {
//        UIAlertAction *alert = [UIAlertAction alloc]init;
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先连接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
    }
    
    NSString *sendString = @"来自我的iPhone";
    if(![_sendMsgTextField.text isEqualToString:@""]){
        sendString = _sendMsgTextField.text;
    }
    [_webSocket send:sendString];

    
    
//    AFHTTPRequestOperationManager * op = [AFHTTPRequestOperationManager manager];
//    
//    /**
//     *  发给1的
//     */
//    [op GET:@"http://192.168.1.91:9006/ws/pushmsg?uid=11&sid=31343753536E37343563133F38313935F39064363C66537A613321D6362837372BD34312336123D6134666382DD3962433383766337E39343556337F2B77695623105F633C53765A6263313332D831623B2382D23465331342D662613D9322D439373713862E61643553433F3538&content=message1" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSLog(@"sent");
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//    }];
    
    /*NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
     [dictionary setValue:@"15" forKey:@"uid"];
     [dictionary setValue:@"31343753536E37393573232F37383945F65031363C23664A376221D3062830332BD34372393923D6233635362DD3936463393773162E63646553134F2B77695623105F383C03130A3230615362D862373B7372D23463331312D661653D8662D437613723530E63616533363F3934" forKey:@"sid"];
     [dictionary setValue:@"message1" forKey:@"content"];
     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
     NSString *encodedData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     [_webSocket send:encodedData];*/
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
