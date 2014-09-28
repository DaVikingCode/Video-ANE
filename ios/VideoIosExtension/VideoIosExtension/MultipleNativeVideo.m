//
//  MultipleNativeVideo.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "MultipleNativeVideo.h"

@implementation MultipleNativeVideo

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type usingMode:(NSString *) mode withOrientation:(NSString *) orientation {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        NSString *videoUrl = [[NSBundle mainBundle] pathForResource:url ofType:type];
        
        _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoUrl]];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        _playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self.layer addSublayer:_playerLayer];
        
        iOSorientation = orientation;
        frameX = frame.origin.x;
        frameY = frame.origin.y;
        videoMode = mode;
        
        [self changePositionX:frame.origin.x andY:frame.origin.y];
        
        if ([videoMode isEqualToString:@"MODE_LOOP"]) {
        
            _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_player currentItem]];
        }
        
        self.userInteractionEnabled = NO;
        
        if (![videoMode isEqualToString:@"MODE_MANUAL_CONTROL"]) {
        
            [_player play];
        }
        
        //_playerLayer.videoGravity = AVLayerVideoGravityResizeAspect; //defaul, preserve aspect ratio; fit within layer bounds.
        //_playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // Preserve aspect ratio; fill layer bounds
        _playerLayer.videoGravity = AVLayerVideoGravityResize; // Stretch to fill layer bounds
        
        [self changeOrientation:iOSorientation];
        
    }
    return self;
}

- (void) destroy {
    
    if ([videoMode isEqualToString:@"MODE_LOOP"]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[_player currentItem]];
    }
    
    [_player pause];
    
    [self removeFromSuperview];
}

- (void) playerItemDidReachEnd:(NSNotification *) notification {
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void) gotoVideoTime:(double) time {
    
    [_player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
}

- (void) paused:(BOOL) pauseValue {
    
    if (pauseValue)
        [_player pause];
    else
        [_player play];
}

- (void) displayBitmapData:(UIImage *) img withPositionX:(double) posX andY:(double) posY withWidth:(double) width andHeight:(double) height {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    
    imageView.frame = CGRectMake(posX, posY, width, height);
    
    [self addSubview:imageView];
}

- (void) changePositionX:(double) posX andY:(double) posY {
    
    frameX = posX;
    frameY = posY;
    
    if ([iOSorientation isEqualToString:@"default"])
        [self.layer setFrame:CGRectMake(frameX, frameY, self.frame.size.width, self.frame.size.height)];
    
    else if ([iOSorientation isEqualToString:@"upsideDown"])
        [self.layer setFrame:CGRectMake(-frameX + [[UIScreen mainScreen] bounds].size.width - self.frame.size.width, -frameY + [[UIScreen mainScreen] bounds].size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    
    else if ([iOSorientation isEqualToString:@"rotatedLeft"])
        [self.layer setFrame:CGRectMake(frameY, -frameX + [[UIScreen mainScreen] bounds].size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    
    else if ([iOSorientation isEqualToString:@"rotatedRight"])
        [self.layer setFrame:CGRectMake(-frameY + [[UIScreen mainScreen] bounds].size.width - self.frame.size.width, frameX, self.frame.size.width, self.frame.size.height)];
}

- (void) changeOrientation:(NSString *) orientation {
    
    CGFloat degree = 0;
    
    iOSorientation = orientation;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.55];
    
    if ([iOSorientation isEqualToString:@"upsideDown"])
        degree = -180;
        
    else if ([iOSorientation isEqualToString:@"rotatedLeft"])
        degree = -90;
        
    else if ([iOSorientation isEqualToString:@"rotatedRight"])
        degree = 90;
    
    [self changePositionX:frameX andY:frameY];
    
    self.layer.transform = CATransform3DMakeRotation(degree / 180 * M_PI, 0, 0, 1);
    
    [UIView commitAnimations];
}

@end
