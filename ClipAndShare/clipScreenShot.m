//
//  clipScreenShot.m
//  ClipAndShare
//
//  Created by Scott Twichel on 7/22/14.
//  Copyright (c) 2014 Pepper Gum Games. All rights reserved.
//

#import "clipScreenShot.h"

@implementation clipScreenShot
+(UIImage *)clipResultsImageFrom:(UIView *)main{
    
    /* Obtains Screen Dimensions*/
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    screenBounds.size = screenSize;
    screenBounds.origin = CGPointZero;
    
    /* Capture the screenshot of entire view */
    UIGraphicsBeginImageContextWithOptions(screenSize, YES, 0.0);
    if ([main drawViewHierarchyInRect:main.frame afterScreenUpdates:YES]){
        NSLog(@"Successfully draw the screenshot.");
    } else {
        NSLog(@"Failed to draw the screenshot.");
    }
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /* Clip the image to the selected rectangle */
        // The x, y, width, and height values should be based on a non retina view and the
        // screenScale multiplier will adjust the clipRegion's size according to the resolution
    
    CGRect clipRegion;
    
        // TODO: add in clipRegion details for the various devices
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        // clipRegion for ipad devices
        clipRegion = CGRectMake(137*screenScale, 158*screenScale, 532*screenScale, 473*screenScale);
    } else {
        // Check the height to width ratio to determine screen size
        if (screenBounds.size.height/screenBounds.size.width > 1.5f) {
            // clipRegion for 4 inch devices
            clipRegion = CGRectMake(137*screenScale, 158*screenScale, 532*screenScale, 473*screenScale);
        } else {
            // clipRegion for 3.5 inch devices
            clipRegion = CGRectMake(137*screenScale, 158*screenScale, 532*screenScale, 473*screenScale);
        }
    }
    
    CGImageRef ref = screenshot.CGImage;
    CGImageRef mySubimage = CGImageCreateWithImageInRect (ref, clipRegion);
    UIImage *clippedScreenshot = [UIImage imageWithCGImage:mySubimage];
    
    /* --OPTIONAL--
     Give the clipped image rounded corners*/
        // Requires improting the roundUIImageCorners class
    clippedScreenshot = [roundUIImageCorners roundCornersOf:clippedScreenshot toHaveRadiusOf:20];

    /* --OPTIONAL--
     Save Image to disk*/
        // Requires importing the saveImageToFile class
    [saveImageToFile saveImage:clippedScreenshot];
    
    /* Return the clipped image */
    return clippedScreenshot;

}
@end