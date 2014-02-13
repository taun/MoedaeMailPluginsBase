//
//  MMPPluginMissing.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/13/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "MMPPluginMissing.h"

@implementation MMPPluginMissing

+(NSSet*) contentTypes {
    return nil;
}

-(void) createSubviews {
    NSSize subStructureSize = self.frame.size;
    NSTextField* nodeView = [[NSTextField alloc] initWithFrame:  NSMakeRect(0, 0, subStructureSize.width, subStructureSize.height)];
    [nodeView setStringValue: [NSString stringWithFormat: @"Missing plugin for: %@/%@", self.node.type, self.node.subtype]];
    [nodeView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self addSubview: nodeView];
    self.mimeView = nodeView;
}

@end
