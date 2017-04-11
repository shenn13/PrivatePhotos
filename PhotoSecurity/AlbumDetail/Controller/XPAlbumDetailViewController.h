//
//  XPAlbumDetailViewController.h
//  PhotoSecurity
//
//  Created by nhope on 2017/3/8.
//  Copyright © 2017年 xiaopin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPAlbumModel;
#import "GDTMobInterstitial.h"

@interface XPAlbumDetailViewController : UICollectionViewController<GDTMobInterstitialDelegate>{
    
    GDTMobInterstitial *_interstitialObj;
}


@property (nonatomic, strong) XPAlbumModel *album;

@end
