//
//  PageControlView.m
//  CustomPageControl
//
//  Created by BaoBaoDaRen on 2018/12/3.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "PageControlView.h"

@interface PageControlView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray * pageArr;
@property (nonatomic, strong) NSTimer * pageTimer;

@end

@implementation PageControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (NSArray *)pageArr
{
    if (!_pageArr) {
        
        _pageArr = [NSArray array];
    }
    return  _pageArr;
}

- (void)setBannerViewScrollViewWithData:(NSArray *)bannerArr
{
    self.pageArr = bannerArr;

    CGFloat top_H = 45;
    CGFloat bottom_M = 15;
    
    CGFloat pageH = 7;
    CGFloat selectedPageW = 13;
    CGFloat unselectedPageW = pageH;
    CGFloat margin = 7;
    
    if (self.caroselScrollView) {
        
        [self.caroselScrollView removeFromSuperview];
    }
    self.caroselScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top_H, self.frame.size.width, self.frame.size.height - top_H - bottom_M * 2 - pageH)];
    [self addSubview:self.caroselScrollView];
    
    self.caroselScrollView.contentSize = CGSizeMake(self.caroselScrollView.frame.size.width * bannerArr.count, self.caroselScrollView.frame.size.height);
    
    NSArray *colorArr = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];
    for (int i = 0; i < bannerArr.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.caroselScrollView.frame.size.width * i, 0, self.caroselScrollView.frame.size.width, self.caroselScrollView.frame.size.height)];
        [self.caroselScrollView addSubview:view];
        
        view.backgroundColor = colorArr[i];
    }
    self.caroselScrollView.scrollEnabled = YES;
    self.caroselScrollView.showsHorizontalScrollIndicator = NO;
    self.caroselScrollView.bounces = NO;
    self.caroselScrollView.delegate = self;
    self.caroselScrollView.pagingEnabled = YES;
    
    if (self.pageControlView) {
        
        [self.pageControlView removeFromSuperview];
    }
    CGFloat pageView_W = selectedPageW + (unselectedPageW + margin) * (bannerArr.count - 1);
    self.pageControlView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - pageView_W / 2, self.frame.size.height - bottom_M - pageH, pageView_W, pageH)];
    _pageControlView.center = CGPointMake(self.center.x, _pageControlView.center.y);
    [self addSubview:self.pageControlView];
    
    [self setCustomPageControlView:bannerArr.count];

}
#pragma mark - 用UIView代替布局pageControl...
#define WeakSelf(type)  __weak typeof(type) weak##type = type; // weak
- (void)setCustomPageControlView:(NSInteger)number
{
    CGFloat selectedNum = 0;
    CGFloat margin = 7;
    CGFloat pageH = 7;
    CGFloat selectedPageW = 13;
    CGFloat unselectedPageW = pageH;
    CGFloat leftM = 0;
    CGFloat pageW = 7;
    
    for (int i = 0; i < number; i++)
    {
        if (i > selectedNum)
        {
            leftM = selectedPageW * 1 + unselectedPageW * (i - 1) + margin * i;
        } else
        {
            leftM = unselectedPageW * i + margin * i;
        }
        if (i == selectedNum)
        {
            pageW = selectedPageW;
        } else
        {
            pageW = unselectedPageW;
        }
        
        UIView * pageV = [[UIView alloc] initWithFrame:CGRectMake(leftM, 0, pageW, pageH)];
        [self.pageControlView addSubview:pageV];
        pageV.layer.masksToBounds = YES;
        pageV.layer.cornerRadius = 4;
        pageV.tag = i;
        if (i == selectedNum)
        {
            pageV.backgroundColor = [self colorWithHexString:@"#EC9E81"];
        } else
        {
            pageV.backgroundColor = [self colorWithHexString:@"#DADADA"];
        }
    }
    
    [self.pageTimer invalidate];
    self.pageTimer = nil;

    self.pageTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(pageControlBeginRotate) userInfo:nil repeats:YES];
}
- (void)pageControlBeginRotate
{
    CGFloat getOffset = self.caroselScrollView.contentOffset.x;
    getOffset += self.caroselScrollView.frame.size.width;
    
    
    WeakSelf(self)
    if (getOffset >= self.caroselScrollView.frame.size.width * 3)
    {
        [UIView transitionWithView:self.caroselScrollView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            weakself.caroselScrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            
        }];
    } else
    {
        [UIView transitionWithView:self.caroselScrollView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            weakself.caroselScrollView.contentOffset = CGPointMake(getOffset, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    int newOffset = (int)(self.caroselScrollView.contentOffset.x / self.caroselScrollView.frame.size.width);
    [self setPageControlSelectedPageNumber:newOffset];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int selected_Num = (int)(self.caroselScrollView.contentOffset.x / self.caroselScrollView.frame.size.width);
    [self setPageControlSelectedPageNumber:selected_Num];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int selected_Num = (int)(self.caroselScrollView.contentOffset.x / self.caroselScrollView.frame.size.width);
    [self setPageControlSelectedPageNumber:selected_Num];
}

- (void)setPageControlSelectedPageNumber:(int)selectedNum
{
    for (id subV in [self.pageControlView subviews])
    {
        if ([subV isKindOfClass:[UIView class]])
        {
            UIView * pageV = (UIView *)subV;
            
            CGFloat margin = 7;
            CGFloat pageH = 7;
            CGFloat selectedPageW = 13;
            CGFloat unSelectedPageW = pageH;
            CGFloat leftM = 0;
            CGFloat pageW = 7;
            
#pragma 此处替换为: self.pageArr.count
            if (pageV.tag > selectedNum)
            {
                leftM = selectedPageW * 1 + unSelectedPageW * (pageV.tag - 1) + margin * pageV.tag;
            }else
            {
                leftM = unSelectedPageW * pageV.tag + margin * pageV.tag;
            }
            if (pageV.tag == selectedNum)
            {
                pageW = selectedPageW;
            } else
            {
                pageW = unSelectedPageW;
            }
            pageV.frame = CGRectMake(leftM, 0, pageW, pageH);
            
            if (pageV.tag == selectedNum)
            {
                pageV.backgroundColor = [self colorWithHexString:@"#EC9E81"];
            } else
            {
                pageV.backgroundColor = [self colorWithHexString:@"#DADADA"];
            }
        }
    }
}



- (void)dealloc
{
    [self.pageTimer invalidate];
    self.pageTimer = nil;
}

#pragma mark - 16进制RGB转换...
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
    {
        return DEFAULT_VOID_COLOR;
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return DEFAULT_VOID_COLOR;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
