//
//  ViewController.m
//  CustomPageControl
//
//  Created by BaoBaoDaRen on 2018/12/3.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "ViewController.h"
#import "PageControlView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    PageControlView *pageV = [[PageControlView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    [self.view addSubview:pageV];
    
    NSArray *bannerArr = @[@"1",@"2",@"3"];
    [pageV setBannerViewScrollViewWithData:bannerArr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
