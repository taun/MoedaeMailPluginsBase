//
//  MBMimeViewerPluginsManager.h
//  MailBoxes
//
//  Created by Taun Chapman on 02/05/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Singleton class for managing plugins.
 
 Creates a dictionary of mime types to plugin bundle class.
 
 */
@interface MBMimeViewerPluginsManager : NSObject

+(instancetype) manager;

/*
 Iterates through returned plugin class contentType set and uses uppercase version as dictionary key.
 */
-(void) registerPluginClass: (Class) pluginClass;
/*
 argument: type and subtype appended. Will be transformed to uppercase before lookup.
 */
-(Class) classForMimeType: (NSString*) type subtype: (NSString*) subtype;

@end
