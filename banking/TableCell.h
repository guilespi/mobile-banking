//
//  TableCell.h
//  banking
//
//  Created by Guillermo Winkler on 2/28/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface TableCell : NSObject 

//unique reusability identifier, provided by
//the derived class
@property NSString *identifier;

//to be implemented by child classes
-(UITableViewCell*) buildCell:(UIView*)screen withTheme:(Theme*)theme forRow:(NSDictionary*)row;
-(void)updateCell:(UITableViewCell*)cell withData:(NSDictionary*)row;
-(int)getCellHeight:(UIView*)screen forRow:(NSDictionary*)row;

+(TableCell*) createCell:(NSDictionary*)definition;

@end
