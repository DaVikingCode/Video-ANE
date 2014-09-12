//
//  NativeVideo.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "NativeVideo.h"

@implementation NativeVideo

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _player = [[MPMoviePlayerController alloc] init];
        
        NSString *videoUrl = [[NSBundle mainBundle] pathForResource:url ofType:type];
        
        [_player setContentURL:[NSURL fileURLWithPath:videoUrl]];
        
        [_player.view setFrame:frame];
        
        _player.repeatMode = MPMovieRepeatModeOne;
        
        [_player setControlStyle:MPMovieControlStyleNone];
        
        [_player play];
        
        [self addSubview:[_player view]];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void) changePositionX:(double) posX andY:(double) posY {
    
    [_player.view setFrame:CGRectMake(posX, posY, self.frame.size.width, self.frame.size.height)];
}

@end
