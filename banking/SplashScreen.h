//
//  SplashScreen.h
//  banking
//
//  Created by Guillermo Winkler on 2/26/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SplashViewController.h"
#import "ViewDefinition.h"

@interface SplashScreen : ViewDefinition

@property NSString *logo;
@property NSString *upperText;
@property NSString *lowerText;
@property NSString *textColor;
@property NSString *fontName;

-(SplashScreen*)initWithDictionary:(NSDictionary*)definition;

@end
