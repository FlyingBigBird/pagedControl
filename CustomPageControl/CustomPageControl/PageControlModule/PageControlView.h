//
//  PageControlView.h
//  CustomPageControl
//
//  Created by BaoBaoDaRen on 2018/12/3.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControlView : UIView

// 轮播图
@property (nonatomic, strong) UIScrollView * caroselScrollView;

// 页码控制器
@property (nonatomic, strong) UIView * pageControlView;


/**
 轮播图传值...

 @param bannerArr 后台返回的数据...
 */
- (void)setBannerViewScrollViewWithData:(NSArray *)bannerArr;

@end
