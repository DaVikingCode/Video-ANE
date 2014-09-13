//
//  NativeVideo.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "NativeVideo.h"

@implementation NativeVideo

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type withOrientation:(NSString *) orientation {
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
        
        [self changeOrientation:orientation];
    }
    return self;
}

- (void) changePositionX:(double) posX andY:(double) posY {
    
    [_player.view setFrame:CGRectMake(posX, posY, self.frame.size.width, self.frame.size.height)];
}

- (void) changeOrientation:(NSString *) orientation {
    
    CGFloat degree = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.55];
    
    if ([orientation isEqualToString:@"default"])
        _player.view.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    else if ([orientation isEqualToString:@"upsideDown"]) {
        degree = -180;
        _player.view.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    } if ([orientation isEqualToString:@"rotatedLeft"]) {
        degree = -90;
        _player.view.bounds = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
        
    } else if ([orientation isEqualToString:@"rotatedRight"]) {
        degree = 90;
        _player.view.bounds = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
        
    }
    
    CGAffineTransform cgCTM = CGAffineTransformMakeRotation((degree) * M_PI / 180);
    _player.view.transform = cgCTM;
    
    [UIView commitAnimations];
}

@end
