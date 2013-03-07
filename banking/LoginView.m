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


-(LoginView*)initWithDictionary:(NSDictionary*)definition andApp:(Application *)app{
    self = [super init];
    self.app = app;
    _disclaimer = [definition objectForKey:@"disclaimer"] ?: @"Copyright 2013 - Infocorp Todos los derechos reservados -";
    NSDictionary *loginEntries = [definition objectForKey:@"entries"];
    if (!loginEntries || ![loginEntries isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid definition" format:@"Login must have entries configuration"];
    }
    NSDictionary *basicDefinition = [loginEntries objectForKey:@"basic"];
    if (!basicDefinition || ![basicDefinition isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid definition" format:@"Login must have basic type configuration"];
    }
    _useDocumentType = [basicDefinition objectForKey:@"use-document"] ? [[basicDefinition objectForKey:@"use-document"] boolValue] : false;
    if (_useDocumentType) {
        _documentAPI = [API createAPI:[basicDefinition objectForKey:@"documents-api"]];
    }
    LoginBasic* basic = [[LoginBasic alloc] initWithDef:self];
    self.view = [[UINavigationController alloc] initWithRootViewController:basic];
    return self;
}


@end
