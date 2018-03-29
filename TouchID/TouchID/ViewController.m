//
//  ViewController.m
//  TouchID
//
//  Created by HanYong on 2018/3/29.
//  Copyright © 2018年 HanYong. All rights reserved.
//

#import "ViewController.h"
#import "TouchIDManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self setupNotification];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"点击调用" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(actionDidClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)actionDidClickButton:(UIButton *)sender
{
    [self touchIDTest];
}
- (void)touchIDTest
{
    [TouchIDManager validateTouchID];
}

- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDSuccess) name:ValidateTouchIDSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDNotAvailable) name:ValidateTouchIDNotAvailable object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDNotEnrolled) name:ValidateTouchIDNotEnrolled object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDAuthenticationFailed) name:ValidateTouchIDAuthenticationFailed object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionDidReceiveValidateTouchIDCancel) name:ValidateTouchIDCancel object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(actionTouchIDLockout) name:ValidateTouchIDLockout object:nil];
}
- (void)actionDidReceiveValidateTouchIDSuccess
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDNotAvailable
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDNotEnrolled
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDAuthenticationFailed
{
    NSLog(@"%s",__func__);
}
- (void)actionDidReceiveValidateTouchIDCancel
{
    NSLog(@"%s",__func__);
}
- (void)actionTouchIDLockout
{
    NSLog(@"%s",__func__);
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
