//
//  LoginView.m
//  banking
//
//  Created by Guillermo Winkler on 3/6/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "LoginView.h"
#import "LoginBasic.h"

@implementation LoginView


-(LoginView*)initWithDictionary:(NSDictionary*)definition {
    self = [super init];
    LoginBasic* basic = [[LoginBasic alloc] init];
    self.view = [[UINavigationController alloc] initWithRootViewController:basic];
    
    return self;
}


@end
