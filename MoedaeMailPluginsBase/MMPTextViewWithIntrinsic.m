//
//  MMPTextViewWithIntrinsic.m
//  ConstraintsTests
//
//  Created by Taun Chapman on 01/30/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "MMPTextViewWithIntrinsic.h"

@implementation MMPTextViewWithIntrinsic

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(NSSize) intrinsicContentSize {
    CGFloat height = self.frame.size.height;
    NSSize newSize = NSMakeSize(NSViewNoInstrinsicMetric, height);
    return newSize;
}

-(void) viewFrameChanged:(NSView *)view {
    [self invalidateIntrinsicContentSize];
}

-(void) viewBoundsChanged:(NSView *)view {
//    [self invalidateIntrinsicContentSize];
}
@end
