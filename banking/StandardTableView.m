//
//  StandardTableView.m
//  banking
//
//  Created by Guillermo Winkler on 2/23/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "StandardTableView.h"
#import "ListView.h"
#import "RESTApi.h"
#import "Application.h"

#define kCustomRowCount     1

@interface StandardTableView ()

@end

@implementation StandardTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        long viewWidth = self.view.frame.size.width;
        long viewHeight = self.view.frame.size.height;
        long textFieldHeight = viewHeight * 0.0806452;
        long borderWidth = viewWidth * 0.03125;
        
        UIView *backgroundView = [_definition.app createBackgroundView:self.view];
        //m_tableView.backgroundView = backgroundView;
        [self.view addSubview:backgroundView];
        
        UIView *headerView = [_definition.app createHeaderView:self.view];
        //add HOME message to header
        long separatorPosition = viewWidth * _definition.app.headerSeparatorPosition;
        UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          viewWidth - separatorPosition,
                                                                          textFieldHeight)];
        [homeLabel setCenter:CGPointMake(separatorPosition + (viewWidth - separatorPosition) / 2, headerView.frame.size.height / 2)];
        homeLabel.text = @"Inicio";
        homeLabel.textAlignment = NSTextAlignmentCenter;
        homeLabel.textColor = _definition.app.theme.fontColor2;
        homeLabel.backgroundColor = [UIColor clearColor];
        homeLabel.font = [UIFont fontWithName:@"DIN-Regular" size:17];
        [headerView addSubview:homeLabel];
        [self.view addSubview:headerView];
        
        long lastAccessViewPosition = headerView.frame.size.height;
        //80px out of 868px
        long lastAccessViewHeight = viewHeight * 0.0921659;
        
        //10px out of 868px
        long tableInterleave = viewHeight * 0.0115207;
        long tablePosition = lastAccessViewPosition + lastAccessViewHeight + tableInterleave * 2;
        m_tableView = [[UITableView alloc]
                       initWithFrame:CGRectMake(borderWidth,
                                                tablePosition,
                                                viewWidth - borderWidth * 2,
                                                viewHeight - tablePosition)
                       style:UITableViewStylePlain];
        
        m_tableView.backgroundColor = [UIColor clearColor];
        m_tableView.opaque = NO;
        [m_tableView setSeparatorColor:[UIColor clearColor]];
        
        m_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        m_tableView.delegate = self;
        m_tableView.dataSource = self;
        [m_tableView reloadData];
        
        //self.view = m_tableView;
        [self.view addSubview:m_tableView];
    }
    return self;
}

-(StandardTableView*)initWithDefinition:(ListView*)def {
    _definition = def;
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    if (!_definition) {
        [NSException raise:@"Invalid Table View" format:@"Unable to initialize Standard Table View without definition"];
    }
    RESTApi* api = _definition.dataSource;
    if (!api) {
        [NSException raise:@"Invalid Table View" format:@"Unable to initialize Standard Table View without dataSource"];
    }
    [api execute:nil
       onSuccess:^(NSArray* response) {
           m_data = response;
           [m_tableView reloadData];
       }
         onError:^(NSError* error, NSString *response) {
             
         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_data ? [m_data count] : kCustomRowCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * ip = [tableView indexPathForSelectedRow];
    
    if(indexPath.row == ip.row && ip.section == indexPath.section) {
        //return 88.0;
    }
    
    if (m_data) {
        NSDictionary *row = m_data[indexPath.row];
        return [_definition getCellHeight:self.view forRow:row];
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //this is still loading
    if (!m_data) {
        if (indexPath.row == 0) {
            //TODO: what does the loading cell look like?
            static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:PlaceholderCellIdentifier];
                cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.detailTextLabel.text = @"Loading…";
            return cell;
        }
        return nil;
    }
    
    //data is here, show it
    NSDictionary *row = m_data[indexPath.row];
    NSString *cellIdentifier = [_definition cellIdentifierForRow:row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [_definition buildCell:self.view forRow:row];
    }
    [_definition updateCell:cell withData:row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
