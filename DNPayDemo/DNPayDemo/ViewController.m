//
//  ViewController.m
//  DNPayDemo
//
//  Created by mainone on 2017/3/2.
//  Copyright © 2017年 mainone. All rights reserved.
//

#import "ViewController.h"
#import "DNPayManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (IBAction)payBtnClick:(UIButton *)sender {
    NSInteger index= sender.tag;
    if (index == 101) {
        [[DNPayManager sharedInstance] aliPayWithOrderString:@"xxx"];
    } else if (index == 102) {
        [[DNPayManager sharedInstance] weChatPayWithDict:@{@"":@""}];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
