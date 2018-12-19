//
//  JSBridgeModel.m
//  JSBridgeOC
//
//  Created by Su Yifeng on 2018/12/19.
//  Copyright © 2018年 SuYifeng. All rights reserved.
//

#import "JSBridgeModel.h"

@implementation JSBridgeModel

- (void)gotoLogin:(NSString *)userInfo callback:(NSString *)name{
    // 。。。 处理相应的事件，然后回调
    [self jsCallbackWithMethod:name argument:@[@"hello"]];
}

- (void)callCamera:(NSString *)callback{
    // 。。。 处理相应的事件，然后回调
    [self jsCallbackWithMethod:callback argument:@[@"image"]];
}

- (void)showAlert:(NSString *)title callback:(NSString *)name{
    // 。。。 处理相应的事件，然后回调
    [self jsCallbackWithMethod:name argument:@[]];
}

// 回调
- (void)jsCallbackWithMethod:(NSString *)methodName argument:(NSArray *)arguments{
    JSValue *callback = self.jsContext[methodName];
    [callback callWithArguments:arguments];
}
// json转字典
- (NSDictionary *)jsonStringToDictionary:(NSString *)json{
    NSError *err;
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return jDict;
}
@end
