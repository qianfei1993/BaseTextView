//
//  ViewController.m
//  BaseTextView
//
//  Created by damai on 2019/4/25.
//  Copyright © 2019 personal. All rights reserved.
//

#import "ViewController.h"
#import "BaseTextView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *touchView;


// 不做输入限制
@property (weak, nonatomic) IBOutlet BaseTextView *normalTextView;

// 限制输入中文
@property (weak, nonatomic) IBOutlet BaseTextView *chTextView;

// 限制输入中英文数字
@property (weak, nonatomic) IBOutlet BaseTextView *allTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWithTouchView];
    
    // 无输入限制
    // 设置placeholder样式
    self.normalTextView.placeholderLabel.text = @"我不是默认的输入提示语";
    self.normalTextView.placeholderLabel.textColor = [UIColor redColor];
    self.normalTextView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    self.normalTextView.font = [UIFont systemFontOfSize:15];
    self.normalTextView.maxLength = 2000;//显示numberLabel
    
    
    // 限制输入中文
    self.chTextView.inputType = InputTypeCHZN;
    self.chTextView.placeholderLabel.text = @"请输入一点什么吧";
    self.chTextView.isFixed = NO;
    self.chTextView.maxLength = 2000;//显示numberLabel
    // 设置numberLabel样式
    self.chTextView.numberLabel.font = [UIFont systemFontOfSize:12];
    self.chTextView.numberLabel.textColor = [UIColor redColor];
    
    
    
    // 限制输入中英文数字
    self.allTextView.inputType = InputTypeCHZNOrNumberOrLetter;
    
}


- (void)setupWithTouchView{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.touchView.userInteractionEnabled = YES;
    [self.touchView addGestureRecognizer:tap];
}
- (void)tapAction:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}


@end
