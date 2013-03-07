//
//  LoginView.h
//  banking
//
//  Created by Guillermo Winkler on 3/6/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewDefinition.h"

@interface LoginView : ViewDefinition {
    NSArray *alternates;
}

//@property UINavigationController *view;

-(LoginView*)initWithDictionary:(NSDictionary*)definition;

@end
