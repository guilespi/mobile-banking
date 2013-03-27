//
//  DocumentPickerView.m
//  banking
//
//  Created by Gabriel Monteagudo on 3/22/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "AnimatedPickerView.h"

@implementation AnimatedPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        super.hidden = YES; //Initially hidden; set the base class property to avoid the animation
        self.showsSelectionIndicator = YES;
    }
    
    return self;
}

- (id)initAtBottomOfScreen
{
    //Position the picker at the bottom of the screen, in order to perform a bottom-up animation later
    return [self initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 320, 200)];
}

- (void)setHidden:(BOOL)hidden
{
    if (hidden != super.hidden)
    {
        [UIView animateWithDuration: 0.3
                animations:^
                {
                    if (!hidden)
                    {
                        super.hidden = NO;
                    }
                    self.transform = CGAffineTransformMakeTranslation(0, 182 * (hidden ? 1 : -1));
                }
                completion:^(BOOL finished)
                {
                    if (hidden)
                    {
                        super.hidden = YES;
                    }
                }
         ];
    }
}

@end
