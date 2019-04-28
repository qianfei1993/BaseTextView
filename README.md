# BaseTextView
## 效果图
![默认样式](https://github.com/qianfei1993/BaseTextView/blob/master/BaseTextView/image1.png)
![文字样式](https://github.com/qianfei1993/BaseTextView/blob/master/BaseTextView/image2.png)


## 介绍
#### BaseTextView,封装的UITextView基类，配置公共项，设置默认的占位文本，可限制最大输入字数并提示已输入字数和总字数，处理文本预输入字数计算问题，使用正则限制输入类型，使用UILabel自定义占位文本和长度统计文本的样式，提供两种长度统计文本样式（一、固定悬浮在输入框底部；二、在文本内容底部可随文本内容滑动），并将常用delegate方法转为block，使用简单，一行代码满足输入需求；

## 使用
#### 创建UITextView继承自BaseTextView，配置输入类型，设置placeholder和maxLength；
```
#pragma mark —————BaseTextView—————
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 无输入限制
    // 设置placeholder样式
    self.normalTextView.placeholderLabel.text = @"请输入一点什么吧";
    self.normalTextView.placeholderLabel.textColor = [UIColor redColor];
    self.normalTextView.placeholderLabel.font = [UIFont systemFontOfSize:15];
    self.normalTextView.font = [UIFont systemFontOfSize:15];
    self.normalTextView.maxLength = 2000;// 显示numberLabel
    
    
    // 限制输入中文
    self.chTextView.inputType = InputTypeCHZN;
    self.chTextView.placeholderLabel.text = @"请输入一点什么吧";
    self.chTextView.isFixed = NO;// numberLabel跟随内容滚动
    self.chTextView.maxLength = 2000;// 显示numberLabel
    // 设置numberLabel样式
    self.chTextView.numberLabel.font = [UIFont systemFontOfSize:12];
    self.chTextView.numberLabel.textColor = [UIColor redColor];
    
    
    // 限制输入中英文数字，使用默认设置
    self.allTextView.inputType = InputTypeCHZNOrNumberOrLetter;
    self.allTextView.text = @"邃无端喜研剑道，一心追求剑境臻上，欲破除常规、开展新路，因心思专注而有大成，于峰壁间留下单锋剑意，遂成单锋剑之源头。但后来却被卷入谜般的儒门灭佾惨案，至此不知所踪。后被墨倾池寻回，再入江湖。\n邃无端，即是深邃无尽之意；号隐锋深鸣，则是形容无端锋芒含藏，却因天资异禀隐藏不尽，而已鸣动难抑，类似潜龙暗动的意象，而后他终将飞升而出。\n无端的诗号，则是配合他的直性及剑境天赋；长久欲寻大道却难辨虚实，如此便依凭正心而往，什么样的巅峰功名都非是永久不变的，而他永远只专于剑道本身，不为外物所扰。";
    // 内容发生变化的回调
    self.allTextView.didChangeBlock = ^(UITextView * _Nonnull textView) {
        // ...
    };
}
```

