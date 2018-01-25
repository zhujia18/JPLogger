//
//  ViewController.m
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import "ViewController.h"
#import "JPLogger.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *logTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![[JPLogger sharedInstance] checkItemEnable:kJPDebugLogIdentification_Demo1]) {
        [[JPLogger sharedInstance] setItemEnable:kJPDebugLogIdentification_Demo1 enable:YES];
    }
    
    _logTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 30)];
    _logTextField.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    _logTextField.textAlignment = NSTextAlignmentCenter;
    _logTextField.placeholder = @"请输入想记录的日志";
    [self.view addSubview:_logTextField];
    
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake((CGRectGetWidth(self.view.bounds) - 100) / 2.0f, CGRectGetMaxY(_logTextField.frame) + 50, 100, 50);
    [enterBtn setTitle:@"记录" forState:UIControlStateNormal];
    [enterBtn setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5f]];
    [enterBtn addTarget:self action:@selector(writeLog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    
    UIButton *export = [UIButton buttonWithType:UIButtonTypeCustom];
    export.frame = CGRectMake((CGRectGetWidth(self.view.bounds) - 100) / 2.0f, CGRectGetMaxY(enterBtn.frame) + 50, 100, 50);
    [export setTitle:@"导出" forState:UIControlStateNormal];
    [export setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5f]];
    [export addTarget:self action:@selector(export) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:export];
}

- (void)writeLog {
    NSString *logString = _logTextField.text;
    [JPLogger writeLogForIdentification:kJPDebugLogIdentification_Demo1 log:logString];
}

- (void)export {
    [self.view endEditing:YES];
    [JPLogger uploadLogForIdentification:kJPDebugLogIdentification_Demo1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
