//
//  RESTApi.h
//  banking
//
//  Created by Guillermo Winkler on 2/24/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"

@interface RESTApi : API

-(RESTApi*)initWithURL:(NSString*)url;

@property (readonly) NSURL *url;

@end
