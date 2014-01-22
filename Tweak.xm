#import <UIKit/UIKit.h>

@interface TPNumberPadButton

// their functions
+(id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2 whiteVersion:(BOOL)arg3;
+(id)imageForCharacter:(unsigned)arg1;
+(id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2;

// my functions
+ (UIImage *)clipImage:(UIImage *)img digit:(unsigned)digit;
+ (UIImage *)getCorrectImage:(UIImage *)originalImage digit:(unsigned)digit;

@end

//cache the current setting here
static int buttonStyle=0;

%hook TPNumberPadButton


// All these are supposed to return the image that goes inside of the circle buttons, which should
// be the number, and then a few letters underneath it. I hook in and make them return whatever
+(id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2 whiteVersion:(BOOL)arg3
{
    return [self getCorrectImage:%orig digit:arg1];
}
+(id)imageForCharacter:(unsigned)arg1
{
    return [self getCorrectImage:%orig digit:arg1];
}
+(id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2
{
    return [self getCorrectImage:%orig digit:arg1];
}

// i got this function from here:
// http://stackoverflow.com/questions/1487601/how-to-erase-some-portion-of-a-uiimageviews-image-on-ios
// all that it does is "erase" part of a UIImage. I use it to cut out the letters at the bottom of the image
%new
+ (UIImage *)clipImage:(UIImage *)img digit:(unsigned)digit
{
    CGSize s = img.size;
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0);
    
    CGContextRef g = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(g, kCGInterpolationHigh);
	CGMutablePathRef erasePath = CGPathCreateMutable();
    
    // the 0 is farther down than the other buttons, so we have to make an exception, and we actually don't have to cut anything
    // off since there aren't any letters underneath it
    if (digit != 10)
        CGPathAddRect(erasePath, NULL, CGRectMake(0, s.height * .78, s.width, s.height * .22));
    CGContextAddPath(g,erasePath);
    
    CGContextAddRect(g,CGRectMake(0,0,s.width,s.height));
    CGContextEOClip(g);
    
    [img drawAtPoint:CGPointZero];
    
    UIImage *toReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // zero is already centered, so we don't want to push that down farther
    if (digit == 10)
        return toReturn;
    
    // push the image down farther in the button, so that it's centered
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(s.width, s.height * 1.3), NO, 0.0f);
    [toReturn drawInRect:CGRectMake(0, s.height * .3, s.width, s.height)];
    toReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return toReturn;
}

%new
// this will return the type of image that the user has specified via the preferences
+ (UIImage *)getCorrectImage:(UIImage *)originalImage digit:(unsigned)digit
{
    if (buttonStyle == 0)
        return originalImage;
    else if (buttonStyle == 1)
        return [self clipImage:originalImage digit:digit];
    else /*if ([prefs[@"ButtonStyle"] integerValue] == 2)*/
        return nil;
}

%end

static void loadSettings(){
	NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.expetelek.simplepasscodebuttonspreferences.plist"];
    buttonStyle=[prefs[@"ButtonStyle"] integerValue];
    [prefs release];
}

static void settingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadSettings();
}

%ctor{
    //listen for changes in settings
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChanged, CFSTR("com.expetelek.simplepasscodebuttons.settingsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadSettings();
}