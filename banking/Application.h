//
//  Application.h
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Application : NSObject

@property NSString *defaultLanguage;
@property NSString *background;
@property NSMutableArray *navigation;
@property NSMutableDictionary *views;

-(void)run;
-(void)setProperties:(NSDictionary*)props;

@end
