//
//  ZHToolView.h
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/21.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义block类型把ToolView中TextView中的文字传入到Controller中
typedef void (^MyTextBlock) (NSString *myText);

//录音时的音量
typedef void (^AudioVolumeBlock) (CGFloat volume);

//录音存储地址
typedef void (^AudioURLBlock) (NSURL *audioURL);

//改变根据文字改变TextView的高度
typedef void (^ContentSizeBlock)(CGSize contentSize);

//录音取消的回调
typedef void (^CancelRecordBlock)(int flag);

@interface ZHToolView : UIView

//设置MyTextBlock
- (void) setMyTextBlock:(MyTextBlock)block;

//设置声音回调
- (void) setAudioVolumeBlock:(AudioVolumeBlock) block;

//设置录音地址回调
- (void) setAudioURLBlock:(AudioURLBlock) block;

- (void)setContentSizeBlock:(ContentSizeBlock) block;

- (void)setCancelRecordBlock:(CancelRecordBlock)block;

- (void) changeFunctionHeight: (float) height;

@end

