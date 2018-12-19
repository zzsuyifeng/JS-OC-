//
//  JSBridgeModel.h
//  JSBridgeOC
//
//  Created by Su Yifeng on 2018/12/19.
//  Copyright © 2018年 SuYifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
// JSExport是一个协议
@protocol JSObjDelegate <JSExport>
// 登录
- (void)gotoLogin:(NSString *)userInfo callback:(NSString *)name;
// 调相册
- (void)callCamera:(NSString *)callback;
// 弹框
- (void)showAlert:(NSString *)title callback:(NSString *)name;

@end
NS_ASSUME_NONNULL_BEGIN

@interface JSBridgeModel : NSObject<JSObjDelegate>
// JS执行上下文
@property (nonatomic, weak) JSContext *jsContext;

@property (nonatomic, weak) UIWebView *webView;

@end

NS_ASSUME_NONNULL_END
