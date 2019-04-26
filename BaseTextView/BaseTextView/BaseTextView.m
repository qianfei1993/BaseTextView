//
//  BaseTextView.m
//  BaseTextView
//
//  Created by damai on 2019/4/25.
//  Copyright © 2019 personal. All rights reserved.
//

#import "BaseTextView.h"

// 输入限制
typedef NS_ENUM(NSInteger, LimitType){
    LimitTypeNone,                 // 全字符
    LimitTypeCHZN,                 // 只能输入中文
    LimitTypeLetter,               // 只能输入字母
    LimitTypeNumber,               // 只能输入数字
    LimitTypeMoney,                // 只能输入数字和.
    LimitTypePunctuation,          // 只能输入标点
    LimitTypeCHZNOrNumOrLetter     // 只能输入中文英文数字
};

@implementation NSString (Validate)

#pragma mark - 输入限制
// 中文
- (BOOL)isCHZN{
    
    NSString *regexStr = @"^[\\u4e00-\\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [predicate evaluateWithObject:self];
}

// 字母
- (BOOL)isLetter{
    
    NSString *regexStr = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [predicate evaluateWithObject:self];
}

// 数字
- (BOOL)isNumber{
    
    NSString *regexStr = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [predicate evaluateWithObject:self];
}

// 标点符号
- (BOOL)isPunctuation{
    
    NSString *regexStr = @"^[[:punct:]]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [predicate evaluateWithObject:self];
}


//对系统键盘做判断
-(BOOL)isSystem{
    
    if ([@"➋➌➏➎➍➐➑➒" containsString:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isRightChar:(int)a{
    
    if ((a >= 0x4e00 && a <= 0x9fa5) || (a>=65 && a<91) || (a>=97 && a<123) || (a>=48 && a<58)) {
        return YES;
    }
    return NO;
}
@end


@interface BaseTextView ()<UITextViewDelegate>
@property(nonatomic, assign)LimitType limitType;
@property (nonatomic, strong) UIView *numberView;
@end

@implementation BaseTextView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self initialize];
    }
    return self;
}

-(instancetype)init{
    
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}


-(void)initialize{
    
    //设置默认值
    self.keyboardType = UIKeyboardTypeDefault;
    self.textAlignment = NSTextAlignmentLeft;
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:15];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.clipsToBounds = YES;
    self.delegate = self;
    self.isFixed = YES;
    
    self.inputType = InputTypeNormal;
    
    if (!self.placeholderLabel) {
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, self.frame.size.width-5, self.frame.size.height-8)];
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
        self.placeholderLabel.backgroundColor = [UIColor clearColor];
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.font = [UIFont systemFontOfSize:15];
        self.placeholderLabel.text = @"请输入...";
        [self addSubview:self.placeholderLabel];
    }
    
    if (!self.numberLabel) {
        
        self.numberView = [[UIView alloc]initWithFrame:CGRectZero];
        self.numberView.backgroundColor = self.backgroundColor;
        [self addSubview:self.numberView];
        
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.numberLabel.backgroundColor = [UIColor clearColor];
        self.numberLabel.font = [UIFont systemFontOfSize:15];
        self.numberLabel.textColor = [UIColor lightGrayColor];
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        [self.numberView addSubview:self.numberLabel];
    }
}


-(void)layoutSubviews{
    
    self.placeholderLabel.frame = CGRectMake(5, 8, self.frame.size.width-5, self.frame.size.height-8);
    [self.placeholderLabel sizeToFit];
    [self.numberLabel sizeToFit];
    if (self.maxLength > 0) {
        [self refreshFrame];
    }
}

#pragma mark —————Set—————
// 设置输入类型 1.确定键盘类型，2.输入类型限制，3.输入长度限制
- (void)setInputType:(InputType)inputType{
    _inputType = inputType;
    switch (_inputType) {
        case InputTypeNormal:
            self.limitType = LimitTypeNone;
            break;
        case InputTypeCHZN:
            self.limitType = LimitTypeCHZN;
            break;
        case InputTypeCHZNOrNumberOrLetter:
            self.limitType = LimitTypeCHZNOrNumOrLetter;
            break;
        default:
            self.limitType = LimitTypeNone;
            break;
    }
}

-(void)setPlaceholderLabel:(UILabel *)placeholderLabel{
    
    [self endEditing:NO];
    _placeholderLabel = placeholderLabel;
}

-(void)setMaxLength:(NSInteger)maxLength{
    
    _maxLength = maxLength;
    self.numberLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_maxLength];
}

- (void)setNumberLabel:(UILabel *)numberLabel{
    
    _numberLabel = numberLabel;
}

