//
//  MultipleNativeVideo.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "MultipleNativeVideo.h"

@implementation MultipleNativeVideo

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type withOrientation:(NSString *) orientation {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        NSString *videoUrl = [[NSBundle mainBundle] pathForResource:url ofType:type];
        
        _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoUrl]];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        _playerLayer.frame = frame;
        
        [self.layer addSublayer:_playerLayer];
        
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_player currentItem]];
        
        self.userInteractionEnabled = NO;
        
        [_player play];
        
        //_playerLayer.videoGravity = AVLayerVideoGravityResizeAspect; //defaul, preserve aspect ratio; fit within layer bounds.
        //_playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // Preserve aspect ratio; fill layer bounds
        _playerLayer.videoGravity = AVLayerVideoGravityResize; // Stretch to fill layer bounds
        
        [self changeOrientation:orientation];
        
    }
    return self;
}

- (void) playerItemDidReachEnd:(NSNotification *) notification {
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}



- (void) changePositionX:(double) posX andY:(double) posY {
    
    [self.layer setFrame:CGRectMake(posX, posY, self.frame.size.width, self.frame.size.height)];
}

- (void) changeOrientation:(NSString *) orientation {
    
    CGFloat degree = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.55];
    
    if ([orientation isEqualToString:@"default"])
        self.layer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    else if ([orientation isEqualToString:@"upsideDown"]) {
        degree = -180;
        self.layer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    } if ([orientation isEqualToString:@"rotatedLeft"]) {
        degree = -90;
        self.layer.bounds = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
        
    } else if ([orientation isEqualToString:@"rotatedRight"]) {
        degree = 90;
        self.layer.bounds = CGRectMake(0, 0, self.frame.size.height, self.frame.size.width);
        
    }
    
    self.layer.transform = CATransform3DMakeRotation(degree / 180 * M_PI, 0, 0, 1);
    
    [UIView commitAnimations];
}

@end
