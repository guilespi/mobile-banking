//
//  API.h
//  banking
//
//  Created by Guillermo Winkler on 2/24/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject
-(void)execute:(NSDictionary*)parameters onSuccess:(void (^)(NSArray*))success
                                         onError:(void (^)(NSError*, NSString*))failure;

+(API*) createAPI:(NSDictionary*)definition;

@end
