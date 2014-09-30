//
//  MultipleNativeVideo.h
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MultipleNativeVideo : UIView {
    
    NSString *iOSorientation;
    double frameX;
    double frameY;
    NSString *videoMode;
    UIImageView *imageOverlay;
    double imageOverlayframeX;
    double imageOverlayframeY;
    double imageOverlayWidth;
    double imageOverlayHeight;
}

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type usingMode:(NSString *) mode withOrientation:(NSString *) orientation;

- (void) changePositionX:(double) posX andY:(double) posY;
- (void) gotoVideoTime:(double) time;
- (void) paused:(BOOL) pauseValue;
- (void) displayBitmapData:(UIImage *) img withPositionX:(double) posX andY:(double) posY withWidth:(double) width andHeight:(double) height;
- (void) displayBitmapDataOverlay:(UIImage *) img withPositionX:(double) posX andY:(double) posY withWidth:(double) width andHeight:(double) height;

- (void) changeOrientation:(NSString *) orientation;

- (void) destroy;

@end
