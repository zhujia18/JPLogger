//
//  JPLogger.h
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#ifndef LoggerOpen
#define LoggerOpen 1 //1开启记录日志，0不开启记录日志
#endif

#import <Foundation/Foundation.h>
#import "JPLoggerStream.h"
#import "JPLoggerItem.h"

#define kJPDebugLogIdentification_Demo1 @"kJPDebugLogIdentification_Demo1" //演示用
#define kJPDebugLogIdentification_Demo2 @"kJPDebugLogIdentification_Demo2" //演示用

#define JPLoggerItem_DefaultItem @[ \
[JPLoggerItem itemWithIdentification:kJPDebugLogIdentification_Demo1 name:@"Demo1"], \
[JPLoggerItem itemWithIdentification:kJPDebugLogIdentification_Demo2 name:@"Demo2"] \
]

/*要做的事情
 ***已实现*** 1.可以自定义日志路径，根据Document、Cache、Temp等路径为跟路径，子路径可以自己传入，然后，还有一个参数是文件名。这样，一个完整的路径就出来了
 ***已实现*** 2.可以上传文件到第三方应用或AirDrop
 3.可以上传批量文件的zip到第三方应用或AirDrop
 4.可以用户手动输入完整路径，来匹配到文件，并发送出去
 ***已实现*** 5.自己存的日志，默认全部统一管理在同一个路径下，也可以自定义路径
 6.增加WebServer
 7.增加Web控制台
 8.可以规划日志按照类名字去记录，或者按照规定的名字去记录，或者默认全部记录到default中
 9.可以设置日志保存时间，和日志保存大小，是否分文件
 10.日志分等级
 11.日志的信息包括类名、行号、线程ID、时间、日志信息
 12.可以根据item初始化累计达到多少次，之后清除日志，重新记录，计数器清零(APP启动次数)
 */

/**
 JPLogger V0.8.3 ByJasper
 */
@interface JPLogger : NSObject {
    
}

@property (nonatomic, strong, readonly) NSArray<JPLoggerItem *> *items;

/**
 获取日志管理器单例
 
 @return 日志管理器
 */
+ (JPLogger *)sharedInstance;

/**
 往日志管理器里添加日志记录项
 
 @param item 日志记录项
 */
- (void)addLogItem:(JPLoggerItem *)item;

- (BOOL)removeFileForItem:(JPLoggerItem *)item;

/**
 检查当前标识的日志记录项是否启用
 
 @param identification 日志标识
 @return 日志记录项是否启用，YES启用，NO禁用
 */
- (BOOL)checkItemEnable:(NSString *)identification;

/**
 设置当前标识的日志记录项是否启用
 
 @param identification 日志标识
 @param isEnable 设置日志记录项是否启用，YES启用，NO禁用
 */
- (void)setItemEnable:(NSString *)identification enable:(BOOL)isEnable;

/**
 上传日志文件
 
 @param identification 日志标识
 */
+ (void)uploadLogForIdentification:(NSString *)identification;

/**
 上传日志文件
 
 @param identification 日志标识
 */
- (void)uploadLogForIdentification:(NSString *)identification;

/**
 写入日志到文件
 
 @param identification 日志标识
 @param logString 日志内容
 */
+ (void)writeLogForIdentification:(NSString *)identification log:(NSString *)logString;

+ (void)writeLogForIdentification:(NSString *)identification logData:(NSData *)logData;

/**
 写入日志到文件
 
 @param identification 日志标识
 @param logString 日志内容
 */
- (void)writeLogForIdentification:(NSString *)identification log:(NSString *)logString;

- (void)writeLogForIdentification:(NSString *)identification logData:(NSData *)logData;

@end
