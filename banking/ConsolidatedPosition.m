//
//  ConsolidatedPosition.m
//  banking
//
//  Created by Guillermo Winkler on 3/8/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "ConsolidatedPosition.h"
#import "TableCell.h"
#import "Application.h"

@implementation ConsolidatedPosition

- (ListView*) initWithDictionary:(NSDictionary*)d andApp:(Application*)app {
    self = [super initWithDictionary:d andApp:app];
    _typeField = [d objectForKey:@"type-field"];
    NSDictionary * cells = [d objectForKey:@"cells"];
    if (!cells || ![cells isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"Invalid Position definition"
                    format:@"Missing or invalid cells definition for consolidated position %@", d];
    }
    NSMutableDictionary *cellsByProduct = [[NSMutableDictionary alloc] init];
    [cells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        TableCell *cell = [TableCell createCell:obj];
        [cellsByProduct setObject:cell forKey:key];
    }];
    _cellsByProduct = [cellsByProduct mutableCopy];
    return self;
}

/*
    Retrieves cell definition for a specific product type (determined by a row)
 */
-(TableCell*)getCellForRow:(NSDictionary *)row {
    NSString *productType = [row objectForKey:_typeField];
    if (!productType) {
        [NSException raise:@"Invalid product entry"
                    format:@"Product %@ has no %@ type field", row, productType];
    }
    TableCell *cellDefinition = [_cellsByProduct objectForKey:productType];
    if (!cellDefinition) {
        [NSException raise:@"Invalid product entry"
                    format:@"Product %@ has no predefined cell configuration", productType];
    }
    return cellDefinition;
}
/*
 Dispatch cell height according to product type
 */
-(int)getCellHeight:(UIView*)screen forRow:(NSDictionary*)row {
    TableCell *cellDefinition = [self getCellForRow:row];
    return [cellDefinition getCellHeight:screen forRow:row];
}

/*
 For standard listviews all cells use the same identifier
 */
-(NSString*) cellIdentifierForRow:(NSDictionary*)row {
    TableCell *cellDefinition = [self getCellForRow:row];
    return cellDefinition.identifier;
}
/*
 For standard listviews all cells are built the same no matter the data
 */
-(UITableViewCell*) buildCell:(UIView*)screen forRow:(NSDictionary*)row {
    TableCell *cellDefinition = [self getCellForRow:row];
    return [cellDefinition buildCell:screen withTheme:self.app.theme forRow:row];
}

/*
 For a given constructed cell update the inner data
 */
-(void)updateCell:(UITableViewCell*)cell withData:(NSDictionary*)row {
    TableCell *cellDefinition = [self getCellForRow:row];
    return [cellDefinition updateCell:cell withData:row];
}


@end
