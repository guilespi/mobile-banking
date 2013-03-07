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
@property NSString *logo;
@property NSString *invertedLogo;
@property UIColor *backgroundColor;
@property NSMutableArray *navigation;
@property NSMutableDictionary *views;
@property SplashScreen *splashScreen;
@property Theme *theme;
@property float headerSeparatorPosition;

-(void)run;
-(void)setProperties:(NSDictionary*)props;
-(UIView *)createHeaderView:(UIView *)screen;
-(UIView *)createBackgroundView:(UIView*)parent;

@end
