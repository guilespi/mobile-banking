//
//  MoneyCell.m
//  banking
//
//  Created by Guillermo Winkler on 2/28/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "MoneyCell.h"

static const int TITLE_TAG = 1;
static const int DESC_TAG = 2;
static const int TOTAL_MONEY_TAG = 3;
static const int PARTIAL_MONEY_TAG = 4;

@implementation MoneyCell

- (MoneyCell*) initFromDictionary:(NSDictionary*)definition {
    self = [super init];
    self.identifier = @"money-cell";
    NSDictionary *fields = [definition objectForKey:@"fields"];
    if (!fields) {
        [NSException raise:@"Invalid cell definition" format:@"Cell has missing field list %@", definition];
    }
    _titleField = [fields objectForKey:@"title"];
    _descriptionField = [fields objectForKey:@"description"];
    _totalMoneyField = [fields objectForKey:@"money-total"];
    _partialMoneyField = [fields objectForKey:@"money-partial"];
    
    return self;
}

-(int)getCellHeightForRow:(NSDictionary*)row {
    return 44;
}

-(UITableViewCell*) buildCell {
    UITableViewCell *  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:self.identifier];
    
    UILabel *titleLabel, *descriptionLabel, *totalMoneyLabel, *partialMoneyLabel;
    
    //UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
    //cell.accessoryView = [[UIImageView alloc] initWithImage:indicatorImage];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 220.0, 15.0)];
    titleLabel.tag = TITLE_TAG;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:titleLabel];
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 220.0, 25.0)];
    descriptionLabel.tag = DESC_TAG;
    descriptionLabel.font = [UIFont systemFontOfSize:12.0];
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:descriptionLabel];
    
    return cell;
}

-(void)updateCell:(UITableViewCell*)cell withData:(NSDictionary*)row {
    UILabel *titleLabel, *descriptionLabel;
    
    titleLabel = (UILabel *)[cell.contentView viewWithTag:TITLE_TAG];
    descriptionLabel = (UILabel *)[cell.contentView viewWithTag:DESC_TAG];
    
    titleLabel.text = [row objectForKey:_titleField];
    descriptionLabel.text = [row objectForKey:_descriptionField];
    
}


@end
