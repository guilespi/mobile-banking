//
//  ListView.m
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "ListView.h"
#import "API.h"

@implementation ListView

- (ListView*) initWithDictionary:(NSDictionary*) d {
    self = [super init];
    _groupBy = [d objectForKey:@"group-by"] ? : @"";
    _sortBy = [d objectForKey:@"sort-by"] ? : @"";
    _dataSource = [API createAPI:[d objectForKey:@"api"]];
    self.view = [[StandardTableView alloc] initWithDefinition:self];
    
    NSDictionary * cellType = [d objectForKey:@"cell"];
    if (!cellType || ![cellType isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid ListView definition"
                    format:@"Missing or invalid cell definition for datasource %@", _dataSource];
    }
    _cell = [TableCell createCell:cellType];
    return self;
}

@end
