//
//  JPLoggerFileManager.m
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import "JPLoggerFileManager.h"
#import <CoreGraphics/CoreGraphics.h>

@interface JPLoggerFileManager() {
    NSFileManager *_fileManager;
    NSString *_className;
}

@end

@implementation JPLoggerFileManager

- (id)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _className = NSStringFromClass([self class]);
    }
    return self;
}

#pragma mark 文件区域开始

- (NSString *)itemDirectory:(JPLoggerItem *)item {
    NSString *fileDir;
    switch (item.filePath) {
        case JPLoggerFilePathType_Document: {
            fileDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            break;
        }
            
        case JPLoggerFilePathType_Cache: {
            fileDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            break;
        }
            
        case JPLoggerFilePathType_Temp: {
            fileDir = NSTemporaryDirectory();
            break;
        }
            
        default: {
            fileDir = NSTemporaryDirectory();
            break;
        }
    }
    fileDir = [fileDir stringByAppendingPathComponent:item.subPath]; //拼接子路径
    return fileDir;
}

- (NSString *)itemFilePath:(JPLoggerItem *)item {
    NSString *fileDir = [self itemDirectory:item];
    NSString *filePath = [[fileDir stringByAppendingPathComponent:item.identification] stringByAppendingPathExtension:item.extension]; //拼接文件名和文件后缀
    return filePath;
}

- (BOOL)directoryExistsAtItem:(JPLoggerItem *)item {
    NSString *fileDir = [self itemDirectory:item];
    BOOL isDir = TRUE;
    BOOL isDirExists = [_fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    return isDirExists;
}

- (BOOL)fileExistsAtItem:(JPLoggerItem *)item {
    NSString *filePath = [self itemFilePath:item];
    BOOL isFileExists = [_fileManager fileExistsAtPath:filePath];
    return isFileExists;
}

- (BOOL)createDirectoryForItem:(JPLoggerItem *)item {
    BOOL isDirExists = [self directoryExistsAtItem:item];
    BOOL isCreateSuccess = YES;
    if (!isDirExists) {
        NSString *fileDir = [self itemDirectory:item];
        NSError *err = nil;
        isCreateSuccess = [_fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:NO attributes:nil error:&err];
        if (!isCreateSuccess && err) {
            NSLog(@"%@创建路径(%@)失败%@",_className ,fileDir ,err.description);
        } else {
            NSLog(@"%@创建路径(%@)成功",_className ,fileDir);
        }
    }
    return isCreateSuccess;
}

- (BOOL)createFileForItem:(JPLoggerItem *)item {
    BOOL isFileExists = [self fileExistsAtItem:item];
    BOOL isCreateSuccess = YES;
    if (!isFileExists) {
        NSString *filePath = [self itemFilePath:item];
        isCreateSuccess = [_fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (!isCreateSuccess) {
            NSLog(@"%@创建日志(%@)失败",_className ,filePath);
        } else {
            NSLog(@"%@创建日志(%@)成功",_className ,filePath);
        }
    }
    return isCreateSuccess;
}

- (BOOL)removeFileForItem:(JPLoggerItem *)item {
    BOOL isDirExists = [self directoryExistsAtItem:item];
    if (!isDirExists) {
        return NO;
    }
    BOOL isFileExists = [self fileExistsAtItem:item];
    if (!isFileExists) {
        return NO;
    }
    NSString *filePath = [self itemFilePath:item];
    NSError *err = nil;
    BOOL isRmSuccess = [_fileManager removeItemAtPath:filePath error:&err];
    if (!isRmSuccess && err) {
        NSLog(@"%@删除日志(%@)失败%@",_className ,filePath ,err.description);
    } else {
        NSLog(@"%@删除日志(%@)成功",_className ,filePath);
    }
    return isRmSuccess;
}

- (CGFloat)latestFileSizeAtItem:(JPLoggerItem *)item {
    NSString *filePath = [self itemFilePath:item];
    NSError *err = nil;
    CGFloat fileSizeKB = [[_fileManager attributesOfItemAtPath:filePath error:&err] fileSize] / 1024.0f;
    if (err) {
        NSLog(@"%@获取日志大小(%@)失败%@",_className ,filePath ,err.description);
    } else {
        NSLog(@"%@获取日志大小(%@)成功",_className ,filePath);
    }
    return fileSizeKB;
}

- (NSURL *)getFilePathWithItem:(JPLoggerItem *)item {
    BOOL isDirExists = [self directoryExistsAtItem:item];
    if (!isDirExists) {
        [self createDirectoryForItem:item];
    }
    BOOL isFileExists = [self fileExistsAtItem:item];
    if (!isFileExists) {
        [self createFileForItem:item];
    }
    NSString *filePath = [self itemFilePath:item];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    if (!fileURL) {
        NSLog(@"%@获取日志文件路径失败",_className);
        return nil;
    }
    return fileURL;
}

#pragma mark 文件区域结束

@end
