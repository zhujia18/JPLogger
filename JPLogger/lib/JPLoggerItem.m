//
//  JPLoggerItem.m
//  JPLogger
//
//  Created by Jasper on 2018/1/25.
//  Copyright © 2018年 Jasper. All rights reserved.
//

#import "JPLoggerItem.h"

@interface JPLoggerItem() {
    
}

@property (nonatomic, assign, readwrite) BOOL isEnable; ///< 是否启用

@end

@implementation JPLoggerItem
@synthesize isEnable = _isEnable;

+ (JPLoggerItem *)itemWithIdentification:(NSString *)identification name:(NSString *)name {
    JPLoggerItem *item = [[JPLoggerItem alloc] initWithIdentification:identification name:name];
    return item;
}

- (id)initWithIdentification:(NSString *)identification name:(NSString *)name {
    self = [self init];
    self.identification = identification;
    self.name = name;
    //读取Enable状态
    NSString *enableKey = [_identification stringByAppendingString:@"_LogItemEnable"];
    if (enableKey) {
        _isEnable = [[NSUserDefaults standardUserDefaults] boolForKey:enableKey];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        _maxOpenTime = 60;
        _sectionSize = 500;
        _filePath = JPLoggerFilePathType_Document;
        _subPath = @"JPLog";
        _extension = @"txt";
    }
    return self;
}

- (void)setIsEnable:(BOOL)isEnable {
    _isEnable = isEnable;
    NSString *enableKey = [_identification stringByAppendingString:@"_LogItemEnable"];
    if (enableKey) {
        [[NSUserDefaults standardUserDefaults] setBool:_isEnable forKey:enableKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)isEnable {
    return _isEnable;
}

@end
