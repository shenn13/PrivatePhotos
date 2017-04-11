//
//  XPFTPViewController.h
//  PhotoSecurity
//
//  Created by nhope on 2017/3/24.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTMobInterstitial.h"

@interface XPFTPViewController : UIViewController<GDTMobInterstitialDelegate>{
    GDTMobInterstitial *_interstitialObj;
}

@end
