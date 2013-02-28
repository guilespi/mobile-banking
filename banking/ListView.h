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

@interface ListView : NSObject

@property id dataSource;
@property NSString* groupBy;
@property NSString* sortBy;
@property StandardTableView *view;
@property TableCell *cell;

- (ListView*) initWithDictionary:(NSDictionary*) d;

@end
