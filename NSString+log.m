//
//  NSString+log.m
//  plist 解析
//
//  Created by cobi on 15-2-8.
//  Copyright (c) 2015年 ITWS. All rights reserved.
//

#import "NSString+log.h"

@implementation NSArray (log)

- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *str = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"\t%@,\n",obj];
    }];
    [str appendString:@"\n)"];
    
    return str;
}


@end


@implementation NSDictionary (log)

- (NSString *)descriptionWithLocale:(id)locale{
    
    NSMutableString *str = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@;\n",key,obj];
    }];
    
    [str appendString:@"}\n"];
    return str;
}

@end