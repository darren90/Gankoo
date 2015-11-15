//
//  NSString+NET.h
//  MovieBox
//
//  Created by Fengtf on 15/6/4.
//  Copyright (c) 2015年 rrmj. All rights reserved.
//


/**
 *  封装get，post请求
 */

#import <Foundation/Foundation.h>

@interface AFNTool : NSObject

//取消网络请求
+(void)cancleAFNRequest;

+(void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void  (^)(id json))success failure:(void  (^)(NSError *error))failure;

 
+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void  (^)(id json))success failure:(void  (^)(NSError *error))failure;

/**
 *  上传文件数据
 */
+(void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void  (^)(id json))success failure:(void  (^)(NSError *error))failure;

@end

/**
 *  用来封装文件数据的模型
 */
@interface FormData : NSObject


@property (nonatomic,strong)NSData * data;



@property (nonatomic,copy)NSString * name;


@property (nonatomic,copy)NSString * filename;



@property (nonatomic,copy)NSString * mimeType;


@end
