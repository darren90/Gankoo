//
//  NSString+NET.h
//  MovieBox
//
//  Created by Fengtf on 15/6/4.
//  Copyright (c) 2015年 rrmj. All rights reserved.
//

#import "AFNTool.h"
#import "AFNetworking.h"

@implementation AFNTool

+(void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 30;

    //2发送请求 说明服务器返回的时json  AFJSONResponseSerializer
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //3发送请求
    [mgr GET:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"请求成功");
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"请求失败:%@",error);
          if (failure) {
              failure(error);
          }
      }];
}


+(void)cancleAFNRequest
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

   [mgr.operationQueue cancelAllOperations];
}

+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    
    //2发送请求
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];

    //发送请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {//responseObject 字典
          NSLog(@"请求成功");
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"请求失败:%@",error);
          if (failure) {
              failure(error);
          }
      }];
 }

+(void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //1创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer.timeoutInterval = 30;
    
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {

        for (FormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {//responseObject 字典
        NSLog(@"请求成功");
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败:%@",error);
        if (failure) {
            failure(error);
        }
    }];
}

@end

/**
 *  ----------------------
 */
@implementation FormData

@end


