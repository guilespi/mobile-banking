//
//  LoginBasic.m
//  banking
//
//  Created by Guillermo Winkler on 3/6/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginBasic.h"
#import "UIColor+colorFromHexString.h"
#import "UIImage+imageFromColor.h"
#import "Application.h"

@interface LoginBasic ()

@end

@implementation LoginBasic

/*
 Triggered when the user presses the dropdown Document Type selector
 */
- (void)onSelectDocument:(id)sender {
    if (!_documentTypes) {
        return;
    }
    _documentPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    _documentPicker.delegate = self;
    _documentPicker.showsSelectionIndicator = YES;
    [self.view addSubview:_documentPicker];
}

/*
 Triggered when the user presses the Login button
 */
-(void)onLogin:(id)sender {
    
}

/*
    The only field returning NO here in the UITextFieldDelegate protocol is the 
    Document Selector UITextField which is NOT editable since it's simulating a combo.
    Since there is no "editable" property for UITextField this is the only way to disable the field
    without disabling the drop-down selector
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _txtDocumentType) {
        return NO;
    }
    if (_documentPicker) {
        _documentPicker.hidden = true;
    }
    return YES;
}

/*
    This is in order to close the keyboard when the return key is pressed
 */
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
    Transforms the layer passed by parameter to have rounded corners
    Can be used with UIButton.layer, UITextField.layer, etc
 */
- (void)addRoundedCorners:(CALayer*)layer {
    layer.cornerRadius = 3.0f;
    layer.masksToBounds = YES;
    layer.borderColor = _definition.app.theme.borderColor.CGColor;
    layer.borderWidth = 1;
}

/*
    Creates a text field in the specified position in the view
 */
