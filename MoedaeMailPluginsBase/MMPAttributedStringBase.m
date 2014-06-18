//
//  MMPAttributedStringBase.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/15/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "MMPAttributedStringBase.h"

@implementation MMPAttributedStringBase

-(void) loadData {
    
}

-(void) createSubviews {
    NSSize subStructureSize = self.frame.size;
    
    NSTextView* nodeView = [[MMPTextViewWithIntrinsic alloc] initWithFrame: NSMakeRect(0, 0, subStructureSize.width, subStructureSize.height)];
    // View in nib is min size. Therefore we can use nib dimensions as min when called from awakeFromNib
    [nodeView setMinSize: NSMakeSize(subStructureSize.width, subStructureSize.height)];
    [nodeView setMaxSize: NSMakeSize(FLT_MAX, FLT_MAX)];
    [nodeView setVerticallyResizable: YES];
    
    // No horizontal scroll version
    //    [rawMime setHorizontallyResizable: YES];
    //    [rawMime setAutoresizingMask: NSViewWidthSizable];
    //
    //    [[rawMime textContainer] setContainerSize: NSMakeSize(subStructureSize.width, FLT_MAX)];
    //    [[rawMime textContainer] setWidthTracksTextView: YES];
    
    // Horizontal resizable version
    [nodeView setHorizontallyResizable: YES];
    //    [rawMime setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
    
    [[nodeView textContainer] setContainerSize: NSMakeSize(FLT_MAX, FLT_MAX)];
    [[nodeView textContainer] setWidthTracksTextView: YES];
    [nodeView setEditable: NO];
    
    //    [self addSubview: nodeView];
    
    //    [nodeView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    //    NSDictionary *views = NSDictionaryOfVariableBindings(self, rawMime);
    
    //    [self setContentCompressionResistancePriority: NSLayoutPriorityFittingSizeCompression-1 forOrientation: NSLayoutConstraintOrientationVertical];
    //NSLayoutPriorityDefaultHigh
    
    self.mimeView = nodeView;
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self.mimeView selector: @selector(viewFrameChanged:) name: NSViewFrameDidChangeNotification object: self.superview];
    
    [self loadData];
    
    [super createSubviews];
}

-(void) dealloc {
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver: self.mimeView];
}

@end
