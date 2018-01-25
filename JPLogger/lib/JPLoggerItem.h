//
//  JPLoggerItem.h
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JPLoggerFilePathType) {
    JPLoggerFilePathType_Document = 0,
    JPLoggerFilePathType_Cache = 1,
    JPLoggerFilePathType_Temp = 2
};

@interface JPLoggerItem : NSObject

@property (nonatomic, assign, readonly) BOOL isEnable; ///< 是否启用
@property (nonatomic, strong) NSString *identification; ///< 日志标识
@property (nonatomic, strong) NSString *name; ///< 日志名称
@property (nonatomic, assign) NSInteger sectionSize; ///< 日志分段大小，单位KB，默认500KB（此功能待实现，目前日志不分段，如果超过这个大小就清空重建）
@property (nonatomic, assign) NSInteger level; ///< 日志等级，默认待定（此功能待实现）
@property (nonatomic, assign) JPLoggerFilePathType filePath; ///< 默认Document
@property (nonatomic, strong) NSString *subPath; ///< filePath下的子路径，默认JPLog
@property (nonatomic, strong) NSString *extension; ///< 文件扩展名，默认txt
@property (nonatomic, assign) NSInteger maxOpenTime; ///< IO打开的最大时间，默认60，单位秒，如果超过这个时间没有再写入的动作，则自动关闭IO

/**
 创建日志记录项
 
 @param identification 日志标识
 @param name 日志名称
 @return 日志记录项
 */
+ (JPLoggerItem *)itemWithIdentification:(NSString *)identification name:(NSString *)name;

@end
