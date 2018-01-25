//
//  JPLoggerStream.m
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import "JPLoggerStream.h"

@interface JPLoggerStream()<NSStreamDelegate> {
    NSDate *_lastWriteDate; ///< 上次写入操作的时间
    NSURL *_fileURL;
}

@property (nonatomic, strong, readwrite) NSOutputStream *writeStream; ///< 写日志流
@property (nonatomic, assign) NSInteger maxOpenTime; ///< IO打开的最大时间

@end

@implementation JPLoggerStream

+ (JPLoggerStream *)streamWithIdentification:(NSString *)identification fileURL:(NSURL *)fileURL maxOpenTime:(NSInteger)maxOpenTime {
    JPLoggerStream *stream = [[JPLoggerStream alloc] initWithIdentification:identification maxOpenTime:maxOpenTime fileURL:fileURL];
    return stream;
}

- (id)initWithIdentification:(NSString *)identification maxOpenTime:(NSInteger)maxOpenTime fileURL:(NSURL *)fileURL {
    self = [super init];
    if (self) {
        _identification = identification;
        _maxOpenTime = maxOpenTime;
        _fileURL = fileURL;
    }
    return self;
}

- (NSStreamStatus)streamStatus {
    return _writeStream.streamStatus;
}

#pragma mark 业务区域开始

- (void)timerHandler {
    NSTimeInterval openTime = [[NSDate date] timeIntervalSinceDate:_lastWriteDate];
    if (openTime >= self.maxOpenTime) {
        //超时，关闭IO
        if (self.writeStream.streamStatus == NSStreamStatusOpen) {
            [self closeStream];
            self.writeStream = nil;
        }
    }
}

- (NSData *)preprocessingContent:(NSString *)content {
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
    NSString *dateStr = [forMatter stringFromDate:_lastWriteDate];
    content = [dateStr stringByAppendingFormat:@":\n %@ \n",content];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

#pragma mark 业务区域结束

#pragma mark Stream操作区域开始

- (NSOutputStream *)createStream:(NSURL *)fileURL {
    NSOutputStream *stream = [[NSOutputStream alloc] initWithURL:fileURL append:YES];
    stream.delegate = self;
    return stream;
}

- (void)startStream {
    [self.writeStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.writeStream open];
    NSLog(@"%@打开Stream",_identification);
}

- (void)closeStream {
    [self.writeStream close];
    [self.writeStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    NSLog(@"%@关闭Stream",_identification);
}

- (void)writeData:(NSData *)logData {
    _lastWriteDate = [NSDate date];
    
    if (!self.writeStream) {
        self.writeStream = [self createStream:_fileURL];
    }
    if (self.writeStream.streamStatus == NSStreamStatusClosed || self.writeStream.streamStatus == NSStreamStatusNotOpen) {
        [self startStream];
    }
    
    [self.writeStream write:[logData bytes] maxLength:logData.length];
}

- (void)writeString:(NSString *)content {
    _lastWriteDate = [NSDate date];
    
    if (!self.writeStream) {
        self.writeStream = [self createStream:_fileURL];
    }
    if (self.writeStream.streamStatus == NSStreamStatusClosed || self.writeStream.streamStatus == NSStreamStatusNotOpen) {
        [self startStream];
    }
    
    NSData *logData = [self preprocessingContent:content];
    [self.writeStream write:[logData bytes] maxLength:logData.length];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    NSString *event;
    switch (eventCode) {
        case NSStreamEventNone: {
            event = @"NSStreamEventNone";
            break;
        }
            
        case NSStreamEventOpenCompleted: {
            event = @"NSStreamEventOpenCompleted";
            break;
        }
            
        case NSStreamEventHasBytesAvailable: {
            event = @"NSStreamEventHasBytesAvailable";
            break;
        }
            
        case NSStreamEventHasSpaceAvailable: {
            event = @"NSStreamEventHasSpaceAvailable";
            break;
        }
            
        case NSStreamEventErrorOccurred: {
            event = @"NSStreamEventErrorOccurred";
            break;
        }
            
        case NSStreamEventEndEncountered: {
            event = @"NSStreamEventEndEncountered";
            break;
        }
            
        default:
            break;
    }
    NSLog(@"%@-%@",aStream, event);
}

#pragma mark Stream操作区域结束

@end
