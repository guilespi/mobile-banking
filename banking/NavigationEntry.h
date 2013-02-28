//
//  NavigationEntry.h
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationEntry : NSObject

@property NSString* text;
@property NSString* icon;
@property bool requiresAuth;
@property bool isEnabled;
@property NSString* target;

- (NavigationEntry*) initWithDictionary:(NSDictionary*) d;

@end
