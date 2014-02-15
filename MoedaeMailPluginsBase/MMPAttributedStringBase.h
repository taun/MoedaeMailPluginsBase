//
//  MMPAttributedStringBase.h
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 02/15/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <MoedaeMailPlugins/MoedaeMailPlugins.h>

/*
 An abstract class to encapsulate the requirements for an embedded text view.
 */
@interface MMPAttributedStringBase : MMPBaseMimeView

/*
 Implement in base class.
 */
-(void) loadData;

@end
