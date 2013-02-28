//
//  Application.m
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "Application.h"

@implementation Application

-(Application*)init {
    self = [super init];
    _navigation = [[NSMutableArray alloc] init];
    _views = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void) run{
    //navigate to default view
}

-(void)setProperties:(NSDictionary*)props {
    
}

@end
