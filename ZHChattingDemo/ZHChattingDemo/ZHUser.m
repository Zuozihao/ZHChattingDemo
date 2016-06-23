//
//  ZHUser.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHUser.h"
#import "NSString+ZH.h"

@implementation ZHUser

- (void) setUsername:(NSString *)username
{
    _username = username;
    _pinyin = username.pinyin;
    _initial = username.pinyinInitial;
}


@end
