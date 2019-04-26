//
//  BaseTextView.h
//  BaseTextView
//
//  Created by damai on 2019/4/25.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * TextField限制输入类型
 *
 */
typedef NS_ENUM(NSInteger, InputType){
    InputTypeNormal,                // 不做输入限制
    InputTypeCHZN,                  // 限制输入中文
    InputTypeCHZNOrNumberOrLetter   // 限制输入中文-字母-数字
};

@interface BaseTextView : UITextView

/**
 *textView输入类型
 *
 */
@property (nonatomic, assign) InputType inputType;

/**
 *textView允许输入的最大长度 默认不限制,（有值则显示numberLabel）
 *
 */
@property (nonatomic,assign) NSInteger maxLength;

/**
 *textView显示当前输入长度和总长度（设置值则显示否则不显示）
 *
 */
@property (nonatomic,strong) UILabel *numberLabel;

/**
 *numberLabel，是否固定（默认固定）
 *
 */
@property (nonatomic,assign) BOOL isFixed;

/**
 *textViewPlaceholderLabel（不设置则默认显示值）
 *
 */
@property (nonatomic,strong) UILabel *placeholderLabel;

/**
 *代理转Block
 *
 */
@property (nonatomic, copy) BOOL (^shouldBeginEditingBlock)(UITextView *textView);

@property (nonatomic, copy) BOOL (^shouldEndEditingBlock)(UITextView *textView);

@property (nonatomic, copy) void (^didBeginEditingBlock)(UITextView *textView);

@property (nonatomic, copy) void (^didEndEditingBlock)(UITextView *textView);

@property (nonatomic, copy) BOOL (^shouldChangeTextInRangeBlock)(UITextView *textView, NSRange range, NSString *replacementText);

@property (nonatomic, copy) void (^didChangeBlock)(UITextView *textView);

@property (nonatomic, copy) void (^didChangeSelectionBlock)(UITextView *textView);
/*
 @property (nonatomic, copy) BOOL (^shouldInteractWithURLBlock)(UITextView *textView, NSURL *url, NSRange range, UITextItemInteraction interaction);
 
 @property (nonatomic, copy) BOOL (^shouldInteractWithTextAttachmentBlock)(UITextView *textView, NSTextAttachment *textAttachment, NSRange range, UITextItemInteraction interaction);
 */


@end

NS_ASSUME_NONNULL_END
