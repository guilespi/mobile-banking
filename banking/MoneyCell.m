//
//  MoneyCell.m
//  banking
//
//  Created by Guillermo Winkler on 2/28/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MoneyCell.h"
#import "UIImage+imageFromColor.h"

@implementation MoneyCell

- (TableCell*) initWithDictionary:(NSDictionary*)definition {
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
    _productNumberField = [fields objectForKey:@"product-number"];
    _rightHeaderField = [fields objectForKey:@"right-header"];
    
    return self;
}

/*
    All money cells have the same height no matter the content
 */
-(int)getCellHeight:(UIView*)screen forRow:(NSDictionary*)row {
    long viewHeight = screen.frame.size.height;
    long height = viewHeight * 0.1843318;
    return height;
}

/*
    Builds a standard money cell
 */
-(UITableViewCell*) buildCell:(UIView*)screen withTheme:(Theme *)theme forRow:(NSDictionary*)row{
    UITableViewCell *  cell = [[UITableViewCell alloc]
                               initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:self.identifier];
    

    long cellWidth = screen.frame.size.width * 0.96875;
    long cellHeight = [self getCellHeight:screen forRow:row];
    
    long margin = cellWidth * 0.0333333;
    float interleave = cellHeight * 0.0875;
    
    //resize the content view to take all the cell size
    CGRect frame = CGRectMake(0,0,cellWidth, cellHeight);
    cell.contentView.frame =frame;
    
    //cell background is black with customized opacity
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight * 0.94)];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:theme.tableCellOpacity];
    [cell.contentView addSubview:backView];
    
    //cell selector
    //TODO: image missing, fix this, should be a button!
    UIImageView *selector = [[UIImageView alloc] initWithImage:[UIImage imageFromColor:[UIColor redColor]]];
    selector.frame = CGRectMake(cellWidth - 15-margin, 0, 15, 18);
    [cell.contentView addSubview:selector];
    
    UILabel *titleLabel, *rightHeaderLabel;
    UILabel *descriptionLabel, *totalMoneyLabel, *partialMoneyLabel, *productNumberLabel;
    //title label
    float titleHeight = interleave * 2.8; //3.3
    float titlePosition = 0.0f; //the label borders make up for the padding
    titleLabel = [[UILabel alloc]
                  initWithFrame:CGRectMake(margin,
                                           titlePosition,
                                           cellWidth / 2,
                                           titleHeight * 2)];
    titleLabel.tag = TITLE_TAG;
    titleLabel.textColor = theme.fontColor1;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"DIN-Regular" size:13];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                  UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:titleLabel];
    
    //right header
    rightHeaderLabel = [[UILabel alloc]
                  initWithFrame:CGRectMake(margin + cellWidth / 2 + margin,
                                           titlePosition,
                                           cellWidth / 2 - 4 * margin,
                                           titleHeight)];
    rightHeaderLabel.tag = RIGHT_HEADER_TAG;
    rightHeaderLabel.textColor = theme.fontColor1;
    rightHeaderLabel.textAlignment = NSTextAlignmentRight;
    rightHeaderLabel.backgroundColor = [UIColor clearColor];
    rightHeaderLabel.font = [UIFont fontWithName:@"DIN-Regular" size:10];
    rightHeaderLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:rightHeaderLabel];
    
    //description label, title takes two lines
    float descPosition = titlePosition + titleHeight * 2;
    float descHeight = titleHeight;
    descriptionLabel = [[UILabel alloc]
                        initWithFrame:CGRectMake(margin,
                                                 descPosition,
                                                 cellWidth / 2,
                                                 descHeight)];
    descriptionLabel.tag = DESC_TAG;
    descriptionLabel.font = [UIFont fontWithName:@"DIN-Regular" size:12];
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.textColor = theme.fontColor3;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                        UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:descriptionLabel];
    
    //create the dashed line in the cell starts at 43,333% of the screen and runs to the border
    float dashStartPosition = cellWidth * 0.4333333;
    float dashVertPosition = descPosition + interleave;// + descHeight + interleave;
    [self createDashedLine:cell
                startPoint:CGPointMake(dashStartPosition, dashVertPosition)
                endPoint:CGPointMake(cellWidth - margin * 2, dashVertPosition)
                andColor:theme.dottedLineColor];
    
    //product number label
    float numberHeight = titleHeight;
    float numberPosition = descPosition + descHeight;
    productNumberLabel = [[UILabel alloc]
                        initWithFrame:CGRectMake(margin,
                                                 numberPosition,
                                                 cellWidth / 2,
                                                 numberHeight)];
    productNumberLabel.tag = PRODUCT_NUMBER_TAG;
    productNumberLabel.font = [UIFont fontWithName:@"DIN-Regular" size:10];
    productNumberLabel.textAlignment = NSTextAlignmentLeft;
    productNumberLabel.textColor = theme.fontColor1;
    productNumberLabel.backgroundColor = [UIColor clearColor];
    productNumberLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:productNumberLabel];
    
    //partial money label
    long moneyHeight = titleHeight;
    long partialMoneyPosition =  dashVertPosition - moneyHeight;
    partialMoneyLabel = [[UILabel alloc]
                       initWithFrame:CGRectMake(dashStartPosition,
                                                partialMoneyPosition,
                                                cellWidth - dashStartPosition - margin,
                                                moneyHeight)];
    partialMoneyLabel.tag = PARTIAL_MONEY_TAG;
    partialMoneyLabel.font = [UIFont fontWithName:@"DIN-Regular" size:16];
    partialMoneyLabel.textAlignment = NSTextAlignmentRight;
    partialMoneyLabel.textColor = theme.fontColor1;

    partialMoneyLabel.backgroundColor = [UIColor clearColor];
    partialMoneyLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:partialMoneyLabel];
    
    //total money label
    long totalMoneyPosition = descPosition + interleave * 2;
    totalMoneyLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(dashStartPosition,
                                                   totalMoneyPosition,
                                                   cellWidth - dashStartPosition - margin,
                                                   moneyHeight)];
    totalMoneyLabel.tag = TOTAL_MONEY_TAG;
    totalMoneyLabel.font = [UIFont fontWithName:@"DIN-Regular" size:16];
    totalMoneyLabel.textAlignment = NSTextAlignmentRight;
    totalMoneyLabel.textColor = theme.fontColor1;
    totalMoneyLabel.backgroundColor = [UIColor clearColor];
    totalMoneyLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:totalMoneyLabel];
    return cell;
}

