//
//  MoneyCell.h
//  banking
//
//  Created by Guillermo Winkler on 2/28/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "TableCell.h"

@interface MoneyCell : TableCell

@property NSString *titleField;
@property NSString *descriptionField;
@property NSString *totalMoneyField;
@property NSString *partialMoneyField;

- (MoneyCell*) initWithDictionary:(NSDictionary*)definition;
@end
