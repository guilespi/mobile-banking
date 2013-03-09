//
//  AppParser.m
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "AppParser.h"
#import "NavigationEntry.h"
#import "ListView.h"
#import "LoginView.h"
#import "ConsolidatedPosition.h"
#import "UIColor+colorFromHexString.h"

@implementation AppParser

/*  Deep recursive merge of dictionary b into dictionary a.
 
    A:             B:
    {a:1             {c:2
     b:{c:3  }        b:{c:1, d:4}
    }                 }
 
   Merges into
    {a:1
     b:{c:1, d:4}
     c:2}
 
 */
- mergeDictionary:(NSDictionary *)a with:(NSDictionary*) b {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:a];
 
    [b enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        id aobj = [a objectForKey:key];
        //if both values are dictionaries do a deep merge
        if (aobj && [aobj isKindOfClass:[NSDictionary class]]
            && [obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary* newVal = [self mergeDictionary:(NSDictionary*) aobj with:(NSDictionary *) obj];
            [result setObject: newVal forKey: key];
        } else {
            [result setObject: obj forKey: key];
        }
    }];
    
    return (NSDictionary *) [result mutableCopy];
}

/*  Parse app attributes
 */
- (void)parseApp:(Application*)app withProperties:(NSDictionary*)d {
    [app initFromDictionary:d];
}

/*  Parse login attributes
 */
- (void)parseLogin:(Application*)app withProperties:(NSDictionary*)d {
    LoginView *login = [[LoginView alloc] initWithDictionary:d andApp:app];
    [app.views setObject:login forKey: @"login"];
}

/*  Parse consolidated position
 */
- (void)parsePosition:(Application*)app withProperties:(NSDictionary*)d {
    ConsolidatedPosition *position = [[ConsolidatedPosition alloc] initWithDictionary:d andApp:app];
    [app.views setObject:position forKey: @"position"];
}


/*  Parse the navigation dictionary and creates the corresponding array of
    NavigationEntry objects.
    If no order is specified the final order will be undetermined.
 */
- (void)parseNavigation:(Application*)app withNavigation:(NSDictionary*)d {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSDictionary *entries = [d objectForKey:@"entries"];
    if (!entries) {
        [NSException raise:@"Invalid definition" format:@"No entries defined for navigation option"];
    }
    NSArray *order = [d objectForKey:@"order"];
    if (order) {
        for (id entryKey in order) {
            NSDictionary * entryData = [entries objectForKey:entryKey];
            if (!entryData) {
                [NSException raise:@"Invalid definition" format:@"Navigation ordered entry %@ does not exist", entryKey];
            }
            NavigationEntry *entry = [[NavigationEntry alloc] initWithDictionary:entryData];
            [result addObject:entry];
        }
    }
    else {
        //entries are initialized in no specific order
        [d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NavigationEntry *entry = [[NavigationEntry alloc] initWithDictionary:obj];
            [result addObject:entry];
        }];
    }
    app.navigation = result;
}

/* Creates a new ListView for the application with name `listName`, if listName already exists as a view throws an exception
 */
- (void)parseListView:(Application*)app name:(NSString*)listName withList:(NSDictionary*)d {
    if ([app.views objectForKey:listName]) {
        [NSException raise:@"Invalid definition" format:@"Object with key %@ already exists when creating ListView", listName];
    }
    ListView *list = [[ListView alloc] initWithDictionary:d andApp:app];
    [app.views setObject:list forKey: [listName lowercaseString]];
}


/* Creates an Application given a nested
   dictionary of objects
 */
