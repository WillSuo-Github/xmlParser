//
//  ViewController.m
//  xmlParser
//
//  Created by ws on 16/1/25.
//  Copyright © 2016年 ws. All rights reserved.
//

#import "ViewController.h"
#import "TFHpple.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadHTMLWithWord:nil];
}

- (void)loadHTMLWithWord:(NSString *)word {
    //1.发送HTML请求, 得到返回的网页.(转换为字符串)
    NSString *urlString = [NSString stringWithFormat:@"http://news.baidu.com"];  //拼接请求网址
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //中文转义
    NSURL *url = [NSURL URLWithString:urlString];  //得到URL
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //得到的data数据转换为字符串
//        NSLog(@"%@",data);
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *html = [[NSString alloc] initWithData:data encoding:enc];
//              NSLog(@"%@", html);
        
        //2.从返回的字符串中匹配出(正则表达式过滤)想要的. (另写一个方法findAnswerInHTML)
        //然后通过代理传递结果给主线程,用于更新UI
        
        NSArray *arr = [self findAnswerInHTML:html];

        NSLog(@"%@",arr);
    }];  
}


- (NSMutableArray *)findAnswerInHTML:(NSString *)html {
    
    
//    NSLog(@"%@",html);
    //将需要取出的用(.*?)代替. 大空格换行等用.*?代替,表示忽略.
    NSString *pattern = @"mon=\"ct=[0-9]{0,10}&amp;a=[0-9]{0,10}&amp;c=top&pn=[0-9]{0,10}\" target=\"_blank\">(.*?)</a></li>";
    
    //实例化正则表达式，需要指定两个选项
    //NSRegularExpressionCaseInsensitive  忽略大小写
    //NSRegularExpressionDotMatchesLineSeparators 让.能够匹配换行
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    
    //匹配出结果集
    NSArray *checkResultArr = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    // 取出找到的内容. 数字分别对应第几个带括号(.*?), 取0时输出匹配到的整句.
//        NSLog(@"%@\n", [pattern substringWithRange:checkResult.range]);
        
//        NSString *result = [html substringWithRange:[checkResult rangeAtIndex:0]];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSTextCheckingResult *checkResult in checkResultArr) {
        
        NSString *result = [html substringWithRange:[checkResult rangeAtIndex:1]];
        
//        NSRange range = NSMakeRange(50, result.length - 50);
//        result = [result substringWithRange:range];
//        result = [result substringToIndex:result.length - 9];
        
        NSLog(@"%@",result);
        
        [arr addObject:result];

        
    }
//    NSLog(@"数据为----->%@", result);
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
