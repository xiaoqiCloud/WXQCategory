//
//  WXQViewController.m
//  WXQCategory
//
//  Created by xiaoqiCloud on 03/29/2023.
//  Copyright (c) 2023 xiaoqiCloud. All rights reserved.
//

#import "WXQViewController.h"
#import <WXQCategory/WXQCategory.h>
@interface WXQViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIView *phoneLine;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *passwordLine;

@end

@implementation WXQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"登录";
    
    self.phoneField.delegate = self;
    self.passwordField.delegate = self;
    
    [MBProgressHUD showMessage:@"加载中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.phoneField) {
        return [textField qd_formatPhoneWithRange:range replacementString:string];
    } else if (textField == self.passwordField) {
        return [textField qd_isValidCharacter:range replacementString:string limit:18];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.phoneField) {
        self.phoneLine.backgroundColor = [UIColor blueColor];
        self.passwordLine.backgroundColor = [UIColor colorWithRed:229/255. green:229/255. blue:234/255. alpha:1];
    } else if (textField == self.passwordField) {
        self.phoneLine.backgroundColor = [UIColor colorWithRed:229/255. green:229/255. blue:234/255. alpha:1];
        self.passwordLine.backgroundColor = [UIColor blueColor];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.phoneField) {
        self.phoneLine.backgroundColor = [UIColor colorWithRed:229/255. green:229/255. blue:234/255. alpha:1];
    } else if (textField == self.passwordField) {
        self.passwordLine.backgroundColor = [UIColor colorWithRed:229/255. green:229/255. blue:234/255. alpha:1];
    }
    return YES;
}

- (IBAction)didLoginClick:(UIButton *)sender {
    NSLog(@"\nphone = %@\npassword = %@",[self.phoneField.text stringRemoveBlank], self.passwordField.text);
    [self.view endEditing:YES];
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