- (UITextField*)createTextField:(NSString*)placeHolderText inPosition:(int)position {
    long viewWidth = self.view.frame.size.width;
    //TODO:height start position should consider header height
    UITextField *txtField = [[UITextField alloc]initWithFrame: CGRectMake(_borderWidth,
                                                                          _fieldInterleave * position + _textFieldHeight * (position - 1),
                                                                          viewWidth -  _borderWidth * 2 ,
                                                                          _textFieldHeight)];
    txtField.placeholder = placeHolderText;
    txtField.font = [UIFont fontWithName:@"DIN-Regular" size:17];
    txtField.textColor = _definition.app.theme.fontColor2;
    txtField.backgroundColor = _definition.app.theme.color2;
    txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addRoundedCorners:txtField.layer];
    //set padding using a dummy view on the left
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _borderWidth / 2, _textFieldHeight)];
    txtField.leftView = paddingView;
    txtField.leftViewMode = UITextFieldViewModeAlways;
    txtField.delegate = self;
    return txtField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //TODO: add standard app background stuff
        //place background image, takes the complete view size as frame size
        if (_definition.app.background) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
            [imageView setImage:[UIImage imageNamed:_definition.app.background]];
            [self.view addSubview:imageView];
        }
        
        //TODO: add header
        
        long viewWidth = self.view.frame.size.width;
        long viewHeight = self.view.frame.size.height;
        
        //border width is 40px in the original design
        _borderWidth = viewWidth * 0.0625;
        //field height was 70px
        _textFieldHeight = viewHeight * 0.0729167;
        //interleave was 40px
        _fieldInterleave = viewHeight * 0.0416667;
        
        //TODO:translation of the default placeholders and labels
        
        int fieldPosition = 0;
        if (_definition.useDocumentType) {
            //create the document type combo-box
            _txtDocumentType = [self createTextField:@"Tipo de Documento" inPosition:++fieldPosition];
            //create the arrow dropdown selector
            UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [dropDownButton addTarget:self action:@selector(onSelectDocument:) forControlEvents:UIControlEventTouchUpInside];
            dropDownButton.frame = CGRectMake(_txtDocumentType.frame.size.width - _textFieldHeight, 0.0, _textFieldHeight, _textFieldHeight);
            [dropDownButton setBackgroundImage:[UIImage imageNamed: @"arrowDropDown"] forState:UIControlStateNormal];
            [_txtDocumentType addSubview: dropDownButton];
            [_txtDocumentType sendSubviewToBack: dropDownButton];
            [self.view addSubview: _txtDocumentType];
            
            //load types
            API* api = _definition.documentAPI;
            if (!api) {
                [NSException raise:@"Invalid Login" format:@"Unable to create login screen with document type without an API"];
            }
            [api execute:nil
               onSuccess:^(NSArray* response) {
                   _documentTypes = response;
               }
               onError:^(NSError* error, NSString *response) {
                
            }];
        }
        
        //create user text field
        NSString *userPlaceHolder = _definition.useDocumentType ? @"Documento" : @"Usuario";
        _txtUser = [self createTextField:userPlaceHolder inPosition:++fieldPosition];
        [self.view addSubview: _txtUser];

        //create password text field
        _txtPassword = [self createTextField:@"Contraseña" inPosition:++fieldPosition];
        _txtPassword.secureTextEntry = YES;
        [self.view addSubview: _txtPassword];
        
        //create Login button
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //TODO read colors from somewhere
        loginButton.titleLabel.font = [UIFont fontWithName:@"DIN-Regular" size:17];
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [loginButton setTitleColor:_definition.app.theme.color1 forState:UIControlStateNormal];

        loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [loginButton setBackgroundImage:[UIImage imageFromColor:_definition.app.theme.color3] forState:UIControlStateNormal];

        [loginButton addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
        long loginVerticalPosition = _fieldInterleave * (fieldPosition + 1) + _textFieldHeight * fieldPosition;
        loginButton.frame = CGRectMake(viewWidth / 2 + _borderWidth,
                                       loginVerticalPosition,
                                       viewWidth / 2 - _borderWidth * 2,
                                       _textFieldHeight);
        
        [self addRoundedCorners:loginButton.layer];
        [self.view addSubview: loginButton];
        
        //forgot your password label
        UILabel *forgotPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(_borderWidth * 1.25,
                                                                                 loginVerticalPosition,
                                                                                 viewWidth / 2,
                                                                                 _textFieldHeight)];
        forgotPasswordLabel.text = @"Olvidó su contraseña?";
        forgotPasswordLabel.textColor = _definition.app.theme.fontColor1;
        forgotPasswordLabel.backgroundColor = [UIColor clearColor];
        forgotPasswordLabel.font = [UIFont fontWithName:@"DIN-Regular" size:14];
        [self.view addSubview:forgotPasswordLabel];
        
        //banner
        long bannerVerticalPosition = loginVerticalPosition + _textFieldHeight + _fieldInterleave;
        long bannerHeight = viewHeight * 0.15625;//150px in the original design
        UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(_borderWidth,
                                                                                bannerVerticalPosition,
                                                                                viewWidth - _borderWidth * 2,
                                                                                bannerHeight)];
        //TODO: get the banner image from somewhere reasonable
        [bannerView setImage:[UIImage imageNamed:@"bannerLogin"]];
        [self.view addSubview:bannerView];
        
        //disclaimer label built using a UITextView since multiline display is needed
        long disclaimerTopPosition = bannerVerticalPosition + bannerHeight + _fieldInterleave / 2;
        UITextView *disclaimerLabel = [[UITextView alloc] initWithFrame:CGRectMake(_borderWidth,
                                                                             disclaimerTopPosition,
                                                                             viewWidth - 2 * _borderWidth,
                                                                             _textFieldHeight * 2)];
        disclaimerLabel.text = _definition.disclaimer;
        disclaimerLabel.textColor = _definition.app.theme.fontColor1;
        disclaimerLabel.backgroundColor = [UIColor clearColor];
        disclaimerLabel.font = [UIFont fontWithName:@"DIN-Regular" size:10];
        disclaimerLabel.userInteractionEnabled = NO;
        [self.view addSubview:disclaimerLabel];
        
    }
    return self;
}

- (LoginBasic*)initWithDef:(LoginView*)definition {
    _definition = definition;
    self = [super init];
    return self;
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

/*
 Triggered when the user selects one item of the document type dropdown picker.
 This function is part of the UIPickerViewDelegate protocol and only one picker & component is present
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
    _documentPicker.hidden = true;
    if (row == 0) {
        //teoretically this is not possible since this row cannot be selected
        return;
    }
    NSDictionary *data = _documentTypes[row - 1];
    NSString *text = [data objectForKey:@"description"];
    [_txtDocumentType setText:text];
}


/*
 Tell the picker how many document types are available.
 This function is part of the UIPickerViewDelegate protocol and only one picker & component is present
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_documentTypes count] + 1;
}

/* 
 Tell the picker how many components it will have
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"";
    }
    NSDictionary *data = _documentTypes[row - 1];
    return [data objectForKey:@"description"];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width;
}

@end
