//
//  ZHTextMessageCell.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHTextMessageCell.h"
#import "UIView+ZH.h"

@implementation ZHTextMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.messageTextLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    float y = self.avatarImageView.originY + 11;
    float x = self.avatarImageView.originX + (self.message.ownerTyper == TLMessageOwnerTypeSelf ? - self.messageTextLabel.frameWidth - 27 : self.avatarImageView.frameWidth + 23);
    [self.messageTextLabel setOrigin:CGPointMake(x, y)];
    
    x -= 18;                                    // 左边距离头像 5
    y = self.avatarImageView.originY - 5;       // 上边与头像对齐 (北京图像有5个像素偏差)
    float h = MAX(self.messageTextLabel.frameHeight + 30, self.avatarImageView.frameHeight + 10);
    [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.messageTextLabel.frameWidth + 40, h)];
}

#pragma mark - Getter and Setter
- (void) setMessage:(ZHMessage *)message
{
    [super setMessage:message];
    [_messageTextLabel setAttributedText:message.attrText];
    _messageTextLabel.size = message.messageSize;
}

- (UILabel *) messageTextLabel
{
    if (_messageTextLabel == nil) {
        _messageTextLabel = [[UILabel alloc] init];
        [_messageTextLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_messageTextLabel setNumberOfLines:0];
    }
    return _messageTextLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
