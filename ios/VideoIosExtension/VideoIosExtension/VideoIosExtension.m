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
    
    uint32_t string3Length;
    const uint8_t *mode;
    
    double posX;
    double posY;
    
    double width;
    double height;
    
    uint32_t string4Length;
    const uint8_t *orientation;
    
    FREGetObjectAsUTF8(argv[0], &string1Length, &url);
    FREGetObjectAsUTF8(argv[1], &string2Length, &type);
    FREGetObjectAsUTF8(argv[2], &string3Length, &mode);
    FREGetObjectAsDouble(argv[3], &posX);
    FREGetObjectAsDouble(argv[4], &posY);
    FREGetObjectAsDouble(argv[5], &width);
    FREGetObjectAsDouble(argv[6], &height);
    FREGetObjectAsUTF8(argv[7], &string4Length, &orientation);
    
    UIWindow *rootView = [[[UIApplication sharedApplication] delegate] window];
    
    /*nativeVideo = [[NativeVideo alloc] initWithFrame:CGRectMake(posX, posY, width, height) andUrl:[NSString stringWithUTF8String:(char*) url] ofType:[NSString stringWithUTF8String:(char *) type]withOrientation:[NSString stringWithUTF8String:(char*) orientation]];
    [rootView addSubview:nativeVideo];*/
    
    MultipleNativeVideo *video = [[MultipleNativeVideo alloc] initWithFrame:CGRectMake(posX, posY, width, height) andUrl:[NSString stringWithUTF8String:(char*) url] ofType:[NSString stringWithUTF8String:(char *) type] usingMode:[NSString stringWithUTF8String:(char *) mode] withOrientation:[NSString stringWithUTF8String:(char*) orientation]];
    
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

DEFINE_ANE_FUNCTION(gotoVideoTime) {
    
    uint32_t videoIndex;
    FREGetObjectAsUint32(argv[0], &videoIndex);
    
    double time;
    
    FREGetObjectAsDouble(argv[1], &time);
        
    [[videos objectAtIndex:videoIndex] gotoVideoTime:time];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(displayBitmapData) {
    
    uint32_t videoIndex;
    FREGetObjectAsUint32(argv[0], &videoIndex);
    
    FREBitmapData bitmapData;
    FREAcquireBitmapData(argv[1], &bitmapData);
    
    int width = bitmapData.width;
    int height = bitmapData.height;
    int stride = bitmapData.lineStride32 * 4;
    uint32_t* input = bitmapData.bits32;
    
    // make data provider from buffer
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
    // set up for CGImage creation
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo;
    if( bitmapData.hasAlpha )
    {
        if( bitmapData.isPremultiplied )
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
        else
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;
    } else {
        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    }
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef image = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    double posX;
    double posY;
    double imgWidth;
    double imgHeight;
    
    FREGetObjectAsDouble(argv[2], &posX);
    FREGetObjectAsDouble(argv[3], &posY);
    FREGetObjectAsDouble(argv[4], &imgWidth);
    FREGetObjectAsDouble(argv[5], &imgHeight);
    
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    
    [[videos objectAtIndex:videoIndex] displayBitmapData:img withPositionX:posX andY:posY withWidth:imgWidth andHeight:imgHeight];
    
    FREReleaseBitmapData(argv[1]);
    
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

DEFINE_ANE_FUNCTION(killAllVideos) {
    
    for (id object in videos) {
        
        [object destroy];
    }
    
    [videos removeAllObjects];
    
    return NULL;
}


void VideoContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(addVideo, NULL ),
        MAP_FUNCTION(changePosition, NULL ),
        MAP_FUNCTION(changeOrientation, NULL ),
        MAP_FUNCTION(killAllVideos, NULL ),
        MAP_FUNCTION(gotoVideoTime, NULL ),
        MAP_FUNCTION(displayBitmapData, NULL )
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