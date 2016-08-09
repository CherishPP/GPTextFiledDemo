//
//  ViewController.m
//  TextFiledDemo
//
//  Created by 高盼盼 on 16/8/9.
//  Copyright © 2016年 高盼盼. All rights reserved.
//

#import "ViewController.h"
#import "GPTextView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConst;
@property (weak, nonatomic) IBOutlet UIImageView *contentView;
@property (weak, nonatomic) IBOutlet GPTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;

@end

@implementation ViewController

-  (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //必须设置输入文字的字号，否则无法计算醉倒高度
    self.textView.font = [UIFont systemFontOfSize:14];
    // 设置文本框占位文字
    self.textView.placeholder = @"请输入";
    
    // 监听文本框文字高度改变
    _textView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        // 文本框文字高度改变会自动执行这个【block】，可以在这【修改底部View的高度】
        // 设置底部条的高度 = 文字高度 + textView距离上下间距约束
        // 为什么添加10 ？（10 = 底部View距离上（5）底部View距离下（5）间距总和）
        _textViewConst.constant = textHeight + 10;
    };
    
    // 设置文本框最大行数
    self.textView.maxNumberOfLines = 3;
}
// 键盘弹出会调用
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 获取键盘frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 修改底部视图距离底部的间距
    
    self.bottomConst.constant = self.bottomConst.constant == 0?endFrame.size.height:0;
    //让内容向上偏移
    self.topConst.constant = -(self.bottomConst.constant+endFrame.size.height);
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
        
        
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
