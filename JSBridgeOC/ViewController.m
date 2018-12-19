//
//  ViewController.m
//  JSBridgeOC
//
//  Created by Su Yifeng on 2018/12/11.
//  Copyright © 2018年 SuYifeng. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSBridgeModel.h"
//
//@protocol JSObjDelegate <JSExport>
//
//- (void)login:(NSString *)userInfo;
//
//- (void)share:(NSString *)shareString;
//
//- (void)callCamera:(NSString *)callback;
//
//
//@end

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) JSContext *jsContext;

@property (nonatomic, copy) NSString *method;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    _webView.delegate = self;

    [self.view addSubview:_webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(100, self.view.bounds.size.height/2+50, 100, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clickAction{
//    [_webView stringByEvaluatingJavaScriptFromString:@"callShare()"];
    [self jsCallbackWithMethod:_method argument:@[@"image"]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    if ([url rangeOfString:@"xcs://"].location != NSNotFound) {
        NSLog(@"test");
        
        return false;
    }
    return true;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSBridgeModel *jbModel = [[JSBridgeModel alloc] init];
    
    self.jsContext[@"XCS"] = jbModel;
    jbModel.jsContext = self.jsContext;
    jbModel.webView = self.webView;
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"error：%@", exceptionValue);
    };
}

//// js传值给native
//-(void)login:(NSString *)userInfo{
//    
//    NSDictionary *user = [self jsonStringToDictionary:userInfo];
//    NSLog(@"userInfo:%@",user[@"userName"]);
//    [self jsCallbackWithMethod:user[@"callback"] argument:@[@"success"]];
//}
//- (void)share:(NSString *)shareString {
//    // 获得分享的内容
//    NSDictionary *jDict = [self jsonStringToDictionary:shareString];
//    NSLog(@"share: %@", jDict[@"title"]);
//    // 分享成功回调js的方法shareCallback
//    [self jsCallbackWithMethod:jDict[@"callback"] argument:@[@"success"]];
//}
//// native传值给js
//- (void)callCamera:(NSString *)callback {
//    // 这里写选择图片的代码
//    // 获取到照片之后在回调js的方法imageCallback把图片传出去
//    _method = callback;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"选择照片啦" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:cancle];
//        [alert addAction:sure];
//        [self presentViewController:alert animated:true completion:nil];
//    });
//    
//    
//}
// 回调
- (void)jsCallbackWithMethod:(NSString *)methodName argument:(NSArray *)arguments{
    JSValue *picCallback = self.jsContext[methodName];
    [picCallback callWithArguments:arguments];
}
// json转字典
- (NSDictionary *)jsonStringToDictionary:(NSString *)json{
    NSError *err;
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return jDict;
}

@end
