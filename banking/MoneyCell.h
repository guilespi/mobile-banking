//
//  MoneyCell.h
//  banking
//
//  Created by Guillermo Winkler on 2/28/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "TableCell.h"

static const int TITLE_TAG = 1;
static const int DESC_TAG = 2;
static const int TOTAL_MONEY_TAG = 3;
static const int PARTIAL_MONEY_TAG = 4;
static const int PRODUCT_NUMBER_TAG = 5;
static const int RIGHT_HEADER_TAG = 6;

@interface MoneyCell : TableCell

@property NSString *titleField;
@property NSString *descriptionField;
@property NSString *productNumberField;
@property NSString *totalMoneyField;
@property NSString *partialMoneyField;
@property NSString *rightHeaderField;

- (TableCell*) initWithDictionary:(NSDictionary*)definition;
@end
