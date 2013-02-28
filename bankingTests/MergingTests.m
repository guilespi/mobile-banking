//
//  MergingTests.m
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "MergingTests.h"
#import "AppParser.h"


//this is a class extension in order to access the private method mergeDictionary from the tests
@interface AppParser()
    -(NSDictionary*) mergeDictionary:(NSDictionary *)a with:(NSDictionary*) b;
@end

@implementation MergingTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testMergeBasic
{
    NSDictionary *a = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"value1", @"key1",
                          @"value2", @"key2", nil];
    
    NSDictionary *b = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"value3", @"key3",
                       @"value4", @"key4", nil];
    
    AppParser *p = [[AppParser alloc] init];
    NSDictionary* result = [p mergeDictionary:a with:b];
    
    STAssertNotNil(result, @"Dictionary merge returned nil");
    for (NSString* key in b) {
        STAssertEquals([b objectForKey:key], [result objectForKey:key], [NSString stringWithFormat:@"Element with key %@ from b not present", key]);
    }
    for (NSString* key in a) {
        STAssertEquals([a objectForKey:key], [result objectForKey:key], [NSString stringWithFormat:@"Element with key %@ from a not present", key]);
    }
    
}


- (void)testMergeOverlap
{
    NSDictionary *a = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"value1", @"key1",
                       @"value2", @"key2", nil];
    
    NSDictionary *b = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"value3", @"key1",
                       @"value4", @"key2", nil];
    
    AppParser *p = [[AppParser alloc] init];
    NSDictionary* result = [p mergeDictionary:a with:b];
    
    STAssertNotNil(result, @"Dictionary merge returned nil");
    for (NSString* key in b) {
        STAssertEquals([b objectForKey:key], [result objectForKey:key], [NSString stringWithFormat:@"Element with key %@ from b not present", key]);
    }
    
}


- (void)testMergePartialOverlap
{
    NSDictionary *a = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"value1", @"key1",
                       @"value2", @"key2", nil];
    
    NSDictionary *b = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"value3", @"key2",
                       @"value4", @"key3", nil];
    
    AppParser *p = [[AppParser alloc] init];
    NSDictionary* result = [p mergeDictionary:a with:b];
    
    STAssertNotNil(result, @"Dictionary merge returned nil");
    for (NSString* key in b) {
        STAssertEquals([b objectForKey:key], [result objectForKey:key], [NSString stringWithFormat:@"Element with key %@ from b not present", key]);
    }
    for (NSString* key in a) {
        if (![b objectForKey:key]) {
            STAssertEquals([a objectForKey:key], [result objectForKey:key], [NSString stringWithFormat:@"Element with key %@ from a not present", key]);
        }
    }
    
}


- (void)testMergeNestedMerge
{
    NSDictionary *nested_a = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"vnested1", @"knested1",
                              @"vnested2", @"knested2", nil];
    
    NSDictionary *a = [[NSDictionary alloc] initWithObjectsAndKeys:
                       @"value1", @"key1",
                       nested_a, @"key2", nil];
    
    NSDictionary *nested_b = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"changed", @"knested1",
                              @"vnested3", @"knested3", nil];
    
    NSDictionary *b = [[NSDictionary alloc] initWithObjectsAndKeys:
                       nested_b, @"key2",
                       @"value4", @"key3", nil];
    
    AppParser *p = [[AppParser alloc] init];
    NSDictionary* result = [p mergeDictionary:a with:b];
    
    STAssertNotNil(result, @"Dictionary merge returned nil");
    
    //validate only the three members of the nested dictionary
    STAssertEquals(@"changed", [[result objectForKey:@"key2"] objectForKey:@"knested1"], @"Nested dictionary was not correctly changed");
    STAssertEquals(@"vnested2", [[result objectForKey:@"key2"] objectForKey:@"knested2"], @"Nested dictionary mutated an invalid value");
    STAssertEquals(@"vnested3", [[result objectForKey:@"key2"] objectForKey:@"knested3"], @"Nested dictionary mutated an invalid value");
    
    
}



@end
