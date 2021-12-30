#import "SendMessageCallbackProxy.h"

@implementation NSDictionary (Extensions)

- (NSString *)json {
    NSString *json = nil;

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return (error ? nil : json);
}

@end

@interface RNSendMessageCallbackProxy()

@property (nonatomic, copy) RCTPromiseResolveBlock resolver;
@property (nonatomic, copy) RCTPromiseRejectBlock rejecter;
@property (nonatomic, copy) NSString* msg;
@property (nonatomic, weak) OpenIMSDKRN* module;

@end

@implementation RNSendMessageCallbackProxy

- (id)initWithMessage:(NSString *)msg module:(OpenIMSDKRN *)module resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)rejecter{
    if (self = [super init]) {
        self.msg = msg;
        self.module = module;
        self.resolver = resolver;
        self.rejecter = rejecter;
    }
    return self;
}

- (void)onError:(long)errCode errMsg:(NSString * _Nullable)errMsg {
    self.rejecter([NSString stringWithFormat:@"%ld",errCode],errMsg,nil);
}

- (void)onSuccess:(NSString * _Nullable)data {
    self.resolver(data);
}

- (void)onProgress:(long)progress {
    NSDictionary *data = @{
        @"progress":[NSString stringWithFormat:@"%ld",progress],
        @"message":self.msg
    };
    [self.module pushEvent:@"SendMessageProgress" errCode:@(0) errMsg:@"" data:[data json]];
}
@end
