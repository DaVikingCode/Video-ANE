//
//  VideoIosExtension.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 12/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "NativeVideo.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

NativeVideo *nativeVideo;

DEFINE_ANE_FUNCTION(init) {
    
    uint32_t string1Length;
    const uint8_t *url;
    
    uint32_t string2Length;
    const uint8_t *type;
    
    double posX;
    double posY;
    
    double width;
    double height;
    
    FREGetObjectAsUTF8(argv[0], &string1Length, &url);
    FREGetObjectAsUTF8(argv[1], &string2Length, &type);
    FREGetObjectAsDouble(argv[2], &posX);
    FREGetObjectAsDouble(argv[3], &posY);
    FREGetObjectAsDouble(argv[4], &width);
    FREGetObjectAsDouble(argv[5], &height);
    
    UIWindow *rootView = [[[UIApplication sharedApplication] delegate] window];
    
    nativeVideo = [[NativeVideo alloc] initWithFrame:CGRectMake(posX, posY, width, height) andUrl:[NSString stringWithUTF8String:(char*) url] ofType:[NSString stringWithUTF8String:(char *) type]];
    [rootView addSubview:nativeVideo];
    
    NSLog(@"%@", NSStringFromCGRect(rootView.frame));
    NSLog(@"%@", NSStringFromCGRect(rootView.bounds));
    
    return NULL;
}

DEFINE_ANE_FUNCTION(changePosition) {
    
    double posX;
    double posY;
    
    FREGetObjectAsDouble(argv[0], &posX);
    FREGetObjectAsDouble(argv[1], &posY);
    
    [nativeVideo changePositionX:posX andY:posY];
    
    return NULL;
}


void VideoContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(init, NULL ),
        MAP_FUNCTION(changePosition, NULL )
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