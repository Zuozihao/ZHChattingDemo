//
//  ZHChatMessageViewController.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHChatMessageViewController.h"

#import "ZHTextMessageCell.h"
#import "ZHImageMessageCell.h"

@interface ZHChatMessageViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGR;

@end

@implementation ZHChatMessageViewController

#pragma mark - LifeCycle
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addGestureRecognizer:self.tapGR];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerClass:[ZHTextMessageCell class] forCellReuseIdentifier:@"TextMessageCell"];
    [self.tableView registerClass:[ZHImageMessageCell class] forCellReuseIdentifier:@"ImageMessageCell"];
}

#pragma mark - Public Methods
- (void) addNewMessage:(ZHMessage *)message
{
    [self.data addObject:message];
    [self.tableView reloadData];
}

- (void) scrollToBottom
{
    if (_data.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_data.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHMessage *message = [_data objectAtIndex:indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:message.cellIndentify];
    [cell setMessage:message];
    return cell;
}

#pragma mark - UITableViewCellDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHMessage *message = [_data objectAtIndex:indexPath.row];
    return message.cellHeight;
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - Event Response
- (void) didTapView
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapChatMessageView:)]) {
        [_delegate didTapChatMessageView:self];
    }
}

#pragma mark - Getter
- (UITapGestureRecognizer *) tapGR
{
    if (_tapGR == nil) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    }
    return _tapGR;
}

- (NSMutableArray *) data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    
    return _data;
}

@end
