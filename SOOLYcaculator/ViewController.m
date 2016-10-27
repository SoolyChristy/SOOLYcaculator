//
//  ViewController.m
//  SOOLYcaculator
//
//  Created by SOOLY on 16/5/30.
//  Copyright © 2016年 SOOLY. All rights reserved.
//

#import "ViewController.h"
#import "myButton.h"

@interface ViewController ()

@property (nonatomic,assign) double num1,num2,num3;
@property (nonatomic,strong) NSMutableArray *nums;           //存储操作数的可变数组
@property (nonatomic,retain) NSMutableArray *operator;       //存储操作符的可变数组
@property (nonatomic,retain) NSMutableString *allstr;
@property (nonatomic,retain) NSMutableString *string;
@property (nonatomic,retain) UITextView *display;

@property bool FinishCaculation;

@end

@implementation ViewController

//-(NSMutableArray *)nums{
//    if (_nums == nil) {
//        _nums = [NSMutableArray array];
//    }
//    return _nums;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //初始化
    [self initProperty];
    //生成界面
    [self CreateUI];
    
}

-(void)CreateUI{
    //创建textfield
    CGFloat btnW = self.view.frame.size.width /4;
    CGFloat numY = self.view.frame.size.height - btnW * 4;
    CGFloat caY = self.view.frame.size.height - btnW * 5;
    CGFloat lastY = self.view.frame.size.height - btnW;
    self.display = [[UITextView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, caY)];
    self.display.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    self.display.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.9];
    self.display.tintColor = [UIColor colorWithRed:91/255.0 green:169/255.0 blue:255/255.0 alpha:1];
    self.display.font = [UIFont systemFontOfSize:38];
    self.display.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.display];

    //创建数字button
    NSArray *array=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    int n = 0;
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            myButton *button = [myButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(btnW * j, btnW * i + numY, btnW, btnW);
            [button setTitle:[array objectAtIndex:n++] forState:UIControlStateNormal];
            [self.view addSubview:button];
            [button addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setNumButtonUI];
        }
    }
    myButton *button2 = [myButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(0, lastY, btnW, btnW);
    [button2 setTitle:@"0" forState:UIControlStateNormal];
    [button2 setNumButtonUI];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加运算符
    NSArray *array1=[NSArray arrayWithObjects:@"+",@"-",@"*",@"/",nil];
    for (int i=0; i<4; i++)
    {
        myButton *button1 = [myButton buttonWithType:UIButtonTypeRoundedRect];
        [button1 setFrame:CGRectMake(btnW * 3, btnW * i + caY, btnW, btnW)];
        [button1 setTitle:[array1 objectAtIndex:i] forState:UIControlStateNormal];
        [button1 setOtherButtonUI];
        [self.view addSubview:button1];
        [button1 addTarget:self action:@selector(operatorClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //添加 =
    myButton *button3 = [myButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setFrame:CGRectMake(btnW*3,lastY,btnW,btnW)];
    [button3 setTitle:@"=" forState:UIControlStateNormal];
    [button3 setOtherButtonUI];
    [button3 addTarget:self action:@selector(caculationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    //创建AC
    myButton *btn = [myButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, caY,btnW,btnW)];
    [btn setTitle:@"清除" forState:UIControlStateNormal];
    [btn setOtherButtonUI];
    btn.titleLabel.font = [UIFont systemFontOfSize:26];
    [btn addTarget:self action:@selector(acClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //添加.
    myButton *btn2 = [myButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setFrame:CGRectMake(btnW, lastY, btnW, btnW)];
    [btn2 setTitle:@"." forState:UIControlStateNormal];
    [btn2 setOtherButtonUI];
    [btn2 addTarget:self action:@selector(dotClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    // 负号
    myButton *btn4 = [myButton buttonWithType:UIButtonTypeRoundedRect];
    [btn4 setFrame:CGRectMake(btnW*2, lastY, btnW, btnW)];
    [btn4 setTitle:@"+/-" forState:UIControlStateNormal];
    [btn4 setOtherButtonUI];
    [self.view addSubview:btn4];
    //退格
    myButton *btn3 = [myButton buttonWithType:UIButtonTypeRoundedRect];
    [btn3 setFrame:CGRectMake(btnW,caY,btnW*2,btnW)];
    [btn3 setTitle:@"<——" forState:UIControlStateNormal];
    [btn3 setOtherButtonUI];
    [btn3 addTarget:self action:@selector(backSpaceClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}

-(void)initProperty{
    self.FinishCaculation = NO;
    self.num1 = 0;
    self.num3 = 0;
    self.nums = [NSMutableArray array];
    self.operator = [NSMutableArray array];
    self.allstr = [NSMutableString string];
    self.string = [NSMutableString string];
}

-(void)backSpaceClick{
    if ([self.allstr isEqualToString:@""] || self.FinishCaculation == YES) {
        return;
    }
    if ([self.allstr hasSuffix:@"+"] || [self.allstr hasSuffix:@"-"] || [self.allstr hasSuffix:@"*"] || [self.allstr hasSuffix:@"/"] ) {  //如果allstr以操作符结尾
        [self.operator removeLastObject];
        [self.nums removeLastObject];
        [self.allstr deleteCharactersInRange:NSMakeRange(self.allstr.length - 1, 1)]; //删除最后一个字符
        self.display.text = [NSString stringWithString:self.allstr];
    }else if ([self.allstr hasSuffix:@"."]){ //如果allstr以.结尾
        if ([self.string isEqualToString:@"0."]) {
            [self.string setString:@""];
            [self.allstr setString:@""];
            self.display.text = [NSString stringWithString:self.allstr];
        }else{
            [self.string deleteCharactersInRange:NSMakeRange(self.string.length - 1, 1)];
            [self.allstr deleteCharactersInRange:NSMakeRange(self.allstr.length - 1, 1)];
             self.display.text = [NSString stringWithString:self.allstr];
        }
    }else{  //如果allstr以数字结尾
        [self.nums removeLastObject];
        [self.allstr deleteCharactersInRange:NSMakeRange(self.allstr.length - 1, 1)]; //删除最后一个字符
        self.display.text = [NSString stringWithString:self.allstr];
    }
}

-(void)acClick:(id)sender{
    [self.allstr setString:@""];
    [self.string setString:@""];
    self.num3 = 0;
    self.display.text = self.allstr;
    [self.nums removeAllObjects];
    [self.operator removeAllObjects];
}

-(void)numClick:(id)sender{
    if (self.FinishCaculation == YES) {               //若已经计算完成
        [self.nums removeAllObjects];
        [self.operator removeAllObjects];
        [self.allstr setString:@""];
        self.display.text = [NSString stringWithString:self.allstr];
    }
    [self.string appendString:[sender currentTitle]];
    [self.allstr appendString:[sender currentTitle]];
    self.display.text = [NSString stringWithString:self.allstr];                 //显示数字
    NSLog(@"string = %@",self.string);
    self.FinishCaculation = NO;
}

-(void)dotClick{
    NSString *tmpstr = [NSString stringWithFormat:@"%g",self.num3];
    if ([tmpstr rangeOfString:@"."].length > 0) {        //若结果中已经存在小数点则重新计算
        return;
    }
    if ([self.string rangeOfString:@"."].length > 0) {   //若string中已经存在小数点则返回
        return;
    }
    if ([self.string isEqualToString:@""]) {
        [self.string setString:@"0."];
        [self.allstr appendString:@"0."];
        self.display.text = [NSString stringWithString:self.allstr];
        self.FinishCaculation = NO;
    }else{
        [self.string appendString:@"."];
        [self.allstr appendString:@"."];
        self.display.text = [NSString stringWithString:self.allstr];
        self.FinishCaculation = NO;
    }
}

-(void)operatorClick:(id)sender{
    if (self.FinishCaculation == YES) {               //若已经完成计算
        [self.nums removeAllObjects];
        [self.operator removeAllObjects];
        NSString *tmpstr = [NSString stringWithFormat:@"%g",self.num3];
        [self.string setString:tmpstr];
        [self.allstr setString:tmpstr];
        self.display.text = [NSString stringWithString:self.allstr];
        self.FinishCaculation = NO;
    }
    self.num3 = 0;
    NSString *tmpstr = [NSString stringWithString:self.string];
    [self.nums addObject:tmpstr];
    NSLog(@"%@",[self.nums objectAtIndex:0]);
    [self.allstr appendString:[sender currentTitle]];
    self.display.text = [NSString stringWithString:self.allstr];                //显示符号
    [self.operator addObject:[sender currentTitle]];  //保存符号
    [self.string setString:@""];                    // 清空string
    self.FinishCaculation = NO;
}

-(void)caculationClick:(id)sender{
    if (self.FinishCaculation == YES || [self.allstr isEqualToString:@""]) {
        return;
    }
    NSString *tmpstr = [NSString stringWithString:self.string];
    [self.nums addObject:tmpstr];
    NSLog(@"%@",self.nums);
    if (self.nums.count == 1) {                  //若操作数只有一个
        self.num3 = [[self.nums objectAtIndex:0]doubleValue];
        [self.allstr setString:[NSString stringWithFormat:@"%g",self.num3]];
        self.display.text = [NSString stringWithString:self.allstr];
        self.FinishCaculation = YES;
        return;
    }
    NSLog(@"%@",self.operator);
    [self.operator addObject:@"#"];
    while (![[self.operator objectAtIndex:0]isEqualToString:@"#"]) {  //当运算符只剩#号时终止
        switch ([self precede:[self.operator objectAtIndex:0] TwoOperator:[self.operator objectAtIndex:1]]) {
            case 0:{   //第一个符号优先级 小于 第二个符号的优先级
                self.num1 = [[self.nums objectAtIndex:1] doubleValue];
                self.num2 = [[self.nums objectAtIndex:2] doubleValue];
                self.num3 = [self CaculationWith:self.num1 TwoNumbers:self.num2 AtOperatorIndex:1];
                [self.nums removeObjectAtIndex:1];
                [self.nums removeObjectAtIndex:1];
                [self.operator removeObjectAtIndex:1];     //第二第三号位置数值出栈、第二个符号出栈。
                NSString *tmpstr2 = [NSString stringWithFormat:@"%f",self.num3];
                [self.nums insertObject:tmpstr2 atIndex:1]; //将计算结果插入 第二号位置中.
                NSLog(@"jieguo1 = %f",self.num3);
                break;
            }
            case 1:{   //第一个符号的优先级 大于 第二个符号的优先级
                self.num1 = [[self.nums objectAtIndex:0] doubleValue];
                self.num2 = [[self.nums objectAtIndex:1] doubleValue];
                self.num3 = [self CaculationWith:self.num1 TwoNumbers:self.num2 AtOperatorIndex:0];
                [self.nums removeObjectAtIndex:0];
                [self.nums removeObjectAtIndex:0];
                [self.operator removeObjectAtIndex:0];    //第一第二号位置数值出栈、第一个符号出栈。
                NSString *tmpstr3 = [NSString stringWithFormat:@"%f",self.num3];
                [self.nums insertObject:tmpstr3 atIndex:0];  //将计算结果插入第一号位置中
                NSLog(@"jieguo2 = %f",self.num3);
                break;
            }
            case 2:{
                self.num1 = [[self.nums objectAtIndex:0] doubleValue];
                self.num2 = [[self.nums objectAtIndex:1] doubleValue];
                self.num3 = [self CaculationWith:self.num1 TwoNumbers:self.num2 AtOperatorIndex:0];
                [self.nums removeObjectAtIndex:0];
                [self.nums removeObjectAtIndex:0];
                [self.operator removeObjectAtIndex:0];
                NSString *tmpstr3 = [NSString stringWithFormat:@"%f",self.num3];
                [self.nums insertObject:tmpstr3 atIndex:0];
                NSLog(@"jieguo3 = %f",self.num3);
                break;
            }
            case 3:{  //最后一个运算
                self.num1 = [[self.nums objectAtIndex:0] doubleValue];
                self.num2 = [[self.nums objectAtIndex:1] doubleValue];
                self.num3 = [self CaculationWith:self.num1 TwoNumbers:self.num2 AtOperatorIndex:0];
                [self.operator removeObjectAtIndex:0];  //删除最后一个符号
            }
            default:
            break;
        }
    }
    NSLog(@"num3 = %f",self.num3);
    [self.allstr appendString:[NSString stringWithFormat:@" = %g",self.num3]];
    self.display.text = self.allstr;
    [self.operator removeObjectAtIndex:0]; //计算完成后删除#
    [self.string setString:@""];
    self.FinishCaculation = YES;
}

-(NSInteger)precede:(NSString *)op1 TwoOperator:(NSString *)op2{      //对比两个符号的优先级
    if (([op1 isEqualToString:@"+"] || [op1 isEqualToString:@"-"])&&([op2 isEqualToString:@"*"] || [op2 isEqualToString:@"/"])) {
        return 0; //小于
    }else if (([op1 isEqualToString:@"*"] || [op1 isEqualToString:@"/"])&&([op2 isEqualToString:@"+"] || [op2 isEqualToString:@"-"])){
        return 1; //大于
    }
    else if(([op1 isEqualToString:@"+"] || [op1 isEqualToString:@"-"])&&([op2 isEqualToString:@"+"] || [op2 isEqualToString:@"-"])){
        return 2; //等于
    }
    else
        return 3;  //当只剩最后一个符号时
}

-(double)CaculationWith:(double)number1 TwoNumbers:(double)number2 AtOperatorIndex:(NSInteger)index{
    if ([[self.operator objectAtIndex:index]isEqualToString:@"+"]) {
        return number1 + number2;
    }else if([[self.operator objectAtIndex:index]isEqualToString:@"-"])
    {
        return number1 - number2;
    }else if([[self.operator objectAtIndex:index]isEqualToString:@"*"])
    {
        return number1 * number2;
    }else
        return number1 / number2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
