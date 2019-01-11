//
//  FoldTextView.m
//  AoJiLiuXue
//
//  Created by Jerry on 2018/11/29.
//  Copyright © 2018年 AoJiLiuXue. All rights reserved.
//

#import "FoldTextView.h"
#import "AJToolsManager.h"
#import "Masonry.h"
#define defalutTextViewHeight 18.f

@implementation FoldTextView
{
    NSInteger _textHeight;
    CGFloat _defaultSuperHeight;
    CGFloat _defalutTextViewTop;
    UITapGestureRecognizer *_tap;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initlizesParam];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - 代码区
#pragma mark 初始化UI
- (void)initView {
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview: self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
    }];
    
    [self addSubview: self.accessaryView];
    [_accessaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-12);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    [self addSubview: self.placeholderLabel];
    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-36);
    }];
    
    [self addSubview: self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(7);
        make.right.mas_equalTo(self.mas_right).offset(-36);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(defalutTextViewHeight);
    }];
 
    CGFloat scale = [UIScreen mainScreen].scale;
    [self addSubview: self.lineLayer];
    [_lineLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1 / scale);
    }];
    
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:_tap];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self.textView];
}

#pragma mark - 初始化参数
- (void)initlizesParam {
    _lineStyle = longLine;
    _maxCount = 30;
    _alignmentStyle = left;
    _state = edite;
    _canInput = YES;
    self.showAccessary = NO;
}

#pragma mark - 父视图添加后改变约束
- (void)layoutSubviews {
    [super layoutSubviews];
    //只有第一次存值
    if (_defaultSuperHeight > 0) return ;
    _defaultSuperHeight = CGRectGetHeight(self.bounds);
    CGFloat top = (_defaultSuperHeight - defalutTextViewHeight)/2.0;
    _defalutTextViewTop = top;
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
    }];
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
    }];
}

- (void)updateSelectFoldView: (NSString *)text color: (UIColor *)color {
    if (_state != select) return;
    if (!text.length) return;
    self.placeholder = text;
    self.placeholderLabel.textColor = color;
}

#pragma mark - 更新线约束
- (void)updateLineConstraints {
    
    CGFloat left = 0.0f;
    CGFloat right = 0.0f;
    switch (_lineStyle) {
        case shortLine:
        {
            left = 12.f;
            right = 12.f;
        }
            break;
        case leftLine:
            left = 12.f;
            break;
        default: break;
    }
    [_lineLayer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.right.mas_equalTo(left);
    }];
}

#pragma mark - 更新选择或者编辑状态
- (void)updateState {
    if (_state == select) {
        _textView.hidden = YES;
        _accessaryView.userInteractionEnabled = NO;
    } else {
        _textView.hidden = NO;
        _accessaryView.userInteractionEnabled = YES;
    }
}

#pragma mark - 更新文字显示样式
- (void)updateAlignmentStyle {
    if (_alignmentStyle == left) {
        _textView.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        _textView.textAlignment = NSTextAlignmentRight;
        _placeholderLabel.textAlignment = NSTextAlignmentRight;
    }
}

#pragma mark - 更新右边角标
- (void)updateAccessaryView {
    if (_showAccessary) {
        _accessaryView.hidden = NO;
    } else {
        _accessaryView.hidden = YES;
    }
    [self accessaryViewShow:_showAccessary];
 }

- (void)accessaryViewShow: (BOOL)show {
    CGFloat right = 0.f;
    if (show) {
        right = -36.f;
    } else {
        right = -12.f;
    }
    if (_state == edite) {
        [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(right);
        }];
    } else {
        [_placeholderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(right);
        }];
    }
}
- (void)updateInputState {
    if (_canInput) {
        _tap.enabled = YES;
        if (_state == edite) {
            _textView.userInteractionEnabled = YES;
            _accessaryView.userInteractionEnabled = YES;
        }
    } else {
        _tap.enabled = NO;
        if (_state == edite) {
            _textView.userInteractionEnabled = NO;
            _accessaryView.userInteractionEnabled = NO;
        }
    }
}

#pragma mark - 按钮点击
/// 点击accessaryView
- (void)clickAccessary {
    if (_state == select) return;
    self.text = @"";
    [self textDidChange];
}

