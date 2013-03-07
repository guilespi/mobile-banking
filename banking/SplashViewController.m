//
//  SplashViewController.m
//  banking
//
//  Created by Guillermo Winkler on 2/28/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import "SplashViewController.h"
#import "SplashScreen.h"
#import "UIColor+colorFromHexString.h"
#import "Application.h"

@interface SplashViewController ()

@end


@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    if (!_definition) {
        [NSException raise:@"Unable to launch splash screen" format:@"No definition found"];
    }
    
    long viewSize = self.view.frame.size.width;
    long viewHeight = self.view.frame.size.height;
    
    //place background image, takes the complete view size as frame size
    if (_definition.app.background) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        [imageView setImage:[UIImage imageNamed:_definition.app.background]];
        [self.view addSubview:imageView];
    }
    //place logo screen centered
    if (_definition.logo) {
        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_definition.logo]];
        [logoView setCenter:CGPointMake(viewSize / 2, viewHeight / 2)];
        [self.view addSubview:logoView];
    }
    
    //place company or presentation labels
    UILabel *upperLabel, *lowerLabel;
    
    upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, viewSize, 15.0)];
    [upperLabel setFont:[UIFont fontWithName:_definition.fontName size:8]];
    upperLabel.textAlignment = NSTextAlignmentCenter;
    upperLabel.textColor = _definition.app.theme.fontColor1;
    upperLabel.backgroundColor = [UIColor clearColor];
    upperLabel.text = _definition.upperText;
    [upperLabel setCenter:CGPointMake( viewSize / 2, viewHeight * 0.90)];
    [self.view addSubview:upperLabel];
    
    lowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, viewSize, 15.0)];
    [lowerLabel setFont:[UIFont fontWithName:_definition.fontName size:12]];
    lowerLabel.textAlignment = NSTextAlignmentCenter;
    lowerLabel.textColor = _definition.app.theme.fontColor1;
    lowerLabel.backgroundColor = [UIColor clearColor];
    lowerLabel.text = _definition.lowerText;
    [lowerLabel setCenter:CGPointMake( viewSize / 2, viewHeight * 0.94)];
    [self.view addSubview:lowerLabel];
    
	[self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:
     [NSNumber numberWithBool:YES] afterDelay:3.0];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
