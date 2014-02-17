//
//  MMPMessageViewOptions.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/16/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 There are many different ways to view a message.
 
 It can be viewed as rich text, plain text, raw ascii text and more.
 
 The way the user wants to view the message is separate from the message model and the controller and the views.
 
 The user tells the controller which needs to connect the model with the correct view and inform the view of the desired format.
 
 MMPMessageViewOptions is used to record and pass this information between the controller and views.
 
 */
@interface MMPMessageViewOptions : NSObject

/* show as plain text if YES otherwise use the best available alternate representation. */
@property (nonatomic,assign) BOOL           asPlainText;

@property (nonatomic,strong) NSDictionary   *attributes;

@end
