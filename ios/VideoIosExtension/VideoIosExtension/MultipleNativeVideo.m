//
//  MultipleNativeVideo.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "MultipleNativeVideo.h"

@implementation MultipleNativeVideo

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type usingMode:(NSString *) mode withOrientation:(NSString *) orientation andOrientationSpeed:(double) speed {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        NSString *videoUrl = [[NSBundle mainBundle] pathForResource:url ofType:type];
        
        _player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoUrl]];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        
        _playerLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self.layer addSublayer:_playerLayer];
        
        iOSorientation = orientation;
        speedRotation = speed;
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
        
        imageAnimationsIsOverlay = NO;
        
    }
    return self;
}

- (void) destroy {
    
    if ([videoMode isEqualToString:@"MODE_LOOP"]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:[_player currentItem]];
    }
    
    if (imageAnimations != nil) {
        [imageAnimations stopAnimating];
    }
    
    [_player pause];
    
    [self removeFromSuperview];
}

- (void) playerItemDidReachEnd:(NSNotification *) notification {
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void) gotoVideoTime:(double) time {
    
    [_player seekToTime:(CMTimeMake(time * 100, 100)) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void) paused:(BOOL) pauseValue {
    
    if (pauseValue)
        [_player pause];
    else
        [_player play];
}

- (void) changeSoundVolume:(double) volume {
    
    if ([_player respondsToSelector:@selector(setVolume:)]) {
        
        _player.volume = volume;
        
    } else {
    
        AVPlayerItem *myAVPlayerItem = _player.currentItem;
        AVAsset *myAVAsset = myAVPlayerItem.asset;
        NSArray *audioTracks = [myAVAsset tracksWithMediaType:AVMediaTypeAudio];
    
        NSMutableArray *allAudioParams = [NSMutableArray array];
        for (AVAssetTrack *track in audioTracks) {
        
            AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        
        
            [audioInputParams setVolume:volume atTime:kCMTimeZero];
        
            [allAudioParams addObject:audioInputParams];
        }
    
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        [audioMix setInputParameters:allAudioParams];
    
        [myAVPlayerItem setAudioMix:audioMix];
    }
}

- (void) displayBitmapData:(UIImage *) img withPositionX:(double) posX andY:(double) posY withWidth:(double) width andHeight:(double) height {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    
    imageView.frame = CGRectMake(posX, posY, width, height);
    
    [self addSubview:imageView];
}

- (void) displayBitmapDataOverlay:(UIImage *) img withPositionX:(double) posX andY:(double) posY withWidth:(double) width andHeight:(double) height {

    imageOverlay = [[UIImageView alloc] initWithImage:img];
    
    imageOverlay.frame = CGRectMake(posX, posY, width, height);
    
    imageOverlayframeX = posX;
    imageOverlayframeY = posY;
    imageOverlayWidth = width;
    imageOverlayHeight = height;
    
    [self addSubview:imageOverlay];
}

- (void) removeFirstBitmapData {
    
    [[[self subviews] objectAtIndex:0] removeFromSuperview];
}

- (void) removeLatestBitmapData {
    
    [[[self subviews] objectAtIndex:[self subviews].count - 1] removeFromSuperview];
}

- (void) playAnimation:(NSString *) name from:(uint32_t) startFrame to:(uint32_t) endFrame inDirectory:(NSString *) directory withSpeed:(double) speed andRepeatCount:(uint32_t) repeatCount autoStart:(BOOL) autoStart isOverlay:(BOOL) overlay withPositionX:(double) posX andY:(double) posY withWidth:(double) width andHeight:(double) height {
    
    imageAnimations = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, width, height)];
    
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    for (int i = startFrame; i < endFrame; ++i) {
        
        [frames addObject:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:name, i] ofType:@"png" inDirectory:directory]]];
    }
    
    imageAnimations.animationImages = frames;
    
    imageAnimations.animationDuration = speed;
    
    imageAnimations.animationRepeatCount = repeatCount;
    
    imageAnimations.image = [imageAnimations.animationImages lastObject];
    
    if (autoStart)
        [imageAnimations startAnimating];
    
    [self addSubview:imageAnimations];
    
    imageAnimationsframeX = posX;
    imageAnimationsframeY = posY;
    imageAnimationsWidth = width;
    imageAnimationsHeight = height;
    imageAnimationsIsOverlay = overlay;
}

- (void) pausedAnimation:(BOOL) pauseValue {
    
    if (imageAnimations == nil)
        return;
    
    if (pauseValue)
        [imageAnimations stopAnimating];
    else
        [imageAnimations startAnimating];
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
    
    if (imageOverlay != nil) {
        
        imageOverlay.frame = CGRectMake(imageOverlayframeX - posX, imageOverlayframeY - posY, imageOverlayWidth, imageOverlayHeight);
    
        imageOverlay.alpha = CGRectIntersectsRect(imageOverlay.frame, _playerLayer.frame);
    }
    
    if (imageAnimations != nil && imageAnimationsIsOverlay) {
        
        imageAnimations.frame = CGRectMake(imageAnimationsframeX - posX, imageAnimationsframeY - posY, imageAnimationsWidth, imageAnimationsHeight);
    
        imageAnimations.alpha = CGRectIntersectsRect(imageAnimations.frame, _playerLayer.frame);
    }
}

- (void) changeOrientation:(NSString *) orientation {
    
    CGFloat degree = 0;
    
    iOSorientation = orientation;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:speedRotation];
    
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
