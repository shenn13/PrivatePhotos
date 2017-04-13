//
//  XPFTPViewController.m
//  PhotoSecurity
//
//  Created by nhope on 2017/3/24.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import "XPFTPViewController.h"
#import "XMFTPServer.h"
#import "GDTMobBannerView.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <StoreKit/StoreKit.h>

@interface XPFTPViewController ()<GDTMobBannerViewDelegate>{
    GDTMobBannerView *_bannerView;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) XMFTPServer *ftpServer;

@end

@implementation XPFTPViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAdGDTData];
    
    
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
    
    self.title = NSLocalizedString(@"FTP Service", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self stopFTPServer];
}

#pragma mark - Actions

- (IBAction)toggleButtonAction:(UIButton *)sender {
    
    
    //显示广告**********************************************
    [self startShowAdMob];
    //*****************************************************
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        unsigned int ftpPort = 23023;
        NSString *ip = [XMFTPHelper localIPAddress];
        if (![ip isIP]) {
            sender.selected = !sender.selected;
            [XPProgressHUD showFailureHUD:NSLocalizedString(@"FTP server failed to open, please confirm open WIFI and connect WIFI", nil) toView:self.view];
            return;
        }
        self.textField.text = [NSString stringWithFormat:@"ftp://%@:%d", ip, ftpPort];
        [self stopFTPServer];
        /**
         仅仅开放相片目录
         如果notifyObject传递了self,则需要注意循环引用导致self不能释放的问题,在适当的时候需要自动停止FTP服务器
         */
        _ftpServer = [[XMFTPServer alloc] initWithPort:ftpPort
                                               withDir:photoRootDirectory()
                                          notifyObject:nil];
    } else {
        
        self.textField.text = nil;
        [self stopFTPServer];
    }
}

#pragma mark - Private

- (void)stopFTPServer {
    
    if (_ftpServer) {
        [_ftpServer stopFtpServer];
        _ftpServer = nil;
    }
    
}

//广点通广告加载
-(void)loadAdGDTData{
    _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:GDT_APP_ID placementId:GDT_APP_CID];
    _interstitialObj.delegate = self;
    [_interstitialObj loadAd];
    
}
-(void)startShowAdMob{
    [_interstitialObj presentFromRootViewController:self];
}

#pragma mark  广点通广告---------
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial{
    [_interstitialObj loadAd];
}

@end
