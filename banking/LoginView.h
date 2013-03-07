//
//  LoginView.h
//  banking
//
//  Created by Guillermo Winkler on 3/6/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewDefinition.h"
#import "Application.h"

@interface LoginView : ViewDefinition {
    NSArray *alternates;
}

@property NSString *disclaimer;
@property bool useDocumentType;

-(LoginView*)initWithDictionary:(NSDictionary*)definition andApp:(Application*)app;

@end
