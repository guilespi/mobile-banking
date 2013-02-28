//
//  ParsingTests.m
//  banking
//
//  Created by Guillermo Winkler on 2/23/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "ParsingTests.h"
#import "AppParser.h"
#import "NavigationEntry.h"
#import "ListView.h"

//this is a class extension in order to access the private parsing methods
@interface AppParser()
    -(Application*)appFromDictionary:(NSDictionary*)appDictionary;
@end

@implementation ParsingTests


- (void)testParseApplication
{
    NSArray * entriesOrder = [[NSArray alloc] initWithObjects:@"login", @"posicion", nil];
    
    NSDictionary *loginDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"Login Text", @"text",
                                      @"Login Icon.png", @"icon",
                                      [NSNumber numberWithBool:true], @"authenticated",
                                      [NSNumber numberWithBool:true], @"enabled",
                                      @"Login Target", @"target", nil];
    
    NSDictionary *positionDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"Pos Text", @"text",
                                  @"Pos Icon.png", @"icon",
                                  [NSNumber numberWithBool:false], @"authenticated",
                                  [NSNumber numberWithBool:false], @"enabled",
                                  @"Pos Target", @"target", nil];
    
    NSDictionary * navigationEntries = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            loginDict, @"login",
                                            positionDict, @"posicion", nil];
    
    NSDictionary *navigationDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                       entriesOrder, @"order",
                       navigationEntries, @"entries", nil];
    
    NSDictionary *basicDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"english", @"default-language",
                                    @"test-back.png", @"background", nil];
    
    NSDictionary *movementListDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"day", @"group-by",
                                    @"timestamp", @"sort-by", nil];
    
    
    NSDictionary *appDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                       navigationDict, @"Navigation",
                       basicDict, @"App",
                       movementListDict, @"List:Movements", nil];
    
    AppParser *p = [[AppParser alloc] init];
    Application* app = [p appFromDictionary:appDict];
    STAssertNotNil(app, @"Application incorrectly parsed returning nil");
    //assert application properties
    STAssertEqualObjects(app.defaultLanguage, @"english", @"App default language is not english");
    STAssertEqualObjects(app.background, @"test-back.png", @"App background incorrectly parsed");
    
    //assert navigation entries respecting specified order and properties
    STAssertNotNil(app.navigation, @"Navigation entries not parsed");
    STAssertTrue([app.navigation count] == 2, @"Navigation entries count should be two");
    STAssertEqualObjects(((NavigationEntry*)app.navigation[0]).text, @"Login Text", @"Login is not on the first navigation position");
    STAssertEqualObjects(((NavigationEntry*)app.navigation[0]).icon, @"Login Icon.png", @"Login icon not properly parsed");
    STAssertTrue(((NavigationEntry*)app.navigation[0]).requiresAuth == true, @"Login authentication flag not properly parsed");
    STAssertTrue(((NavigationEntry*)app.navigation[0]).isEnabled == true, @"Login enabled flag not properly parsed");
    STAssertEqualObjects(((NavigationEntry*)app.navigation[0]).target, @"Login Target", @"Login target attribute not properly parsed");
    
    STAssertEqualObjects(((NavigationEntry*)app.navigation[1]).text, @"Pos Text", @"Position is not on the second navigation position");
    STAssertEqualObjects(((NavigationEntry*)app.navigation[1]).icon, @"Pos Icon.png", @"Position icon not properly parsed");
    STAssertTrue(((NavigationEntry*)app.navigation[1]).requiresAuth == false, @"Position authentication flag not properly parsed");
    STAssertTrue(((NavigationEntry*)app.navigation[1]).isEnabled == false, @"Position enabled flag not properly parsed");
    STAssertEqualObjects(((NavigationEntry*)app.navigation[1]).target, @"Pos Target", @"Login target attribute not properly parsed");
    
    //assert application views correctly parsed
    ListView *movementsView = [app.views objectForKey:@"list:movements"];
    STAssertNotNil(movementsView, @"Expected movements view not found in view dictionary");
    STAssertEqualObjects(movementsView.groupBy, @"day", @"Invalid group-by field %@ in parsed movements view", movementsView.groupBy);
    STAssertEqualObjects(movementsView.sortBy, @"timestamp", @"Invalid timestamp field %@ in parsed movements view", movementsView.sortBy);
    
}

@end
