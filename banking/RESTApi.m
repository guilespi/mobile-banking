//
//  RESTApi.m
//  banking
//
//  Created by Guillermo Winkler on 2/24/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "RESTApi.h"
#import <AFJSONRequestOperation.h>

@implementation RESTApi

-(RESTApi*)initWithURL:(NSString*)url {
    self = [super init];
    _url = [NSURL URLWithString:url];
    return self;
}

-(void)execute:(NSDictionary*)parameters onSuccess:(void (^)(NSArray*))success
                                         onError:(void (^)(NSError*, NSString*))failure {
    
    if (!_url) {
        [NSException raise:@"Invalid URL for REST API" format:@"Url %@ is invalid", _url];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    
    void (^onSuccess)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
    onSuccess = ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] >= 400) {
            NSString *message = [NSString stringWithFormat:@"Invalid REST request for url %@ code %ld", _url, (long)[response statusCode]];
            NSLog(@"%@", message);
            NSError *err = [[NSError alloc] initWithDomain:message code:[response statusCode] userInfo:nil];
            failure(err, message);
            return;
        }
        success(JSON);
    };
    void (^onFailure)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);
    onFailure = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failure(error, @"");
    };
    
    //TODO: api format should be specified in the definition
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:onSuccess
                                         failure:onFailure];
    
    [operation start];
    
}

@end