#pragma mark —————UITextViewDelegate—————
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (self.shouldBeginEditingBlock) {
        return self.shouldBeginEditingBlock(textView);
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (self.shouldEndEditingBlock) {
        return self.shouldEndEditingBlock(textView);
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (self.didBeginEditingBlock) {
        self.didBeginEditingBlock(textView);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (self.didEndEditingBlock) {
        self.didEndEditingBlock(textView);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (self.shouldChangeTextInRangeBlock) {
        return self.shouldChangeTextInRangeBlock(textView, range, text);
    }
    // 是否允许换行
    if (self.returnKeyType != UIReturnKeyDefault) {
        if ([text isEqualToString:@"\n"]) {
            
            [textView resignFirstResponder];
            return NO;
        }
    }
    
    //允许空字符串，不然删除健用不了
    if ([text isEqualToString:@""]){
        return YES;
    }
    
    if (!self.markedTextRange) {
        if (self.maxLength > 0 && text.length > self.maxLength) {
            return NO;
        }
    }
    
    return [self suitableInput:text];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (self.didChangeBlock) {
        self.didChangeBlock(textView);
    }
    
    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
    }
    
    if ([textView.text length] > self.maxLength && self.maxLength != 0 && textView.markedTextRange == nil) {
        textView.text = [textView.text substringToIndex:self.maxLength];
    }
    
    if (self.maxLength > 0) {
        NSInteger num = [textView.text length] > _maxLength ? _maxLength : [textView.text length];
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)num,(long)_maxLength];
        [self refreshFrame];
        if (self.contentSize.height > self.bounds.size.height - self.numberView.frame.size.height) {
            
            [self setContentOffset:CGPointMake(0, self.contentSize.height- self.bounds.size.height) animated:NO];
        }
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (self.didChangeSelectionBlock) {
        self.didChangeSelectionBlock(textView);
    }
}

/*
 -(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)){
 
 if (self.shouldInteractWithURLBlock) {
 return self.shouldInteractWithURLBlock(textView, URL, characterRange, interaction);
 }
 return YES;
 }
 -(BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)){
 
 if (self.shouldInteractWithTextAttachmentBlock) {
 return self.shouldInteractWithTextAttachmentBlock(textView, textAttachment, characterRange, interaction);
 }
 return YES;
 }
 */
#pragma mark - private
- (void)refreshFrame{
    
    [self.numberLabel sizeToFit];
    CGFloat numberViewHeight = self.numberLabel.frame.size.height + 10;
    CGFloat numberViewWidth = self.frame.size.width;
    CGRect rect = CGRectMake(0, 0, numberViewWidth, numberViewHeight);
    if (self.isFixed) {
        
        // 固定numberView位置
        rect.origin.y = self.frame.size.height + self.contentOffset.y - numberViewHeight;
        self.numberView.frame = rect;
        self.numberLabel.frame = CGRectMake(0, 5, numberViewWidth - 5, self.numberLabel.frame.size.height);
        self.textContainerInset = UIEdgeInsetsMake(self.placeholderLabel.frame.origin.y, 0, numberViewHeight, 0);
        
    }else{
        
        // numberView位置跟随文本内容滚动
        if (self.contentSize.height > self.frame.size.height - numberViewHeight) {
            
            rect.origin.y = self.contentSize.height - numberViewHeight;
            self.numberView.frame = rect;
            self.numberLabel.frame = CGRectMake(0, 5, self.frame.size.width-5, self.numberLabel.frame.size.height);
            self.textContainerInset = UIEdgeInsetsMake(self.placeholderLabel.frame.origin.y, 0, numberViewHeight, 0);
        }else{
            
            rect.origin.y = self.frame.size.height - numberViewHeight;
            self.numberView.frame = rect;
            self.numberLabel.frame = CGRectMake(0, 5, self.frame.size.width-5, self.numberLabel.frame.size.height);
        }
    }
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text.length>0) {
        [self.placeholderLabel setHidden:YES];
        if (self.maxLength > 0) {
            NSInteger num = [text length] > _maxLength ? _maxLength : [text length];
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)num,(long)_maxLength];
            [self.numberLabel sizeToFit];
            [self refreshFrame];
        }
    }
}


// 是否允许输入
-(BOOL)suitableInput:(NSString *)text{
    
    // 全字符
    if (self.limitType == LimitTypeNone) {
        return YES;
    }
    
    // 输入中文
    if ((self.limitType & LimitTypeCHZN) == LimitTypeCHZN) {
        if ([text isCHZN] || [text isSystem] || [text isPunctuation] || [text isEqualToString:@"\n"]) {
            return YES;
        }
    }
    
    // 输入中文英文数字
    if ((self.limitType & LimitTypeCHZNOrNumOrLetter) == LimitTypeCHZNOrNumOrLetter) {
        if ([text isNumber] || [text isCHZN] || [text isSystem] || [text isLetter] || [text isPunctuation]  || [text isEqualToString:@"\n"]) {
            return YES;
        }
    }
    return NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
