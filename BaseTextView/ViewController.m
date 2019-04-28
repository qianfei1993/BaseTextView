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
    self.normalTextView.lineSpacing = 20;// 设置行间距
    self.normalTextView.indentNum = 2; // 设置首行缩进
    self.normalTextView.maxLength = 2000;// 显示numberLabel
    // 设置numberLabel样式
    self.normalTextView.numberLabel.font = [UIFont systemFontOfSize:12];
    self.normalTextView.numberLabel.textColor = [UIColor redColor];
    self.normalTextView.didChangeBlock = ^(UITextView * _Nonnull textView) {
        NSLog(@"normalTextView=%@",textView.text);
    };
    
    
    // 限制输入中文
    self.chTextView.inputType = TextViewInputTypeCHZN;
    self.chTextView.placeholderLabel.text = @"请输入一点什么吧";
    self.chTextView.isFixed = NO;// numberLabel跟随内容滚动
    self.chTextView.text = @"邃无端喜研剑道,123"; //设置不合法字符串会被重置
    self.chTextView.maxLength = 2000;// 显示numberLabel
    self.chTextView.didChangeBlock = ^(UITextView * _Nonnull textView) {
        NSLog(@"chTextView=%@",textView.text);
    };
    
    
    // 限制输入中英文数字，使用默认设置
    self.allTextView.inputType = TextViewInputTypeCHZNOrNumberOrLetter;
    self.allTextView.indentNum = 2; // 设置首行缩进
    self.allTextView.text = @"邃无端喜研剑道，一心追求剑境臻上，欲破除常规开展新路，因心思专注而有大成，于峰壁间留下单锋剑意，遂成单锋剑之源头。但后来却被卷入谜般的儒门灭佾惨案，至此不知所踪。后被墨倾池寻回，再入江湖。邃无端，即是深邃无尽之意；号隐锋深鸣，则是形容无端锋芒含藏，却因天资异禀隐藏不尽，而已鸣动难抑，类似潜龙暗动的意象，而后他终将飞升而出。无端的诗号，则是配合他的直性及剑境天赋；长久欲寻大道却难辨虚实，如此便依凭正心而往，什么样的巅峰功名都非是永久不变的，而他永远只专于剑道本身，不为外物所扰。"; // 设置默认字符串
    // 内容发生变化的回调
    self.allTextView.didChangeBlock = ^(UITextView * _Nonnull textView) {
        NSLog(@"normalTextView=%@",textView.text);
    };
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
