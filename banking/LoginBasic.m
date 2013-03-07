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

@interface LoginBasic ()

@end

@implementation LoginBasic

/*
 Triggered when the user presses the dropdown Document Type selector
 */
- (void)onSelectDocument:(id)sender {
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:myPickerView];
}

/*
 Triggered when te user presses the Login button
 */
-(void)onLogin:(id)sender {
    
}

/*
    The only field using the UITextFieldDelegate protocol is the Document Selector UITextField
    which is NOT editable. 
    Since there is no "editable" property for UITextField this is the only way to disable the field
    without disabling the drop-down selector
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

/*
    Transforms the layer passed by parameter to have rounded corners
    Can be used with UIButton.layer, UITextField.layer, etc
 */
- (void)addRoundedCorners:(CALayer*)layer {
    layer.cornerRadius = 3.0f;
    layer.masksToBounds = YES;
    layer.borderColor = [UIColor colorFromHexString:@"#f7f7f7"].CGColor;
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
    //TODO set placeholder font
    txtField.placeholder = placeHolderText;
    txtField.backgroundColor = [UIColor whiteColor];
    txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addRoundedCorners:txtField.layer];
    //set padding using a dummy view on the left
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _borderWidth / 2, _textFieldHeight)];
    txtField.leftView = paddingView;
    txtField.leftViewMode = UITextFieldViewModeAlways;
    return txtField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //TODO: add standard app background stuff
        
        //TODO: add header
        
        long viewWidth = self.view.frame.size.width;
        long viewHeight = self.view.frame.size.height;
        
        //border width is 40px in the original design
        _borderWidth = viewWidth * 0.0625;
        //field height was 70px
        _textFieldHeight = viewHeight * 0.0729167;
        //interleave was 40px
        _fieldInterleave = viewHeight * 0.0416667;
        
        //TODO:translation of the default placeholders
        
        int fieldPosition = 0;
        
        if (true) {
            //create the document type combo-box
            UITextField *txtDocument = [self createTextField:@"Tipo de Documento" inPosition:++fieldPosition];
            txtDocument.delegate = self;
            //create the arrow dropdown selector
            UIButton *dropDownButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [dropDownButton addTarget:self action:@selector(onSelectDocument:) forControlEvents:UIControlEventTouchUpInside];
            dropDownButton.frame = CGRectMake(txtDocument.frame.size.width - _textFieldHeight, 0.0, _textFieldHeight, _textFieldHeight);
            [dropDownButton setBackgroundImage:[UIImage imageNamed: @"arrowDropDown"] forState:UIControlStateNormal];
            [txtDocument addSubview: dropDownButton];
            [txtDocument sendSubviewToBack: dropDownButton];
            [self.view addSubview: txtDocument];
        }
        
        //create user text field
        UITextField *txtUser = [self createTextField:@"Usuario" inPosition:++fieldPosition];
        [self.view addSubview: txtUser];

        //create password text field
        UITextField *txtPassword = [self createTextField:@"Contraseña" inPosition:++fieldPosition];
        txtPassword.secureTextEntry = YES;
        [self.view addSubview: txtPassword];
        
        //create Login button
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //TODO read colors from somewhere
        loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor colorFromHexString:@"#043254"] forState:UIControlStateNormal];

        loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [loginButton setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromHexString:@"#FFC600"]] forState:UIControlStateNormal];

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
        forgotPasswordLabel.textColor = [UIColor whiteColor];
        forgotPasswordLabel.backgroundColor = [UIColor clearColor];
        forgotPasswordLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:forgotPasswordLabel];
        
        //banner
        long bannerVerticalPosition = loginVerticalPosition + _textFieldHeight + _fieldInterleave;
        long bannerHeight = viewHeight * 0.15625;//150px in the original design
        
        //disclaimer label built using a UITextView since multiline display is needed
        long disclaimerTopPosition = bannerVerticalPosition + bannerHeight + _fieldInterleave / 2;
        UITextView *disclaimerLabel = [[UITextView alloc] initWithFrame:CGRectMake(_borderWidth,
                                                                             disclaimerTopPosition,
                                                                             viewWidth - 2 * _borderWidth,
                                                                             _textFieldHeight * 2)];
        disclaimerLabel.text = @"Copyright 2013 - Infocorp Todos los derechos reservados -\nLorem ipsum dolor sit amet. consectetur adipiscing";
        disclaimerLabel.textColor = [UIColor whiteColor];
        disclaimerLabel.backgroundColor = [UIColor clearColor];
        disclaimerLabel.font = [UIFont systemFontOfSize:10];
        disclaimerLabel.userInteractionEnabled = NO;
        [self.view addSubview:disclaimerLabel];
        
        
    }
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
}


/*
 Tell the picker how many document types are available.
 This function is part of the UIPickerViewDelegate protocol and only one picker & component is present
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 5;
    
    return numRows;
}

/* 
 Tell the picker how many components it will have
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%d",row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.view.frame.size.width;
}

@end