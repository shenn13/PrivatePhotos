//
//  XPChangePasswordViewController.m
//  PhotoSecurity
//
//  Created by nhope on 2017/3/21.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPChangePasswordViewController.h"
@import GoogleMobileAds;

@interface XPChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet GADBannerView *bannweView;

/// 旧密码输入框
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextFiled;
/// 新密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/// 新密码确认框
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;


@end

@implementation XPChangePasswordViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Change Password", nil);
    
    self.bannweView.adUnitID = AdMob_BannerViewAdUnitID;
    self.bannweView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.bannweView loadRequest:request];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)settingButtonAction:(UIButton *)sender {
    
    NSString *oldPassword = [self.oldPasswordTextFiled.text trim];
    if (0 == oldPassword.length) {
        
        [self.oldPasswordTextFiled setText:nil];
        [self.oldPasswordTextFiled shake];
        return;
    }
    if (![XPPasswordTool verifyPassword:oldPassword]) {
        [XPProgressHUD showFailureHUD:NSLocalizedString(@"Old password is incorrect", nil) toView:self.view];
        return;
    }
    NSString *password = [self.passwordTextField.text trim];
    NSString *confirmPassword = [self.confirmPasswordTextField.text trim];
    if (0 == password.length) {
        return [self.passwordTextField shake];
    }
    if (0 == confirmPassword.length) {
        return [self.confirmPasswordTextField shake];
    }
    if (password.length < XPPasswordMinimalLength) {
        [XPProgressHUD showFailureHUD:NSLocalizedString(@"Password length is at least 6 characters", nil) toView:self.view];
        return;
    }
    if (![password isEqualToString:confirmPassword]) {
        [XPProgressHUD showFailureHUD:NSLocalizedString(@"The password entered twice is inconsistent", nil) toView:self.view];
        return;
    }
    [XPPasswordTool storagePassword:password];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [XPProgressHUD showSuccessHUD:NSLocalizedString(@"Password has been modified successfully", nil) toView:window];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
