//
//  Theme.m
//  banking
//
//  Created by Guillermo Winkler on 3/7/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "Theme.h"
#import "UIColor+colorFromHexString.h"

@implementation Theme

-(Theme*) initFromDictionary:(NSDictionary *)d {
    self = [super init];
    _color1 = [UIColor colorFromHexString:[d objectForKey:@"color1"] ?: @"#043254"];
    _color2 = [UIColor colorFromHexString:[d objectForKey:@"color2"] ?: @"#f7f7f7" ];
    _color3 = [UIColor colorFromHexString:[d objectForKey:@"color3"] ?: @"#ffc600"];
    _borderColor = [UIColor colorFromHexString:[d objectForKey:@"border-color"] ?: @"#9a9a9a"];
    _fontColor1 = [UIColor colorFromHexString:[d objectForKey:@"font-color1"] ?: @"#ffffff"];
    _fontColor2 = [UIColor colorFromHexString:[d objectForKey:@"font-color2"] ?: @"#043254"];
    _fontColor3 = [UIColor colorFromHexString:[d objectForKey:@"font-color3"] ?: @"#ffc600"];
    _dottedLineColor = [UIColor colorFromHexString:[d objectForKey:@"dotted-line-color"] ?: @"#93a4b0"];
    _headerOpacity = [[d objectForKey:@"header-opacity"] ?: @"0.1f" floatValue];
    _tableCellOpacity = [[d objectForKey:@"table-cell-opacity"] ?: @"0.1f" floatValue];
    return self;
}
@end
