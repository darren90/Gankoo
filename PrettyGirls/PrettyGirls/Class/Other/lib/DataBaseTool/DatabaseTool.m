//
//  DatabaseTool.m
//  Diancai1
//
//  Created by user on 14-3-11.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import "DatabaseTool.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "MainModel.h"


static FMDatabase *_db;
//order by id desc:降序 asc：升序
@implementation DatabaseTool

+ (void)initialize
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) firstObject];
    NSString* sqlPath = [NSString stringWithFormat:@"%@/PrettyGirls.sqlite",cachesPath];
    NSLog(@"--sqlPath:%@",sqlPath);
    _db = [[FMDatabase alloc] initWithPath:sqlPath];
    
    if (![_db open]) {
        [_db close];
        NSLog(@"打开数据库失败");
    }
    
    [_db setShouldCacheStatements:YES];
 
    //1：新下载  fileName 主键
    if (![_db tableExists:@"PrettyGirls"]) {
        [_db executeUpdate:@"CREATE TABLE if not exists PrettyGirls (id integer primary key autoincrement,who TEXT,desc TEXT,type TEXT,url TEXT,publishedAt TEXT)"];
    }
      
    [_db close];
}
/**********************************************************************/

+(void)addPrettyGirlsWithArray:(NSArray *)array
{
    if(array.count == 0)return;
    for (MainModel *model in array) {
        [self addPrettyGirlsWithModel:model];
    }
}

+(BOOL)addPrettyGirlsWithModel:(MainModel *)model
{
    if (model == nil || model.url == nil || model.url.length == 0) {
        NSLog(@"加入下载列表失败-ID为空");
        return NO;
    }
    
    if (![_db open]) {
        [_db close];
        NSAssert(NO, @"数据库打开失败");
        return NO;
    }
    [_db setShouldCacheStatements:YES];
    
    //1:判断是否已经加入到数据库中 who TEXT,desc TEXT,type TEXT,url TEXT,publishedAt TEXT
    int count = [_db intForQuery:@"SELECT COUNT(url) FROM PrettyGirls where fileName = ?;",model.url];
    
    if (count >= 1) {
        NSLog(@"-已经在下载列表中--");
        return NO;
    }
    //2:存储
//    fileName title TEXT,fileURL TEXT,iconUrl TEXT,filesize TEXT,filerecievesize TEXT,isHadDown integer,urlType integer
    BOOL result = [_db executeUpdate:@"insert into PrettyGirls (who,desc,type,url,publishedAt) values (?,?,?,?,?);",model.who,model.desc,model.type,model.url,model.publishedAt];
    
    [_db close];
    if (result) {

    }else{
        NSLog(@"加入下载列表失败");
    }
    return result;
}

/**
 *  取出所有的缓存数据
 *
 *  @return 装有MainModel的模型
 */
+(NSArray *)getPrettyGirls
{
    if (![_db open]) {
        [_db close];
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    [_db setShouldCacheStatements:YES];
     
    FMResultSet *rs = [_db executeQuery:@"SELECT * FROM PrettyGirls order by id asc;"];
    NSMutableArray * array = [NSMutableArray array];
    while (rs.next) {
        MainModel *model = [[MainModel alloc]init];
        model.who = [rs stringForColumn:@"who"];
        model.desc = [rs stringForColumn:@"desc"];
        model.type = [rs stringForColumn:@"type"];
        model.url = [rs stringForColumn:@"url"];
        model.publishedAt = [rs stringForColumn:@"publishedAt"];
        [array addObject:model];
    }
    [rs close];
    [_db close];
    return array;
}
/**
 *  删除所有的缓存数据
 *
 *  @return YES：删除成功 ； NO：删除失败
 */
+(BOOL)delPrettyGirls
{
    if (![_db open]) {
        [_db close];
        NSLog(@"数据库打开失败！");
        return NO;
    }
    [_db setShouldCacheStatements:YES];
    BOOL result = [_db executeUpdate:@"DELETE FROM PrettyGirls"];
    [_db close];
    return result;
}

/**
 *  根据url删除的数据
 *
 *  @param uniquenName MovieId+eposide
 *
 *  @return YES:成功；NO：失败
 */
+(BOOL)delPrettyGirlWithUrl:(NSString *)url
{
    if (![_db open]) {
        [_db close];
        NSLog(@"数据库打开失败！");
        return NO;
    }
    [_db setShouldCacheStatements:YES];
    BOOL result = [_db executeUpdate:@"DELETE FROM PrettyGirls where url = ?",url];
    [_db close];
    return result;
}
/***********************************************************************/


 
@end



