//
//  MultipleNativeVideo.h
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MultipleNativeVideo : UIView

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type withOrientation:(NSString *) orientation;

- (void) changePositionX:(double) posX andY:(double) posY;

- (void) changeOrientation:(NSString *) orientation;

@end
