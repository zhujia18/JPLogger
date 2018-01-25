//
//  JPLoggerFileManager.h
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JPLoggerItem.h"

@interface JPLoggerFileManager : NSObject

/**
 获取日志记录项的日志文件存储路径
 
 @param item 日志记录项
 @return 日志记录项的日志文件存储路径
 */
- (NSString *)itemDirectory:(JPLoggerItem *)item;

/**
 获取日志记录项的日志文件地址
 
 @param item 日志记录项
 @return 日志记录项的日志文件地址
 */
- (NSString *)itemFilePath:(JPLoggerItem *)item;

/**
 检测日志记录项的日志文件存储路径是否存在
 
 @param item 日志记录项
 @return 日志记录项的日志文件存储路径是否存在
 */
- (BOOL)directoryExistsAtItem:(JPLoggerItem *)item;

/**
 检测日志记录项的日志文件是否存在
 
 @param item 日志记录项
 @return 日志记录项的日志文件是否存在
 */
- (BOOL)fileExistsAtItem:(JPLoggerItem *)item;

/**
 创建日志记录项的日志文件存储路径
 
 @param item 日志记录项
 @return 是否创建成功
 */
- (BOOL)createDirectoryForItem:(JPLoggerItem *)item;

/**
 创建日志记录项的日志文件
 
 @param item 日志记录项
 @return 是否创建成功
 */
- (BOOL)createFileForItem:(JPLoggerItem *)item;

/**
 删除日志记录项的日志文件
 
 @param item 日志记录项
 @return 是否删除成功
 */
- (BOOL)removeFileForItem:(JPLoggerItem *)item;

/**
 获取日志记录项的最新日志片段文件大小，单位KB
 
 @param item 日志记录项
 @return 最新日志片段文件大小，单位KB
 */
- (CGFloat)latestFileSizeAtItem:(JPLoggerItem *)item;

/**
 获取日志记录项的最新写入片段文件URL
 
 @param item 日志记录项
 @return 日志记录项的最新写入片段文件URL
 */
- (NSURL *)getFilePathWithItem:(JPLoggerItem *)item;

@end
