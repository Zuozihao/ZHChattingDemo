//
//  ZHMessageCell.h
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHMessage.h"

@interface ZHMessageCell : UITableViewCell

@property (nonatomic, strong) ZHMessage *message;

@property (nonatomic, strong) UIImageView *avatarImageView;                 // 头像
@property (nonatomic, strong) UIImageView *messageBackgroundImageView;      // 消息背景
@property (nonatomic, strong) UIImageView *messageSendStatusImageView;      // 消息发送状态


@end
