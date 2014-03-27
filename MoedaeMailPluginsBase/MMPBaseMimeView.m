//
//  MMPBaseMimeView.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/04/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <MoedaeMailPlugins/MoedaeMailPlugins.h>

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

-(instancetype) initWithFrame:(NSRect)frameRect node:(MMPMimeProxy *)node options:(MMPMessageViewOptions *)options {
    self = [super initWithFrame: frameRect];
    if (self) {
        // Initialization code here.
        [self setOptions: options];
        [self setNode: node];
        self.loadingDidFinish = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame {
    return [self initWithFrame: frame node: nil options: nil];
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
        CGFloat margin = 4.0;
        
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem: self
                                                            attribute: NSLayoutAttributeTop
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: nodeView
                                                            attribute: NSLayoutAttributeTop
                                                           multiplier: 1.0
                                                             constant: -margin],
                               
                               [NSLayoutConstraint constraintWithItem: self
                                                            attribute: NSLayoutAttributeLeft
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: nodeView
                                                            attribute: NSLayoutAttributeLeft
                                                           multiplier: 1.0
                                                             constant: -margin],
                               
                               [NSLayoutConstraint constraintWithItem: self
                                                            attribute: NSLayoutAttributeBottom
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: nodeView
                                                            attribute: NSLayoutAttributeBottom
                                                           multiplier: 1.0
                                                             constant: 2*margin],
                               
                               [NSLayoutConstraint constraintWithItem: self
                                                            attribute: NSLayoutAttributeRight
                                                            relatedBy: NSLayoutRelationEqual
                                                               toItem: nodeView
                                                            attribute: NSLayoutAttributeRight
                                                           multiplier: 1.0
                                                             constant: margin],
                               
                               ]];
        
        [nodeView setContentHuggingPriority: 1000 forOrientation: NSLayoutConstraintOrientationHorizontal];
        [nodeView setContentHuggingPriority: 750 forOrientation: NSLayoutConstraintOrientationVertical];
        
        [nodeView setContentCompressionResistancePriority: 750 forOrientation: NSLayoutConstraintOrientationHorizontal];
        [nodeView setContentCompressionResistancePriority: 1000 forOrientation: NSLayoutConstraintOrientationVertical];
        
    }
    [super updateConstraints];
}


@end
