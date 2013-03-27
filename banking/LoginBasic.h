//
//  LoginBasic.h
//  banking
//
//  Created by Guillermo Winkler on 3/6/13.
//  Copyright (c) 2013 Infocorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "AnimatedPickerView.h"

@interface LoginBasic : UIViewController<UIPickerViewDelegate, UITextFieldDelegate> {
    long _borderWidth, _textFieldHeight, _fieldInterleave;
    AnimatedPickerView *_documentPicker;
    NSArray *_documentTypes;
    UITextField *_txtDocumentType, *_txtUser, *_txtPassword;
    UIView *_headerView;
}

@property LoginView *definition;

- (LoginBasic*)initWithDef:(LoginView*)definition;

@end
