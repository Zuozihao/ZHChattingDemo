//
//  ZHToolView.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/21.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHToolView.h"
#import <AVFoundation/AVFoundation.h>

@interface ZHToolView()

//最左边发送语音的按钮
@property (nonatomic, strong) UIButton *voiceChangeButton;
//发送语音的按钮
@property (nonatomic, strong) UIButton *sendVoiceButton;
//文本视图
@property (nonatomic, strong) UITextView *sendTextView;
//切换键盘
@property (nonatomic, strong) UIButton *changeKeyBoardButton;
//More
@property (nonatomic, strong) UIButton *moreButton;
//键盘坐标系的转换
@property (nonatomic, assign) CGRect endKeyBoardFrame;
//表情键盘
@property (nonatomic, strong) FunctionView *functionView;
//more
@property (nonatomic, strong) MoreView *moreView;
//数据model
@property (strong, nonatomic) ImageModelClass  *imageMode;

@property (strong, nonatomic) HistoryImage *tempImage;

//传输文字的block回调
@property (strong, nonatomic) MyTextBlock textBlock;

//contentsinz
@property (strong, nonatomic) ContentSizeBlock sizeBlock;

//传输volome的block回调
@property (strong, nonatomic) AudioVolumeBlock volumeBlock;

//传输录音地址
@property (strong, nonatomic) AudioURLBlock urlBlock;

//录音取消
@property (strong, nonatomic) CancelRecordBlock cancelBlock;

//添加录音功能的属性
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSURL *audioPlayURL;

@end

@implementation ZHToolView

//控件的初始化
-(void) addSubview
{
    self.voiceChangeButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.voiceChangeButton setImage:[UIImage imageNamed:@"chat_bottom_voice_press.png"] forState:UIControlStateNormal];
    [self.voiceChangeButton addTarget:self action:@selector(tapVoiceChangeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.voiceChangeButton];
    
    self.sendVoiceButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.sendVoiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_textfield.png"] forState:UIControlStateNormal];
    [self.sendVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.sendVoiceButton setTitle:@"按住说话" forState:UIControlStateNormal];
    
    
    [self.sendVoiceButton addTarget:self action:@selector(tapSendVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    self.sendVoiceButton.hidden = YES;
    [self addSubview:self.sendVoiceButton];
    
    self.sendTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.sendTextView.delegate = self;
    [self addSubview:self.sendTextView];
    
    self.changeKeyBoardButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.changeKeyBoardButton setImage:[UIImage imageNamed:@"chat_bottom_smile_nor.png"] forState:UIControlStateNormal];
    [self.changeKeyBoardButton addTarget:self action:@selector(tapChangeKeyBoardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.changeKeyBoardButton];
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.moreButton setImage:[UIImage imageNamed:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(tapMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
    
    [self addDone];
    
    
    
    //实例化FunctionView
    self.functionView = [[FunctionView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.functionView.backgroundColor = [UIColor blackColor];
    
    //设置资源加载的文件名
    self.functionView.plistFileName = @"emoticons";
    
    __weak __block ToolView *copy_self = self;
    //获取图片并显示
    [self.functionView setFunctionBlock:^(UIImage *image, NSString *imageText)
     {
         NSString *str = [NSString stringWithFormat:@"%@%@",copy_self.sendTextView.text, imageText];
         
         copy_self.sendTextView.text = str;
         
         //把使用过的图片存入sqlite
         NSData *imageData = UIImagePNGRepresentation(image);
         [copy_self.imageMode save:imageData ImageText:imageText];
     }];
    
    
    //给sendTextView添加轻击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.sendTextView addGestureRecognizer:tapGesture];
    
    
    //给sendVoiceButton添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sendVoiceButtonLongPress:)];
    //设置长按时间
    longPress.minimumPressDuration = 0.2;
    [self.sendVoiceButton addGestureRecognizer:longPress];
    
    //实例化MoreView
    self.moreView = [[MoreView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.moreView.backgroundColor = [UIColor blackColor];
    [self.moreView setMoreBlock:^(NSInteger index) {
        NSLog(@"MoreIndex = %d",(int)index);
    }];
    
    
}


-(void)setMyTextBlock:(MyTextBlock)block
{
    self.textBlock = block;
}

-(void)setAudioVolumeBlock:(AudioVolumeBlock)block
{
    self.volumeBlock = block;
}

-(void)setAudioURLBlock:(AudioURLBlock)block
{
    self.urlBlock = block;
}

-(void)setContentSizeBlock:(ContentSizeBlock)block
{
    self.sizeBlock = block;
}

-(void)setCancelRecordBlock:(CancelRecordBlock)block
{
    self.cancelBlock = block;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
