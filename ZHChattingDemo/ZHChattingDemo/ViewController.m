//
//  ViewController.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/20.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong)UITextField *userNameField;
@property(nonatomic, strong)UITextField *passwordField;

@property(strong, nonatomic)XMPPStream * xmppStream;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.title = @"登    录";
    
    self.view.backgroundColor = RGB(235, 235, 235);
    
    [self initView];
    
    //配置接入xmpp服务器的基本设置
    [self setupStream];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initView {
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(kAppScreenWidth/2 - 30, 150, 60, 60)];
    header.layer.borderColor = [UIColor lightGrayColor].CGColor;
    header.layer.borderWidth = 0.5f;
    header.layer.cornerRadius = 5;
    header.image = [UIImage imageNamed:@"header.jpg"];
    header.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:header];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(header.frame) + 40, 70, 40)];
    userNameLabel.text = @"用户名";
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userNameLabel];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(userNameLabel.frame) + 30, 70, 40)];
    passwordLabel.text = @"密  码";
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:passwordLabel];
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLabel.frame) + 10, CGRectGetMinY(userNameLabel.frame), kAppScreenWidth - 20 - 10 - userNameLabel.frame.size.width - 20, userNameLabel.frame.size.height)];
    self.userNameField.layer.borderWidth = 0.5f;
    self.userNameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userNameField.backgroundColor = [UIColor whiteColor];
    self.userNameField.layer.cornerRadius = 5;
    [self.view addSubview:self.userNameField];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userNameLabel.frame) + 10, CGRectGetMinY(passwordLabel.frame), kAppScreenWidth - 20 - 10 - userNameLabel.frame.size.width - 20, userNameLabel.frame.size.height)];
    self.passwordField.layer.borderWidth = 0.5f;
    self.passwordField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.layer.cornerRadius = 5.0f;
    [self.passwordField setSecureTextEntry:YES];
    [self.view addSubview:self.passwordField];
    
    UIButton *logIn = [UIButton buttonWithType:UIButtonTypeCustom];
    logIn.frame = CGRectMake(30, CGRectGetMaxY(passwordLabel.frame) + 30, kAppScreenWidth - 60, 40);
    [logIn addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
    [logIn setTitle:@"登录" forState:UIControlStateNormal];
    
    UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"注 册" style:UIBarButtonItemStylePlain target:self action:@selector(goRegiste)];
    [registerButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = registerButton;
}

- (void)setupStream {
    //获取应用的xmppSteam(通过Application中的单例获取)
    UIApplication *application = [UIApplication sharedApplication];
    id delegate = [application delegate];
    self.xmppStream = [delegate xmppStream];
    
    //注册回调
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //2.创建
    XMPPReconnect *xmmppReconnect = [[XMPPReconnect alloc] init];
    [xmmppReconnect activate:_xmppStream];
    
    //3.创建花名册对象，用于维护好友关系的
    XMPPRosterCoreDataStorage *xmppRosterStoage = [[XMPPRosterCoreDataStorage alloc] init];
    XMPPRoster *xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStoage];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster activate:_xmppStream];
    
    //4.设置xmpp服务器信息： ip\端口
    [_xmppStream setHostName:kHostname];
    //服务器端口
    [_xmppStream setHostPort:5222];
}


- (void)logInAction {
    //1.发送连接请求
    NSString *user = self.userNameField.text;
    
    //2.创建用于登陆的JID
    NSString *jidstring = [NSString stringWithFormat:@"%@@%@",user,kHostname];
    XMPPJID *jid = [XMPPJID jidWithString:jidstring];
    
    [_xmppStream setMyJID:jid];
    
    //3.发送连接
    [_xmppStream connectWithTimeout:30 error:nil];
}

- (void)goOnline {
    
}

//1.连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSString *password = self.passwordField.text;
        
    //验证登陆密码
    BOOL isKeyRight = [_xmppStream authenticateWithPassword:password error:nil];
}

//2.登陆验证密码成功
//XMPP
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"登陆成功");
    //登录成功后上线
}

//3.登陆密码验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    
    NSLog(@"%@",error);
}

//4.注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"注册成功");
}

//5.注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    NSLog(@"注册失败：%@",error);
}


- (void)goRegiste {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
