//
//  ZHChatMessageViewController.h
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHMessage.h"

@class ZHChatMessageViewController;

@protocol ZHChatMessageViewControllerDelegate <NSObject>

- (void) didTapChatMessageView:(ZHChatMessageViewController *)chatMessageViewController;

@end

@interface ZHChatMessageViewController : UITableViewController

@property (nonatomic, assign) id<ZHChatMessageViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *data;

- (void) addNewMessage:(ZHMessage*)message;
- (void) scrollToBottom;

@end
