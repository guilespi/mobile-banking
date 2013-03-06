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

#define kCustomRowCount     1

@interface StandardTableView ()

@end

@implementation StandardTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(StandardTableView*)initWithDefinition:(ListView*)def {
    _definition = def;
    self = [super init];
    return self;
}

- (void)loadView
{
    m_tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    m_imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    m_imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
    
    m_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [m_tableView reloadData];
    
    self.view = m_tableView;
    m_tableView.backgroundView = m_imageView;
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
        return [_definition.cell getCellHeightForRow:m_data[indexPath.row]];
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
    NSString *cellIdentifier = _definition.cell.identifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [_definition.cell buildCell];
    }
    [_definition.cell updateCell:cell withData:m_data[indexPath.row]];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