-(Application*)appFromDictionary:(NSDictionary*)appDictionary {
    NSError *error;
    NSRegularExpression* typeRegex = [NSRegularExpression regularExpressionWithPattern:@"([^:]+):(.+)$"
                                                                               options:NSRegularExpressionCaseInsensitive error:&error];
    
    Application *app = [[Application alloc] init];
    
    
    //Dictionary lambda blocks used to replace the non-existent switch statement
    //for NSString in obj-c
    typedef void (^CaseBlock)(NSString*, NSDictionary*);
    
    NSDictionary *appFabric = [NSDictionary dictionaryWithObjectsAndKeys:
                               [^(NSString * name, NSDictionary *d) { [self parseApp:app withProperties:d]; } copy], @"app",
                               [^(NSString * name, NSDictionary *d) { [self parseLogin:app withProperties:d]; } copy], @"login",
                               [^(NSString * name, NSDictionary *d) { [self parseNavigation:app withNavigation:d]; } copy], @"navigation",
                               [^(NSString * name, NSDictionary *d) { [self parsePosition:app withProperties:d]; } copy], @"position",
                               [^(NSString * name, NSDictionary *d) { [self parseListView:app name:name withList:d]; } copy], @"list",
                               nil];
    
    //force app parsing first since all views needed it as dependency
    CaseBlock c = [appFabric objectForKey:@"app"];
    c(@"app",[appDictionary objectForKey:@"App"]);
    
    //Each dictionary key can by a single name like "App" or a composed
    //name type:name like List:Movements, iteration matches to decide which builtin object to build
    [appDictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        NSArray *matches = [typeRegex matchesInString:key
                                              options:0
                                                range:NSMakeRange(0, [key length])];
        NSString *type, *name;
        name = type = [key lowercaseString];
        if (matches && [matches count] > 0) {
            NSTextCheckingResult * typeResult = matches[0];
            type = [[key substringWithRange:[typeResult rangeAtIndex:1]] lowercaseString];
        }
        CaseBlock c = [appFabric objectForKey:[type lowercaseString]];
        if (c) {
            c(name, obj);
        }
        else {
            [NSException raise:@"Invalid definition" format:@"%@ is of an unknown type", key];
        }
    }];
    return app;
}

/* Parses the appication using the built-in application/json files
   TODO: retrieve the local custom definitions from somewhere and extend
 */
- (Application*)parseApplication {
    //This should be ordered if some definition overrides previous ones
    NSArray *const builtinDefinitions = [[NSArray alloc] initWithObjects:
                                         @"app", @"navigation", @"login", @"position", nil];
    
    NSDictionary * appDictionary = [[NSDictionary alloc] init];
    for (id fileName in builtinDefinitions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"bank"];
        NSData *rawData = [NSData dataWithContentsOfFile:path];
        //Assume data is not encapsulated between brackets and add them
        NSString *rawString = [[NSString alloc] initWithData:rawData encoding:NSUTF8StringEncoding];
        NSString *jsonDefinition = [NSString stringWithFormat:@"{%@}", rawString];
        NSError *jsonParsingError = nil;
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[jsonDefinition dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:kNilOptions
                                                                      error:&jsonParsingError];
        if (json && !jsonParsingError) {
            appDictionary = [self mergeDictionary:appDictionary with:json];
        }
    }
    appDictionary = [self mergeDictionary:appDictionary with:[self retrieveCustomizedApp]];
    return [self appFromDictionary:appDictionary];
}

/*
    Sync execute HTTP GET request
 */
- (NSString *) syncHTTPRequest:(NSString*)url {
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (error != 0 || [httpResponse statusCode] >= 400) {
        // do error handling here
        NSLog(@"remote url returned error %d %@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
        return NULL;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/*
    All definition retrieval is synchronous since definitions are needed even for the
    splash screen, cannot move forward without this information
 */
- (NSDictionary*)retrieveCustomizedApp {
    NSDictionary * remoteDefinitions = [[NSDictionary alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL remoteLoad = [userDefaults boolForKey:@"remoteDefinitions"];
    if (remoteLoad) {
        NSString *host = [userDefaults stringForKey:@"apiHost"];
        NSString *response = [self syncHTTPRequest:[NSString stringWithFormat:@"http://%@/definitions", host]];
        if (response) {
            NSError *jsonParsingError = nil;
            NSArray * fileList = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:kNilOptions
                                                                    error:&jsonParsingError];
            if (!jsonParsingError) {
                for (id file in fileList) {
                    NSString *rawContent = [self syncHTTPRequest:[NSString stringWithFormat:@"http://%@/%@", host, file]];
                    NSString *content = [NSString stringWithFormat:@"{%@}", rawContent];
                    if (content) {
                        NSDictionary * fileDefinition = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options:kNilOptions
                                                                                          error:&jsonParsingError];
                        if (!jsonParsingError) {
                            remoteDefinitions = [self mergeDictionary:remoteDefinitions with: fileDefinition];
                        }
                    }
                }
            }
        }
    }
    return remoteDefinitions;
}
@end
