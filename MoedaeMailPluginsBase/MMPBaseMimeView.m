//
//  MoedaeMailPluginsBase.m
//  MoedaeMailPluginsBase
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <MoedaeMailPlugins/MoedaeMailPlugins.h>

NSString* MBRichMessageViewAttributeName = @"MBRichMessageView";

@implementation MMPBaseMimeView

+(NSSet*) contentTypes {
    return nil;
}

+ (BOOL) requiresConstraintBasedLayout {
    return YES;
}

- (unsigned)interfaceVersion {
    return 0;
}

/*
 Need the 
    node -> create subviews
    subviews -> load data from node
 */
-(void) setNode:(MMPMimeProxy *)node {
    if (_node != node) {
        [self removeSubviews];
        _node = node;
        if (_node) {
            [self createSubviews];
        }
    }
}

-(instancetype) initWithFrame:(NSRect)frameRect node:(MMPMimeProxy *)node options:(NSDictionary *)options attributes:(NSDictionary *)attributes {
    self = [super initWithFrame: frameRect];
    if (self) {
        // Initialization code here.
        [self setOptions: options];
        [self setAttributes: attributes];
        [self setNode: node];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame {
    return [self initWithFrame: frame node: nil options: nil attributes: nil];
}


-(BOOL) wantsRichTextPresentation {
    BOOL useRichMessageView = NO;
    
    id useRichMessageViewOption = self.options[MBRichMessageViewAttributeName];
    
    if (useRichMessageViewOption && [useRichMessageViewOption isKindOfClass: [NSNumber class]]) {
        useRichMessageView = [(NSNumber*)useRichMessageViewOption boolValue];
    }
    
    return useRichMessageView;
}

-(void) createSubviews {
    [self addSubview: self.mimeView];
    [self.mimeView setTranslatesAutoresizingMaskIntoConstraints: NO];
    [self.mimeView removeConstraints: self.mimeView.constraints];
    [self removeConstraints: self.constraints];
    [self setNeedsUpdateConstraints: YES];
}

-(void) removeSubviews {
    NSArray* subviews = self.subviews;
    for (NSView* view in subviews) {
        [view removeFromSuperview];
    }
    self.mimeView = nil;
}

-(void) updateConstraints {
    
    if (self.mimeView) {
        NSView* nodeView = self.mimeView;
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem: nodeView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant: 4],
                               
                               [NSLayoutConstraint constraintWithItem: nodeView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0
                                                             constant: 4],
                               
                               [NSLayoutConstraint constraintWithItem: nodeView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant: -4],
                               
                               [NSLayoutConstraint constraintWithItem: nodeView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0
                                                             constant: -4],
                               
                               ]];
        
        [nodeView setContentHuggingPriority: 250 forOrientation: NSLayoutConstraintOrientationHorizontal];
        [nodeView setContentHuggingPriority: 750 forOrientation: NSLayoutConstraintOrientationVertical];
        
        [nodeView setContentCompressionResistancePriority: 250 forOrientation: NSLayoutConstraintOrientationHorizontal];
        [nodeView setContentCompressionResistancePriority: 1000 forOrientation: NSLayoutConstraintOrientationVertical];
        
    }
    [super updateConstraints];
}


@end