/// tapa事件
- (void)tapView: (UITapGestureRecognizer *)sender {
    if  (_state == edite) {
        [_textView becomeFirstResponder];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(foldViewDidSelected:)]) {
            [self.delegate foldViewDidSelected:self];
        }
    }
}

#pragma mark - set
- (void)setTitle:(NSString *)title {
    if (_title == title) return;
    _title = title;
    _titleLabel.text = title;
}

- (void)setText:(NSString *)text {
    if (_text == text) return;
    _text = text;
    if (text.length) {
        _placeholderLabel.hidden = true;
    }
    _textView.text = text;
    [self textDidChange];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (_placeholder  == placeholder) return;
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}

- (void)setLineStyle:(lineCrackStyle)lineStyle {
    if (_lineStyle == lineStyle) return;
    _lineStyle = lineStyle;
    [self updateLineConstraints];
}

- (void)setState:(editeState)state {
    if (_state == state) return;
    _state = state;
    [self updateState];
}

- (void)setAlignmentStyle:(textAlignmentStyle)alignmentStyle {
    if (_alignmentStyle == alignmentStyle) return;
    _alignmentStyle = alignmentStyle;
    [self updateAlignmentStyle];
}

- (void)setAccessaryImage:(UIImage *)accessaryImage {
    _accessaryImage = accessaryImage;
    [_accessaryView setImage:accessaryImage forState:UIControlStateNormal];
}

- (void)setShowAccessary:(BOOL)showAccessary {
    if (_showAccessary == showAccessary) return;
    _showAccessary = showAccessary;
    [self updateAccessaryView];
}

- (void)setCanInput:(BOOL)canInput {
    if (_canInput == canInput) return;
    _canInput = canInput;
    [self updateInputState];
}

#pragma mark - 文字改变后更新高度
- (void)textDidChange
{
    NSInteger height = ceilf([self.textView sizeThatFits:CGSizeMake(_textView.bounds.size.width, MAXFLOAT)].height);
    if (_textView.text.length) {
        _placeholderLabel.hidden = YES;
    } else {
        _placeholderLabel.hidden = NO;
    }
    if (_textHeight != height) {
        _textHeight = height;
        [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self->_textHeight);
        }];
        if (self.delegate && [ self.delegate respondsToSelector:@selector(foldView: updateHeight:)]) {
            CGFloat superHeight = _defalutTextViewTop * 2 + height;
            [self.delegate foldView:self updateHeight:superHeight];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - textField代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.showAccessary = YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    self.showAccessary = NO;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    NSString *s = nsTextContent;
    
    if (existTextNum > _maxCount)
    {
        //截取到最大位置的字符
        s = [nsTextContent substringToIndex:_maxCount];
        [textView setText:s];
        if (self.delegate && [self.delegate respondsToSelector:@selector(foldViewInterruptInput:maxCount:)]) {
            [self.delegate foldViewInterruptInput:self maxCount:_maxCount];
        }
    }
    _text = s;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //换行处理
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < _maxCount) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    _text = textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(foldView:didEndText:)]) {
        [self.delegate foldView:self didEndText:_text];
    }
}

#pragma mark - get
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = [AJTools HexStringToColor:@"#333333" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UITextView *)textView {
    if (!_textView) {
        (void)(_textView = [UITextView new]),
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textColor = [AJTools HexStringToColor:@"#333333" alpha:1];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _textView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = [AJTools HexStringToColor:@"#CCCCCC" alpha:1];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _placeholderLabel;
}

-(UIButton *)accessaryView {
    if (!_accessaryView) {
        _accessaryView = [UIButton new];
        _accessaryView.hidden = YES;
        _accessaryView.clipsToBounds = YES;
        _accessaryView.userInteractionEnabled = YES;
        _accessaryView.backgroundColor = [UIColor clearColor];
        _accessaryView.contentMode = UIViewContentModeScaleAspectFill;
        [_accessaryView addTarget:self action:@selector(clickAccessary) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accessaryView;
}

- (UIView *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [UIView new];
        _lineLayer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineLayer;
}

@end
