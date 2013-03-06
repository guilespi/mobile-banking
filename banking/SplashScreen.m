//
//  SplashScreen.m
//  banking
//
//  Created by Guillermo Winkler on 2/26/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "SplashScreen.h"

@implementation SplashScreen

-(SplashScreen*)initWithDictionary:(NSDictionary*)definition {
    self = [super init];
    
    _background = [definition objectForKey:@"background"];
    _logo = [definition objectForKey:@"logo"];
    _upperText = [definition objectForKey:@"upper-text"] ?: @"By";
    _lowerText = [definition objectForKey:@"lower-text"] ?: @"Infocorp";
    _textColor = [definition objectForKey:@"text-color"] ?: @"#ffffff";
    _fontName = [definition objectForKey:@"font-name"] ?: @"Verdana";
    
    /* According to apple you should never use Default.png as SplashScreen, so a layered view is used
     http://developer.apple.com/library/ios/#documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/App-RelatedResources/App-RelatedResources.html#//apple_ref/doc/uid/TP40007072-CH6-SW12
     */
    _view = [[SplashViewController alloc] initWithNibName:nil bundle:nil];
    _view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _view.definition = self;
    return self;
}

@end
