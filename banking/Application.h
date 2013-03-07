//
//  Application.h
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SplashScreen.h"
#import "Theme.h"

@interface Application : NSObject

@property NSString *defaultLanguage;
@property NSString *background;
@property UIColor *backgroundColor;
@property NSMutableArray *navigation;
@property NSMutableDictionary *views;
@property SplashScreen *splashScreen;
@property Theme *theme;

-(void)run;
-(void)setProperties:(NSDictionary*)props;

@end
