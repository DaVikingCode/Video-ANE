//
//  VideoIosExtension.m
//  VideoIosExtension
//
//  Created by Aymeric Lamboley on 12/09/2014.
//  Copyright (c) 2014 DaVikingCode. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "NativeVideo.h"
#import "MultipleNativeVideo.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }


NSMutableArray *videos;

DEFINE_ANE_FUNCTION(addVideo) {
    
    if (videos == nil)
        videos = [NSMutableArray array];
    
    uint32_t string1Length;
    const uint8_t *url;
    
    uint32_t string2Length;
    const uint8_t *type;
    
    double posX;
    double posY;
    
    double width;
    double height;
    
    uint32_t string3Length;
    const uint8_t *orientation;
    
    FREGetObjectAsUTF8(argv[0], &string1Length, &url);
    FREGetObjectAsUTF8(argv[1], &string2Length, &type);
    FREGetObjectAsDouble(argv[2], &posX);
    FREGetObjectAsDouble(argv[3], &posY);
    FREGetObjectAsDouble(argv[4], &width);
    FREGetObjectAsDouble(argv[5], &height);
    FREGetObjectAsUTF8(argv[6], &string3Length, &orientation);
    
    UIWindow *rootView = [[[UIApplication sharedApplication] delegate] window];
    
    /*nativeVideo = [[NativeVideo alloc] initWithFrame:CGRectMake(posX, posY, width, height) andUrl:[NSString stringWithUTF8String:(char*) url] ofType:[NSString stringWithUTF8String:(char *) type]withOrientation:[NSString stringWithUTF8String:(char*) orientation]];
    [rootView addSubview:nativeVideo];*/
    
    MultipleNativeVideo *video = [[MultipleNativeVideo alloc] initWithFrame:CGRectMake(posX, posY, width, height) andUrl:[NSString stringWithUTF8String:(char*) url] ofType:[NSString stringWithUTF8String:(char *) type]withOrientation:[NSString stringWithUTF8String:(char*) orientation]];
    
    [rootView addSubview:video];
    
    [videos addObject:video];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(changePosition) {
    
    uint32_t videoIndex;
    FREGetObjectAsUint32(argv[0], &videoIndex);
    
    double posX;
    double posY;
    
    FREGetObjectAsDouble(argv[1], &posX);
    FREGetObjectAsDouble(argv[2], &posY);
    
    [[videos objectAtIndex:videoIndex] changePositionX:posX andY:posY];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(changeOrientation) {
    
    uint32_t stringLength;
    const uint8_t *orientation;
    
    FREGetObjectAsUTF8(argv[0], &stringLength, &orientation);
    
    for (id object in videos) {
        
        [object changeOrientation:[NSString stringWithUTF8String:(char*) orientation]];
    }
    
    return NULL;
}


void VideoContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(addVideo, NULL ),
        MAP_FUNCTION(changePosition, NULL ),
        MAP_FUNCTION(changeOrientation, NULL )
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