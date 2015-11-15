//
//  WaterModel.h
//  PrettyGirls
//
//  Created by Tengfei on 15/11/15.
//  Copyright © 2015年 tengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterModel : NSObject
/***

 who: "张涵宇",
 publishedAt: "2015-11-13T04:03:12.613Z",
 desc: "11.13",
 type: "福利",
 url: "http://ww3.sinaimg.cn/large/7a8aed7bgw1exz7lm0ow0j20qo0hrjud.jpg",
 used: true,
 objectId: "56455fb500b0d1dbac0668bd",
 createdAt: "2015-11-13T03:57:41.206Z",
 updatedAt: "2015-11-13T04:03:13.180Z"
 */
@property (nonatomic,copy)NSString * who;
@property (nonatomic,copy)NSString * desc;
@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * url;
@property (nonatomic,copy)NSString * publishedAt
;




@end
