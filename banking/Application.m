//
//  Application.m
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "Application.h"
#import "UIColor+colorFromHexString.h"

@implementation Application

-(Application*)init {
    self = [super init];
    _navigation = [[NSMutableArray alloc] init];
    _views = [[NSMutableDictionary alloc] init];
    _headerSeparatorPosition = 0.68;
    return self;
}

-(void)initFromDictionary:(NSDictionary *)d {
    _defaultLanguage = [d objectForKey:@"default-language"] ? : @"spanish";
    _background = [d objectForKey:@"background"] ? : @"backgroundBrillo";
    _backgroundColor = [UIColor colorFromHexString:[d objectForKey:@"background-color"] ?: @"#02253e"];
    _logo = [d objectForKey:@"logo"] ? : @"backgroundBrillo";
    _invertedLogo = [d objectForKey:@"inverted-logo"] ? : @"logoHeaderAzul";
    //splash screen parsing
    NSDictionary *splashDefinition = [d objectForKey:@"splash-screen"];
    if (splashDefinition) {
        _splashScreen = [[SplashScreen alloc] initWithDictionary:splashDefinition];
        _splashScreen.app = self;
    }
    //color theme parsing
    NSDictionary *themeDefinition = [d objectForKey:@"theme"];
    if (!themeDefinition || ![themeDefinition isKindOfClass:[NSDictionary class]]) {
        themeDefinition = [[NSDictionary alloc] init];
    }
    _theme = [[Theme alloc] initFromDictionary:themeDefinition];
}

-(void) run{
    //navigate to default view
}

-(void)setProperties:(NSDictionary*)props {
    
}

-(UIView *)createHeaderView:(UIView *)screen {
    //height in original design was 88px in a 960px screen (868 usable)
    long headerHeight = screen.frame.size.height * 0.1013825;
    long headerWidth = screen.frame.size.width;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0,
                                                              headerWidth,
                                                              headerHeight)];
    [header setBackgroundColor:_theme.color2];
    //add inverted logo to header
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_invertedLogo]];
    CGRect frame = logoView.frame;
    frame.origin.x = headerWidth * 0.03125;
    frame.origin.y = (headerHeight - logoView.frame.size.height) / 2;
    logoView.frame = frame;
    [header addSubview:logoView];
    //create separator line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(headerWidth * _headerSeparatorPosition, 0, 1, headerHeight)];
    lineView.backgroundColor = _theme.dottedLineColor;
    [header addSubview:lineView];
    return header;
}

-(UIView *)createBackgroundView:(UIView *)parent {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [imageView setImage:[UIImage imageNamed:_background]];
    return imageView;
}
@end
