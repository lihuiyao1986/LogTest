//
//  ViewController.m
//  LogTest
//
//  Created by jk on 2017/4/26.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * array = [NSArray array];
    NSLog(@"%@",[array objectAtIndex:1]);
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
