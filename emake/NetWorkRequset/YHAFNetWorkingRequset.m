//
//  YHAFNetWorkingRequset.m
//  emake
//
//  Created by 谷伟 on 2017/11/20.
//  Copyright © 2017年 emake. All rights reserved.
//

#import "YHAFNetWorkingRequset.h"
#import "FMDBManager.h"
@implementation YHAFNetWorkingRequset
static YHAFNetWorkingRequset *instance;
+(instancetype)sharedRequset{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return instance;
}
- (void)monitorNetworkStatus{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                self.networkStatu = NetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                self.networkStatu = NetworkStatusNotReachable;
                [[YHMQTTClient sharedClient] disConnect];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                self.networkStatu = NetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                self.networkStatu = NetworkStatusReachableViaWiFi;
                break;
        }
    }];
    [mgr startMonitoring];
}
- (BOOL)isNetworkAvailable{
    
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}
- (void)request:(YHRequestMethod)method
      urlString:(NSString *)urlString
     parameters:(id)parameters
       finished:(YHRequestCallBack)finished{
    
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 20.0;//设置请求超时时间
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [self.requestSerializer setValue:HTTP_Header_Patameter forHTTPHeaderField:@"User-Agent"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_Access_Token];
//    NSLog(@"token===%@",token);

    if (token) {
        [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    }
    /// 成功回调block
    YHRequestCallBack successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //转字符串
        NSData* encryptionData = responseObject;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:encryptionData options:NSJSONReadingAllowFragments error:nil];
        finished(response, nil);
    };
    /// 失败回调block
    YHRequestCallBack failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSError *errorAnthoer = [[NSError alloc] initWithDomain:error.domain code:responses.statusCode userInfo:error.userInfo];
        finished(nil, errorAnthoer);
    };
    switch (method) {
        case GET:
            [self GET:urlString parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;
        case POST:
            [self POST:urlString parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;
        case PUT:
            [self PUT:urlString parameters:parameters success:successBlock failure:failureBlock];
            break;
        case DELETE:
            [self DELETE:urlString parameters:parameters success:successBlock failure:failureBlock];
            break;
        default:
            break;
    }
}
#pragma mark ----银行卡扫描
- (void)requestScanAPIWithParameters:(id)parameters
                            finished:(YHRequestCallBack) finished{
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 20.0;//设置请求超时时间
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    NSString *timeS = [Tools getCurrentTimeInterval];
    long timeDistance = [timeS integerValue];
    timeDistance = timeDistance + 30*24*60*60;
    NSString *timeE = [NSString stringWithFormat:@"%ld",timeDistance];
    unsigned long random = arc4random() % 10000000000;
    NSString *orignal = [NSString stringWithFormat:@"u=%@&a=%@&k=%@&e=%@&t=%@&r=%lu&f=",ScanCardAPIAppQQ,ScanCardAPIAppAppID,ScanCardAPIAppSecretID,timeE,timeS,random];
    const char *keyData = ScanCardAPIAppSecretKey.UTF8String;
    const char *strData = orignal.UTF8String;
    unichar buffer[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    /* 把哈希编码后的数据根据官方要求，追加字符串并进行base64编码 */
    NSMutableData *binData = [[NSMutableData alloc] initWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
    [binData appendBytes:strData length:strlen(strData)];
    NSString *signStr = [binData base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    NSMutableString *sign = [NSMutableString stringWithString:signStr];
    //删除生成字符串中的换行符“\r\n”
    NSRange substr = [sign rangeOfString:@"\r\n"];
    while (substr.location != NSNotFound) {
        [sign deleteCharactersInRange:substr];
        substr = [sign rangeOfString:@"\r\n"];
    }
   [self.requestSerializer setValue:sign forHTTPHeaderField:@"Authorization"];
    /// 成功回调block
    YHRequestCallBack successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //转字符串
        NSData* encryptionData = responseObject;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:encryptionData options:NSJSONReadingAllowFragments error:nil];
        finished(response, nil);
    };
    /// 失败回调block
    YHRequestCallBack failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        finished(nil, error);
    };
    [self POST:URL_UserBankScanAPI parameters:parameters progress:nil success:successBlock failure:failureBlock];
}

#pragma mark ----上传图片到服务器

- (void)uploadImageToSevireURl:(NSString *)url param:(id)parameters progress:(YHRequestProgressCallBack)progressing finished:(YHRequestCallBack)finished
{
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 30.0;//设置请求超时时间
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_Access_Token];
    NSLog(@"token===%@",token);
    
    if (token) {
        [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
    }
    /// 成功回调block
    YHRequestCallBack successBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //转字符串
        NSData* encryptionData = responseObject;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:encryptionData options:NSJSONReadingAllowFragments error:nil];
        finished(response, nil);
    };
    /// 失败回调block
    YHRequestCallBack failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        
        NSLog(@"task.error==%@",task.error.description);
        finished(nil, error);
    };
    YHRequestProgressCallBack progress = ^(NSProgress * _Nonnull uploadProgress)
    {
        progressing(uploadProgress);

    };
    [self POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        NSArray *arr = (NSArray *)parameters;
        for(NSInteger i = 0; i < arr.count; i++){
                NSString *timeS = [Tools getCurrentTimeInterval];
                UIImage *image = arr[i];
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
            if (data.bytes) {
                if ([Tools fileSize:data.length] <0.3) {
                    NSLog(@"图片小");
                    data = UIImageJPEGRepresentation(image, 1.0);
                }else{
                    NSLog(@"图片大");
                    float pressValue = 0.3 / [Tools fileSize:data.length];
                    data = UIImageJPEGRepresentation(image, pressValue);
                }
            }
                NSString *fileName = [NSString stringWithFormat:@"%@%@", @"upload_image_Name", timeS];
                [formData appendPartWithFileData:data name:@"Image" fileName:[NSString stringWithFormat:@"%@.jpg", fileName] mimeType:@"image/jpg"];
        }
    } progress:progress success:successBlock failure:failureBlock];

}
#pragma mark --GET请求--
- (void)GET:(NSString *)urlString parameters:(id)parameters finished:(YHRequestCallBack)finished{
    [self request:GET urlString:urlString parameters:parameters finished:finished];
}

#pragma mark --POST请求
- (void)POST:(NSString *)urlString
  parameters:(id)parameters
    finished:(YHRequestCallBack)finished{
    [self request:POST urlString:urlString parameters:parameters finished:finished];
}
#pragma mark --PUT请求
- (void)PUT:(NSString *)urlString
 parameters:(id)parameters
   finished:(YHRequestCallBack)finished{
    [self request:PUT urlString:urlString parameters:parameters finished:finished];
}
#pragma mark --DELETE请求
- (void)DELETE:(NSString *)urlString
    parameters:(id)parameters
      finished:(YHRequestCallBack)finished{
    [self request:DELETE urlString:urlString parameters:parameters finished:finished];
}
#pragma mark --字典转Json
+ (NSString* )dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark --字符串转字典
+(NSDictionary* )parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

#pragma mark --字符串转数组
+(NSMutableArray* )parseJSONStringToNSArray:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray *responseJSON = [[NSMutableArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil]];
    return responseJSON;
}
#pragma mark - alloc方法底层会调用，更加安全
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}
- (id)copyWithZone:(nullable NSZone *)zone {
    return instance;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return instance;
}

@end
