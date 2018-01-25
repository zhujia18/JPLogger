//
//  JPLoggerStream.h
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPLoggerStream : NSObject

@property (nonatomic, strong) NSString *identification; ///< 日志标识
/*
 NSStreamStatusNotOpen = 0,
 NSStreamStatusOpening = 1,
 NSStreamStatusOpen = 2,
 NSStreamStatusReading = 3,
 NSStreamStatusWriting = 4,
 NSStreamStatusAtEnd = 5,
 NSStreamStatusClosed = 6,
 NSStreamStatusError = 7 */
@property (nonatomic, strong, readonly) NSOutputStream *writeStream; ///< 写日志流
@property (nonatomic, assign, readonly) NSStreamStatus streamStatus; ///< 当前Stream的状态

/**
 创建日志写入流
 
 @param identification 日志标识
 @param fileURL 日志文件地址
 @param maxOpenTime IO最大打开时间
 @return 写入流
 */
+ (JPLoggerStream *)streamWithIdentification:(NSString *)identification fileURL:(NSURL *)fileURL maxOpenTime:(NSInteger)maxOpenTime;

/**
 通过Stream写日志到文件
 
 @param content 日志内容
 */
- (void)writeString:(NSString *)content;

- (void)writeData:(NSData *)logData;

/**
 时间心跳，外部触发，用来检测写入IO是否超时，如果超时则自动关闭IO
 */
- (void)timerHandler;

@end
