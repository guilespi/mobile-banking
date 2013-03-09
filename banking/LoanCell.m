//
//  LoanCell.m
//  banking
//
//  Created by Guillermo Winkler on 3/8/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "LoanCell.h"

static const int INSTALLMENT_TAG = 7;
static const int INSTALLMENT_MONTH_TAG = 8;


@implementation LoanCell


- (TableCell*) initWithDictionary:(NSDictionary*)definition {
    self = [super initWithDictionary:definition];
    self.identifier = @"loan-cell";
    NSDictionary *fields = [definition objectForKey:@"fields"];
    if (!fields) {
        [NSException raise:@"Invalid cell definition" format:@"Cell has missing field list %@", definition];
    }
    _installmentField = [fields objectForKey:@"installment"];
    _installmentMonthField = [fields objectForKey:@"installment-month"];
    
    return self;
}

/*
 Builds a standard money cell
 */
-(UITableViewCell*) buildCell:(UIView*)screen withTheme:(Theme *)theme forRow:(NSDictionary*)row{
    UITableViewCell *cell = [super buildCell:screen withTheme:theme forRow:row];
  
    long cellWidth = screen.frame.size.width * 0.96875;
    long cellHeight = [self getCellHeight:screen forRow:row];
    
    long margin = cellWidth * 0.0333333;
    float interleave = cellHeight * 0.0875;
    
    //installment label
    long installmentHeight = interleave * 2.8;
    float installmentStart = cellWidth * 0.4333333 + margin;
    float installmentPosition =  installmentHeight + interleave;

    UILabel * installmentLabel = [[UILabel alloc]
                                initWithFrame:CGRectMake(installmentStart,
                                                         installmentPosition,
                                                         cellWidth - installmentStart - margin,
                                                         installmentHeight)];
    installmentLabel.tag = INSTALLMENT_TAG;
    installmentLabel.font = [UIFont fontWithName:@"DIN-Regular" size:12];
    installmentLabel.textAlignment = NSTextAlignmentRight;
    installmentLabel.textColor = theme.fontColor3;
    
    installmentLabel.backgroundColor = [UIColor clearColor];
    installmentLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:installmentLabel];
    
    //installment month label    
    UILabel * installmentMonthLabel = [[UILabel alloc]
                                  initWithFrame:CGRectMake(installmentStart,
                                                           installmentPosition,
                                                           installmentStart - installmentHeight * 2,
                                                           installmentHeight)];
    installmentMonthLabel.tag = INSTALLMENT_MONTH_TAG;
    installmentMonthLabel.font = [UIFont fontWithName:@"DIN-Regular" size:12];
    installmentMonthLabel.textAlignment = NSTextAlignmentLeft;
    installmentMonthLabel.textColor = theme.fontColor3;
    
    installmentMonthLabel.backgroundColor = [UIColor clearColor];
    installmentMonthLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:installmentMonthLabel];

    
    return cell;
}

/*
 Updates cell content data given an already built cell
 */
-(void)updateCell:(UITableViewCell*)cell withData:(NSDictionary*)row {
    [super updateCell:cell withData:row];
    UILabel *installmentLabel, *installmentMonthLabel;
    
    installmentLabel = (UILabel *)[cell.contentView viewWithTag:INSTALLMENT_TAG];
    installmentMonthLabel = (UILabel *)[cell.contentView viewWithTag:INSTALLMENT_MONTH_TAG];
    
    installmentLabel.text = [row objectForKey:_installmentField];
    installmentMonthLabel.text = [row objectForKey:_installmentMonthField];
}

@end