/*
    Creates a dashed line in the cell passed by parameter, pattern and size are hardcoded
 */
-(void) createDashedLine:(UITableViewCell*)cell startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint andColor:(UIColor *)lineColor{
       
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:cell.bounds];
    [shapeLayer setPosition:cell.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor: lineColor.CGColor];
    [shapeLayer setLineWidth: 0.4f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
      [NSNumber numberWithInt:3], [NSNumber numberWithInt:2], [NSNumber numberWithInt:1],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[cell layer] addSublayer:shapeLayer];

}

/*
    Updates cell content data given an already built cell
 */
-(void)updateCell:(UITableViewCell*)cell withData:(NSDictionary*)row {
    UILabel *titleLabel, *rightHeaderLabel;
    UILabel *descriptionLabel, *totalMoneyLabel, *partialMoneyLabel, *productNumberLabel;
    
    titleLabel = (UILabel *)[cell.contentView viewWithTag:TITLE_TAG];
    rightHeaderLabel = (UILabel *)[cell.contentView viewWithTag:RIGHT_HEADER_TAG];
    descriptionLabel = (UILabel *)[cell.contentView viewWithTag:DESC_TAG];
    totalMoneyLabel = (UILabel *)[cell.contentView viewWithTag:TOTAL_MONEY_TAG];
    partialMoneyLabel = (UILabel *)[cell.contentView viewWithTag:PARTIAL_MONEY_TAG];
    productNumberLabel = (UILabel *)[cell.contentView viewWithTag:PRODUCT_NUMBER_TAG];
    
    titleLabel.text = [row objectForKey:_titleField];
    rightHeaderLabel.text = [row objectForKey:_rightHeaderField];
    descriptionLabel.text = [row objectForKey:_descriptionField];
    totalMoneyLabel.text = [row objectForKey:_totalMoneyField];
    partialMoneyLabel.text = [row objectForKey:_partialMoneyField];
    productNumberLabel.text = [row objectForKey:_productNumberField];
}




@end
