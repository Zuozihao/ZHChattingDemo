//
//  ZHMessageCell.m
//  ZHChattingDemo
//
//  Created by 左梓豪 on 16/6/22.
//  Copyright © 2016年 左梓豪. All rights reserved.
//

#import "ZHMessageCell.h"
#import "UIView+ZH.h"

@implementation ZHMessageCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.messageBackgroundImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (_message.ownerTyper == TLMessageOwnerTypeSelf) {
        [self.avatarImageView setOrigin:CGPointMake(self.frameWidth - 10 - self.avatarImageView.frameWidth, 10)];
    }
    else if (_message.ownerTyper == TLMessageOwnerTypeOther) {
        [self.avatarImageView setOrigin:CGPointMake(10, 10)];
    }
}

#pragma mark - Getter and Stter
- (void) setMessage:(ZHMessage *)message
{
    _message = message;
    
    switch (message.ownerTyper) {
        case TLMessageOwnerTypeSelf:
            [self.avatarImageView setHidden:NO];
            [self.avatarImageView setImage:[UIImage imageNamed:message.from.avatarURL]];
            [self.messageBackgroundImageView setHidden:NO];
            self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_sender_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
        case TLMessageOwnerTypeOther:
            [self.avatarImageView setHidden:NO];
            [self.avatarImageView setImage:[UIImage imageNamed:message.from.avatarURL]];
            [self.messageBackgroundImageView setHidden:NO];
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_receiver_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
        case TLMessageOwnerTypeSystem:
            [self.avatarImageView setHidden:YES];
            [self.messageBackgroundImageView setHidden:YES];
            break;
        default:
            break;
    }
}

- (UIImageView *)avatarImageView
{
    if (_avatarImageView == nil) {
        float imageWidth = 40;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [_avatarImageView setHidden:YES];
    }
    return _avatarImageView;
}

- (UIImageView *) messageBackgroundImageView
{
    if (_messageBackgroundImageView == nil) {
        _messageBackgroundImageView = [[UIImageView alloc] init];
        [_messageBackgroundImageView setHidden:YES];
    }
    return _messageBackgroundImageView;
}


@end
