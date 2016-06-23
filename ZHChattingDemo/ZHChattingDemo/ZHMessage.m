//
//  ZHMessage.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHMessage.h"
#import "ZHChatHelper.h"

static UILabel *label = nil;

@implementation ZHMessage

- (id) init
{
    if (self = [super init]) {
        if (label == nil) {
            label = [[UILabel alloc] init];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:16.0f]];
        }
    }
    return self;
}

#pragma mark - Setter
- (void) setText:(NSString *)text
{
    _text = text;
    if (text.length > 0) {
        _attrText = [ZHChatHelper formatMessageString:text];
    }
}

#pragma mark - Getter
- (void) setMessageType:(TLMessageType)messageType
{
    _messageType = messageType;
    switch (messageType) {
        case TLMessageTypeText:
            self.cellIndentify = @"TextMessageCell";
            break;
        case TLMessageTypeImage:
            self.cellIndentify = @"ImageMessageCell";
            break;
        case TLMessageTypeVoice:
            self.cellIndentify = @"VoiceMessageCell";
            break;
        case TLMessageTypeSystem:
            self.cellIndentify = @"SystemMessageCell";
            break;
        default:
            break;
    }
}

- (CGSize) messageSize
{
    switch (self.messageType) {
        case TLMessageTypeText:
            [label setAttributedText:self.attrText];
            _messageSize = [label sizeThatFits:CGSizeMake(kAppScreenWidth * 0.58, MAXFLOAT)];
            break;
        case TLMessageTypeImage:
        {
            NSString *path = [NSString stringWithFormat:@"%@/%@", PATH_CHATREC_IMAGE, self.imagePath];
            _image = [UIImage imageNamed:path];
            if (_image != nil) {
                _messageSize = (_image.size.width > kAppScreenWidth * 0.5 ? CGSizeMake(kAppScreenWidth * 0.5, kAppScreenWidth * 0.5 / _image.size.width * _image.size.height) : _image.size);
                _messageSize = (_messageSize.height > 60 ? (_messageSize.height < 200 ? _messageSize : CGSizeMake(_messageSize.width, 200)) : CGSizeMake(60.0 / _messageSize.height * _messageSize.width, 60));
            }
            else {
                _messageSize = CGSizeMake(0, 0);
            }
            break;
        }
        case TLMessageTypeVoice:
            
            break;
        case TLMessageTypeSystem:
            
            break;
        default:
            break;
    }
    return _messageSize;
}

- (CGFloat) cellHeight
{
    switch (self.messageType) {     // cell 上下间隔为10
        case TLMessageTypeText:
            return self.messageSize.height + 40 > 60 ? self.messageSize.height + 40 : 60;
            break;
        case TLMessageTypeImage:
            return self.messageSize.height + 20;
            break;
        default:
            break;
    }
    return 0;
}


@end
