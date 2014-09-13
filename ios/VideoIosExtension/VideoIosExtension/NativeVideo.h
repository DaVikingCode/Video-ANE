//
//  NativeVideo.h
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 13/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NativeVideo : UIView

@property (strong, nonatomic) MPMoviePlayerController *player;

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *) url ofType:(NSString *) type withOrientation:(NSString *) orientation;

- (void) changePositionX:(double) posX andY:(double) posY;

- (void) changeOrientation:(NSString *) orientation;

@end
