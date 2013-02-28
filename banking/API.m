//
//  API.m
//  banking
//
//  Created by Guillermo Winkler on 2/24/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "API.h"
#import "RESTApi.h"

@implementation API

+(API*) createAPI:(NSDictionary*)definition {
    if (!definition) {
        [NSException raise:@"Invalid API" format:@"Received a nil api definition"];
    }
    //assume string apis are to be trated as REST urls
    if ([definition isKindOfClass:[NSString class]]) {
        definition = [[NSDictionary alloc] initWithObjectsAndKeys:definition, @"url", nil];
    }
    else if (![definition isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid API" format:@"Invalid type for API %@", definition];
    }
    return [[RESTApi alloc] initWithURL:[definition objectForKey:@"url"]];
}

@end
 