//
//  ListView.h
//  banking
//
//  Created by Guillermo Winkler on 2/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StandardTableView.h"
#import "TableCell.h"
#import "ViewDefinition.h"

@interface ListView : ViewDefinition {
    TableCell *_cell;
}

@property id dataSource;
@property NSString* groupBy;
@property NSString* sortBy;
@property StandardTableView *view;

-(NSString*) cellIdentifierForRow:(NSDictionary*)row;
-(UITableViewCell*) buildCell:(UIView*)screen forRow:(NSDictionary*)row ;
-(void)updateCell:(UITableViewCell*)cell withData:(NSDictionary*)row;
-(int)getCellHeight:(UIView*)screen forRow:(NSDictionary*)row;

- (ListView*) initWithDictionary:(NSDictionary*)d andApp:(Application*)app;

@end
