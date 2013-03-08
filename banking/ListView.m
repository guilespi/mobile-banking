//
//  ListView.m
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "ListView.h"
#import "API.h"
#import "Application.h"

@implementation ListView

- (ListView*) initWithDictionary:(NSDictionary*)d andApp:(Application *)app{
    self = [super init];
    self.app = app;
    _groupBy = [d objectForKey:@"group-by"] ? : @"";
    _sortBy = [d objectForKey:@"sort-by"] ? : @"";
    _dataSource = [API createAPI:[d objectForKey:@"api"]];
    self.view = [[StandardTableView alloc] initWithDefinition:self];
    
    NSDictionary * cellType = [d objectForKey:@"cell"];
    if (cellType) {
        if (![cellType isKindOfClass:[NSDictionary class]]) {
            [NSException raise:@"Invalid ListView definition"
                        format:@"Invalid cell definition for datasource %@", _dataSource];
        }
        _cell = [TableCell createCell:cellType];
    }
    return self;
}

/*
    For standard listviews all cells use the same identifier
 */
-(NSString*) cellIdentifierForRow:(NSDictionary*)row {
    if (!_cell) {
        [NSException raise:@"Unable to retrieve standard view cell identifier without default cell" format:@"Cell is nil"];
    }
    return _cell.identifier;
}
/*
    For standard listviews all cells are built the same no matter the data
 */
-(UITableViewCell*) buildCell:(UIView*)screen forRow:(NSDictionary*)row {
    if (!_cell) {
        [NSException raise:@"Unable to build standard view cell without default cell" format:@"Cell is nil"];
    }
    return [_cell buildCell:screen withTheme:self.app.theme forRow:row];
}

/*
    For a given constructed cell update the inner data
 */
-(void)updateCell:(UITableViewCell*)cell withData:(NSDictionary*)row {
    if (!_cell) {
        [NSException raise:@"Unable to update standard view cell without default cell" format:@"Cell is nil"];
    }
    return [_cell updateCell:cell withData:row];
}

/*
    In the standard listview all cells are the same height
 */
-(int)getCellHeight:(UIView*)screen forRow:(NSDictionary*)row {
    if (!_cell) {
        [NSException raise:@"Unable to get standard view cell height without default cell" format:@"Cell is nil"];
    }
    return [_cell getCellHeight:screen forRow:row];
}

@end
