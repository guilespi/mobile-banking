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
#import "UIImage+imageFromColor.h"

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
        
        
        //Set standard application background
        UIView *backgroundView = [_definition.app createBackgroundView:self.view];
        //m_tableView.backgroundView = backgroundView;
        [self.view addSubview:backgroundView];
        
        
        //Create Table Header
        UIView *headerView = [_definition.app createHeaderView:self.view];
        float headerHeight = headerView.frame.size.height;
        //add Logout icon to header view
        //TODO: this should be a button!
        UIImageView *logout = [[UIImageView alloc] initWithImage:[UIImage imageFromColor:[UIColor redColor]]];
        logout.frame = CGRectMake(viewWidth - headerHeight, 0, headerHeight, headerHeight);
        [headerView addSubview:logout];
        
        //add "home" message to header
        //TODO: this should be a button travelling to the home screen!
        //read review about changing tabs with non tab actions WRONG!
        long separatorPosition = viewWidth * _definition.app.headerSeparatorPosition;
        UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       viewWidth - separatorPosition,
                                                                       textFieldHeight)];
        [homeLabel setCenter:CGPointMake(separatorPosition + (viewWidth - headerHeight - separatorPosition) / 2,
                                         headerView.frame.size.height / 2)];
        homeLabel.text = @"Inicio";
        homeLabel.textAlignment = NSTextAlignmentCenter;
        homeLabel.textColor = _definition.app.theme.fontColor2;
        homeLabel.backgroundColor = [UIColor clearColor];
        homeLabel.font = [UIFont fontWithName:@"DIN-Regular" size:16];
        [headerView addSubview:homeLabel];
        [self.view addSubview:headerView];
        
        //Create subheader with last access time for the user
        float lastAccessViewPosition = headerView.frame.size.height;
        //80px out of 868px
        float lastAccessViewHeight = viewHeight * 0.0921659;
        float lastAccessViewWidth = viewWidth - 2*borderWidth;
        UIView *lastAccessView = [[UIView alloc] initWithFrame:CGRectMake(borderWidth,
                                                                          lastAccessViewPosition,
                                                                          lastAccessViewWidth,
                                                                          lastAccessViewHeight)];
        //create the background color of the view with the parametrized opacity level
        lastAccessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:_definition.app.theme.headerOpacity];
        //add the touch gesture slider
        UIImageView *sliderView = [[UIImageView alloc]
                                   initWithImage:[UIImage imageFromColor:_definition.app.theme.color3]];
        float sliderHeight = lastAccessViewHeight * 0.0625; //5px out of 80px
        sliderView.frame = CGRectMake(0, 0, lastAccessViewWidth, sliderHeight);
        [lastAccessView addSubview:sliderView];
        
        //add the icon
        float iconSize = lastAccessViewHeight - sliderHeight;
        UIImageView *iconView = [[UIImageView alloc]
                                 //TODO: change this to the transparent image!
                                   initWithImage:[UIImage imageFromColor:[UIColor redColor]]];
        iconView.frame = CGRectMake(0, sliderHeight, iconSize, iconSize);
        [lastAccessView addSubview:iconView];
        
        //add the label starts right after the icon
        UILabel *messageLabel = [[UILabel alloc]
                                    initWithFrame:CGRectMake(iconSize,
                                                             0,
                                                             lastAccessViewWidth - iconSize,
                                                             lastAccessViewHeight)];
        messageLabel.text = @"Ultimo acceso: 04/01/2013 18:30";
        messageLabel.font = [UIFont fontWithName:@"DIN-Regular" size:13];
        messageLabel.textAlignment = NSTextAlignmentRight;
        messageLabel.textColor = _definition.app.theme.fontColor1;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleHeight;
        [lastAccessView addSubview:messageLabel];

        
        [self.view addSubview:lastAccessView];
        
        //10px out of 868px
        long tableInterleave = viewHeight * 0.0115207;
        long tablePosition = lastAccessViewPosition + lastAccessViewHeight + tableInterleave * 2;
        _tableView = [[UITableView alloc]
                       initWithFrame:CGRectMake(borderWidth,
                                                tablePosition,
                                                viewWidth - borderWidth * 2,
                                                viewHeight - tablePosition)
                       style:UITableViewStylePlain];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.opaque = NO;
        [_tableView setSeparatorColor:[UIColor clearColor]];
        
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView reloadData];
        
        //self.view = m_tableView;
        [self.view addSubview:_tableView];
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
           _data = response;
           [_tableView reloadData];
       }
         onError:^(NSError* error, NSString *response) {
             
         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data ? [_data count] : kCustomRowCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * ip = [tableView indexPathForSelectedRow];
    
    if(indexPath.row == ip.row && ip.section == indexPath.section) {
        //return 88.0;
    }
    
    if (_data) {
        NSDictionary *row = _data[indexPath.row];
        return [_definition getCellHeight:self.view forRow:row];
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //this is still loading
    if (!_data) {
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
    NSDictionary *row = _data[indexPath.row];
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
