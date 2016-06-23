//
//  ZHFriendViewController.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/21.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHFriendViewController.h"
#import "XMPPManager.h"

@interface ZHFriendViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger count;
}

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *data;

@end

@implementation ZHFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [[XMPPManager shareManager] getFreind:^(NSArray *freinds) {
        [self.tableView reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveMsgNotification:)
                                                 name:kReceiveMessageNotification
                                               object:nil];

    
    // Do any additional setup after loading the view.
}

- (void)receiveMsgNotification:(NSNotification *)notification {
    
    NSDictionary *msgDic = notification.object;
    
    NSString *text = msgDic[@"text"];
    NSString *fromJid = msgDic[@"jid"];
    
    
    //通过fromJid 到self.data中查找出对应的好友item
    /*
     self.data :
     [
     {name:...,jid:...},
     {name:...,jid:...},
     {name:...,jid:...},
     ]
     */
    [self.data enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        
        NSString *jid = item[@"jid"];
        if ([jid isEqualToString:fromJid]) {
            
            count++;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UILabel *label = (UILabel *)[cell viewWithTag:100];
            UILabel *textLabel = (UILabel *)[cell viewWithTag:200];
            
            label.hidden = NO;
            textLabel.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%ld条未读消息",count];
            
            textLabel.text = text;
            
            [cell setNeedsDisplay];
            
            return;
        }
        
    }];
    
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"freindCell" forIndexPath:indexPath];
    
    NSDictionary *item = self.data[indexPath.item];
    
    UILabel *label = (UILabel *)[cell viewWithTag:300];
    label.text = item[@"name"];;
    
    return cell;
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
