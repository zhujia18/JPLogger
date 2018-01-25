//
//  JPLogger.m
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLogger.h"
#import "JPLoggerFileManager.h"

@interface JPLogger() {
    NSString *_className;
    JPLoggerFileManager *_logFileManager;
    NSMutableDictionary<NSString *, JPLoggerItem *> *_loggerItems;
    NSMutableDictionary<NSString *, JPLoggerStream *> *_loggerStreams;
    dispatch_source_t _timer; ///< 计时器
}

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@end

@implementation JPLogger

+ (JPLogger *)sharedInstance {
    static JPLogger *_staticLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _staticLogger = [[JPLogger alloc] init];
    });
    return _staticLogger;
}

- (id)init {
    self = [super init];
    if (self) {
        _className = NSStringFromClass([self class]);
        [self startTimer];
        _logFileManager = [[JPLoggerFileManager alloc] init];
        _loggerItems = [[NSMutableDictionary alloc] init];
        _loggerStreams = [[NSMutableDictionary alloc] init];
        for (JPLoggerItem *item in JPLoggerItem_DefaultItem) {
            [self addLogItem:item];
        }
    }
    return self;
}

- (NSArray<JPLoggerItem *> *)items {
    return _loggerItems.allValues;
}

#pragma mark 计时器区域开始

- (void)startTimer {
    __weak __typeof__(self) weakSelf = self;
    uint64_t interval = NSEC_PER_SEC;
    dispatch_queue_t queue = dispatch_queue_create("timeQueue", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf sendHandlerForStreams];
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        NSLog(@"停止了JPLogger的计时器");
    });
    dispatch_resume(_timer);
}

- (void)stopTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark 计时器区域结束

#pragma mark Stream维护区域开始

- (void)addLogStreamWithItem:(JPLoggerItem *)item {
    if (item) {
        CGFloat fileSizeKB = [_logFileManager latestFileSizeAtItem:item];
        if (fileSizeKB > item.sectionSize) {
            [_logFileManager removeFileForItem:item];
        }
        NSURL *logURL = [_logFileManager getFilePathWithItem:item];
        JPLoggerStream *stream = [JPLoggerStream streamWithIdentification:item.identification fileURL:logURL maxOpenTime:item.maxOpenTime];
        [_loggerStreams setObject:stream forKey:stream.identification];
    }
}

- (void)sendHandlerForStreams {
    NSArray *allStreams = _loggerStreams.allValues;
    for (JPLoggerStream *stream in allStreams) {
        [stream timerHandler];
    }
}

#pragma mark Stream维护区域结束

#pragma mark Item维护区域开始

- (void)addLogItem:(JPLoggerItem *)item {
    if (item) {
        [_loggerItems setObject:item forKey:item.identification];
        [self addLogStreamWithItem:item];
    }
}

- (BOOL)removeFileForItem:(JPLoggerItem *)item {
    if (item) {
        return [_logFileManager removeFileForItem:item];
    }
    return NO;
}

- (BOOL)checkItemEnable:(NSString *)identification {
    JPLoggerItem *item = [_loggerItems objectForKey:identification];
    return item.isEnable;
}

- (void)setItemEnable:(NSString *)identification enable:(BOOL)isEnable {
    JPLoggerItem *item = [_loggerItems objectForKey:identification];
    [item setValue:@(isEnable) forKey:NSStringFromSelector(@selector(isEnable))];
}

#pragma mark Item维护区域结束

#pragma mark 业务区域开始

+ (void)uploadLogForIdentification:(NSString *)identification {
    [[JPLogger sharedInstance] uploadLogForIdentification:identification];
}

- (void)uploadLogForIdentification:(NSString *)identification {
    JPLoggerItem *item = [_loggerItems objectForKey:identification];
    if (!item) {
        NSLog(@"获取日志Item失败");
        return;
    }
    NSURL *fileURL = [_logFileManager getFilePathWithItem:item];
    if (!fileURL) {
        NSLog(@"日志文件不存在");
        return;
    }
    CGFloat fileSizeKB = [_logFileManager latestFileSizeAtItem:item];
    if (fileSizeKB <= 0) {
        NSLog(@"获取文件大小为0");
        return;
    }
    //存在
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    _documentController.delegate = (id<UIDocumentInteractionControllerDelegate>)self;
    
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    if (topVC) {
        [_documentController presentOpenInMenuFromRect:topVC.view.bounds inView:topVC.view animated:YES];
    }
}

+ (void)writeLogForIdentification:(NSString *)identification log:(NSString *)logString {
    if (!identification || !logString) {
        return;
    }
    [[JPLogger sharedInstance] writeLogForIdentification:identification log:logString];
}

+ (void)writeLogForIdentification:(NSString *)identification logData:(NSData *)logData {
    if (!identification || !logData) {
        return;
    }
    [[JPLogger sharedInstance] writeLogForIdentification:identification logData:logData];
}

- (void)writeLogForIdentification:(NSString *)identification log:(NSString *)logString {
    if (!identification || !logString) {
        return;
    }
    NSLog(@"%@",logString);
    JPLoggerItem *item = [_loggerItems objectForKey:identification];
    if (!item.isEnable) {
        return;
    }
    JPLoggerStream *stream = [_loggerStreams objectForKey:identification];
    [stream writeString:logString];
}

- (void)writeLogForIdentification:(NSString *)identification logData:(NSData *)logData {
    if (!identification || !logData) {
        return;
    }
    JPLoggerItem *item = [_loggerItems objectForKey:identification];
    if (!item.isEnable) {
        return;
    }
    JPLoggerStream *stream = [_loggerStreams objectForKey:identification];
    [stream writeData:logData];
}

#pragma mark 业务区域结束

@end
