//
//  ZHChattingViewController.h
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/21.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHBaseViewController.h"
#import "ZHUser.h"

@interface ZHChattingViewController : ZHBaseViewController

@property (nonatomic, strong) ZHUser *user;

@property (nonatomic, strong) NSMutableArray *data;

@end
