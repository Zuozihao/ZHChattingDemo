//
//  ZHUserHelper.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHUserHelper.h"

static ZHUserHelper *userHelper = nil;

@implementation ZHUserHelper

+ (ZHUserHelper *)sharedUserHelper
{
    if (userHelper == nil) {
        userHelper = [[ZHUserHelper alloc] init];
    }
    return userHelper;
}

- (ZHUser *) user
{
    if (_user == nil) {
        _user = [[ZHUser alloc] init];
        _user.username = @"Bay、栢";
        _user.userID = @"fox@127.0.0.1";
        _user.avatarURL = @"0.jpg";
    }
    return _user;
}


@end
