//
//  ConsolidatedPosition.h
//  banking
//
//  Created by Guillermo Winkler on 3/8/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "ListView.h"

@interface ConsolidatedPosition : ListView {
    NSString *_typeField;
}
@property NSDictionary *cellsByProduct;
@end
