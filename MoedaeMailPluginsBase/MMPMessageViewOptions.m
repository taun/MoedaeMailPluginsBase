//
//  MMPMessageViewOptions.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/16/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "MMPMessageViewOptions.h"

@implementation MMPMessageViewOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        _showViewOutlines = NO;
        _verticalHuggingPriority = 750.0;
        
    }
    return self;
}
@end
