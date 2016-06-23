//
//  ZHUserHelper.h
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHUser.h"

@interface ZHUserHelper : NSObject

@property (nonatomic, strong) ZHUser *user;

+ (ZHUserHelper *)sharedUserHelper;


@end
