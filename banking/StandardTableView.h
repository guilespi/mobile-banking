//
//  StandardTableView.h
//  banking
//
//  Created by Guillermo Winkler on 2/23/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListView;

@interface StandardTableView : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView * m_tableView;
    UIImageView * m_imageView;
    NSArray *m_data;
}


@property ListView *definition;

-(StandardTableView*)initWithDefinition:(ListView*)def;

@end
