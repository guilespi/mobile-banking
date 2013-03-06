//
//  TableCell.m
//  banking
//
//  Created by Guillermo Winkler on 2/28/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "TableCell.h"
#import "MoneyCell.h"

@implementation TableCell

+(TableCell*) createCell:(NSDictionary*)d {
    NSDictionary *cellStyle = [d objectForKey:@"style"];
    if ([cellStyle isEqual: @"money"]) {
        return [[MoneyCell alloc] initWithDictionary:d];
    }
    [NSException raise:@"Unknown cell style" format:@"Don't know how to build cell style %@", cellStyle];
    return nil; //makes the compiler happy
}

@end
