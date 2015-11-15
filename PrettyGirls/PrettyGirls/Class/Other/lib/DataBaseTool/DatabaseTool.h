//
//  DatabaseTool.h
//  Diancai1
//
//  Created by user on 14+3+11.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MainModel;

@interface DatabaseTool : NSObject
 
/**********************************************************************/

+(void)addPrettyGirlsWithArray:(NSArray *)array;

+(BOOL)addPrettyGirlsWithModel:(MainModel *)model;

/**
 *  取出所有的缓存数据
 *
 *  @return 装有MainModel的模型
 */
+(NSArray *)getPrettyGirls;

/**
 *  删除所有的缓存数据
 *
 *  @return YES：删除成功 ； NO：删除失败
 */
+(BOOL)delPrettyGirls;

/**
 *  根据url删除的数据
 *
 *  @param uniquenName MovieId+eposide
 *
 *  @return YES:成功；NO：失败
 */
+(BOOL)delPrettyGirlWithUrl:(NSString *)url;
/***********************************************************************/

@end
















