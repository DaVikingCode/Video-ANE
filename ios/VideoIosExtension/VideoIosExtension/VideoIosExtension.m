//
//  VideoIosExtension.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 12/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "VideoIosExtension.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

@implementation VideoIosExtension

static VideoIosExtension *sharedInstance = nil;

+ (VideoIosExtension *) sharedInstance {
    
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        
        sharedInstance.player = [[MPMoviePlayerController alloc] init];
    }
    
    return sharedInstance;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [VideoIosExtension sharedInstance];
}

- (id) copy {
    return self;
}

@end

DEFINE_ANE_FUNCTION(init) {
    
    UIWindow *rootView = [[[UIApplication sharedApplication] delegate] window];
    
    NSString *url = [[NSBundle mainBundle] pathForResource:@"trailer" ofType:@"mov"];
    
    [[[VideoIosExtension sharedInstance] player] setContentURL:[NSURL fileURLWithPath:url]];
    
    [[[VideoIosExtension sharedInstance] player].view setFrame:CGRectMake(0, 0, 320, 320)];
    
    [[VideoIosExtension sharedInstance] player].repeatMode = MPMovieRepeatModeOne;
    
    [[[VideoIosExtension sharedInstance] player] setControlStyle:MPMovieControlStyleNone];
    
    [[[VideoIosExtension sharedInstance] player] play];
    
    [rootView addSubview:[[[VideoIosExtension sharedInstance] player] view]];
    
    [[[VideoIosExtension sharedInstance] player] view].userInteractionEnabled = NO;
    
    /*[player.view setFrame: rootView.bounds];
    [rootView addSubview:[player view]];
    player.view.frame = rootView.frame;*/
    
    NSLog(@"%@", NSStringFromCGRect(rootView.frame));
    NSLog(@"%@", NSStringFromCGRect(rootView.bounds));
    
    /*player.initialPlaybackTime = -1.0;
    [player prepareToPlay];
    [player play];*/
    
    return NULL;
}


void VideoContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(init, NULL )
    };
    
    *numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = functionMap;
    
}

void VideoContextFinalizer(FREContext ctx) {
    return;
}

void VideoExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    
    extDataToSet = NULL; // This example does not use any extension data.
    *ctxInitializerToSet = &VideoContextInitializer;
    *ctxFinalizerToSet = &VideoContextFinalizer;
}

void VideoExtensionFinalizer() {
    return;
}