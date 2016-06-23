//
//  ZHChattingViewController.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/21.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHChattingViewController.h"
#import "ChatKeyBoard.h"

#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSubjectModel.h"
#import "FaceSourceManager.h"

#import "ZHMessageCell.h"
#import "ZHTextMessageCell.h"
#import "ZHImageMessageCell.h"
#import "ZHChatMessageViewController.h"

#import "ZHUserHelper.h"
#import "XMPPManager.h"

@interface ZHChattingViewController ()<ChatKeyBoardDataSource, ChatKeyBoardDelegate,ZHChatMessageViewControllerDelegate>
{
    CGFloat viewHeight;
}


@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

@property (nonatomic, strong) ZHChatMessageViewController *chatMessageVC;

@end

@implementation ZHChattingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:RGB(235, 235, 235)];
    [self setHidesBottomBarWhenPushed:YES];
    
    viewHeight = kAppScreenHeight - 64;
    
    [self.view addSubview:self.chatMessageVC.view];
    [self addChildViewController:self.chatMessageVC];
    
    self.view.backgroundColor = [UIColor whiteColor];
    /**
     *  只需要调整子控制器的View， 确定好frame，传入控制器即可
     */
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithParentViewBounds:frame];
    
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    
    self.chatKeyBoard.placeHolder = @"请输入消息";
    [self.view addSubview:self.chatKeyBoard];
    
    //4.监听接受消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMsgNotification:)
                                                 name:kReceiveMessageNotification
                                               object:nil];

    

    // Do any additional setup after loading the view.
}

#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];

    return @[item1, item2, item3];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (void)chatKeyBoardSendText:(NSString *)text {
    
    ZHMessage *message = [[ZHMessage alloc] init];
    
    message.from = [ZHUserHelper sharedUserHelper].user;
    message.text = text;
    message.messageType = TLMessageTypeText;
    message.ownerTyper = TLMessageOwnerTypeSelf;
    message.date = [NSDate date];
    [self.chatMessageVC addNewMessage:message];
    
    [self.chatMessageVC scrollToBottom];
    
    //将消息发给服务器
    [[XMPPManager shareManager] sendMessage:text toUser:@"zuozihao@127.0.0.1"];
}

- (NSArray<FaceSubjectModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}

- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index {
    NSLog(@"选择了%ld个",index);
}

#pragma mark - TLChatMessageViewControllerDelegate
- (void) didTapChatMessageView:(ZHChatMessageViewController *)chatMessageViewController
{
    [self.chatKeyBoard resignFirstResponder];
}

#pragma mark - Getter and Setter
- (void) setUser:(ZHUser *)user
{
    _user = user;
    [self.navigationItem setTitle:user.username];
}

- (ZHChatMessageViewController *) chatMessageVC
{
    if (_chatMessageVC == nil) {
        _chatMessageVC = [[ZHChatMessageViewController alloc] init];
        [_chatMessageVC.view setFrame:CGRectMake(0, 64, kAppScreenWidth, viewHeight - 44)];
        [_chatMessageVC setDelegate:self];
    }
    return _chatMessageVC;
}


#pragma mark - NSNotification action 通知的事件方法

//收到消息的通知
- (void)receiveMsgNotification:(NSNotification *)notification {
    
    NSDictionary *msgDic = notification.object;
    NSString *text = [msgDic objectForKey:@"text"];
    
    
    //2.向data中添加一条数据
    ZHMessage *msg = [[ZHMessage alloc] init];
    msg.ownerTyper = TLMessageOwnerTypeOther;
    
    msg.text = text;
    msg.messageType = TLMessageTypeText;
    msg.from = [ZHUserHelper sharedUserHelper].user;
    [self.chatMessageVC addNewMessage:msg];
    
    [self.chatMessageVC scrollToBottom];
   
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
