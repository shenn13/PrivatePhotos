//
//  XPChangePasswordViewController.m
//  PhotoSecurity
//
//  Created by nhope on 2017/3/21.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPChangePasswordViewController.h"
#import "GDTMobBannerView.h"


#import <CoreLocation/CLLocationManagerDelegate.h>
#import <StoreKit/StoreKit.h>

@interface XPChangePasswordViewController ()<GDTMobBannerViewDelegate>{
     GDTMobBannerView *_bannerView;
}

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
    
 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0,kScreenHeight - 64 - 65,kScreenWidth,65) appkey:GDT_APP_ID placementId:GDT_APP_BID];
        
        
    } else {
        _bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0,kScreenHeight - 64 - 50,kScreenWidth,50) appkey:GDT_APP_ID placementId:GDT_APP_BID];
    }
    
    
    if (IS_OS_7_OR_LATER) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    _bannerView.delegate = self;
    _bannerView.currentViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    _bannerView.isAnimationOn = YES;
    _bannerView.showCloseBtn = YES;
    _bannerView.isGpsOn = YES;
    [_bannerView loadAdAndShow];
    [self.view addSubview:_bannerView];
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
