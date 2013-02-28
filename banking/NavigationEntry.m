//
//  NavigationEntry.m
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "NavigationEntry.h"

@implementation NavigationEntry

- (NavigationEntry*) initWithDictionary:(NSDictionary*) d{
    self = [super init];
    
    _text = [d objectForKey:@"text"] ? : @"";
    _icon = [d objectForKey:@"icon"] ? : @"default-nav-icon.png";
    _requiresAuth = [d objectForKey:@"authenticated"] ? [[d objectForKey:@"authenticated"] boolValue]: false;
    _isEnabled = [d objectForKey:@"enabled"] ? [[d objectForKey:@"enabled"] boolValue]: false;
    _target = [d objectForKey:@"target"] ? : @"";
    
    return self;
}


@end
