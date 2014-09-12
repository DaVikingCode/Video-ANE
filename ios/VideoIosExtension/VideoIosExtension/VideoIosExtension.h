//
//  VideoIosExtension.h
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 12/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoIosExtension : NSObject

@property (strong, nonatomic) MPMoviePlayerController *player;

+ (VideoIosExtension *) sharedInstance;

@end