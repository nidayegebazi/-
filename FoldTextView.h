//
//  FoldTextView.h
//  AoJiLiuXue
//
//  Created by Jerry on 2018/11/29.
//  Copyright © 2018年 AoJiLiuXue. All rights reserved.
//  自动折行TextView

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FoldTextView;

@protocol FoldTextViewDelegate <NSObject>

@optional
/**
 到达最大输入

 @param foldView foldView
 @param count 最大数量
 */
- (void)foldViewInterruptInput: (FoldTextView *)foldView maxCount: (NSInteger)count;

/**
 更新父视图

 @param foldView foldView
 @param height 更新父视图回调
 */
- (void)foldView: (FoldTextView *)foldView updateHeight:(CGFloat)height;

/**
 editeState -> select时调用生效，其他状态textview变为第一响应没有回调

 @param foldView foldView
 */

- (void)foldViewDidSelected: (FoldTextView *)foldView;

/**
 结束编辑的文本

 @param foldView foldView
 @param text 编辑完成的文本text
 */
- (void)foldView: (FoldTextView *)foldView didEndText: (NSString *)text;

@end

typedef NS_ENUM(NSUInteger, lineCrackStyle) {
    longLine = 0, ///左右为零
    shortLine, ///左右12
    leftLine ///左12右零
};
typedef NS_ENUM(NSUInteger, textAlignmentStyle) {
    left = 0, ///局左
    right, ///居右
    center ///居中
};
typedef NS_ENUM(NSUInteger, editeState) {
    edite = 0, ///编辑
    select, ///选择
};

@interface FoldTextView : UIView<UITextViewDelegate>

/**
  底部线的风 默认：long
 */
@property (nonatomic, assign) lineCrackStyle lineStyle;

/**
 显示文本的对齐的方式 默认：left
 */
@property (nonatomic, assign) textAlignmentStyle alignmentStyle;

/**
 是编辑还是选择 默认：edite
 */
@property (nonatomic, assign) editeState state;

/**
 是否展示箭头，state -> edite默认no，state -> select默认yes
 */
@property (nonatomic) BOOL showAccessary;

/**
 最大的输入数量 默认：30
 */
@property (nonatomic, assign) NSInteger maxCount;

/**
 文本内容
 */
@property (nonatomic, copy) NSString *text;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 默认文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 角标图片
 */
@property (nonatomic, copy) UIImage *accessaryImage;

/**
 是否可以输入默认: yes
 */
@property (nonatomic) BOOL canInput;

/**
 FoldTextView代理
 */
@property (nonatomic, weak) id <FoldTextViewDelegate> delegate;

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 默认文字
 */
@property (nonatomic, strong) UILabel *placeholderLabel;

/**
 输入框
 */
@property (nonatomic, strong) UITextView *textView;

/**
 角标
 */
@property (nonatomic, strong) UIButton *accessaryView;

/**
 底部线
 */
@property (nonatomic, strong) UIView *lineLayer;

/**
 更新内容state -> select时该方法有效

 @param text 文本
 @param color 颜色
 */
- (void)updateSelectFoldView: (NSString *)text color: (UIColor *)color;

@end

NS_ASSUME_NONNULL_END
