//
//  MBMimeViewerPluginsManager.m
//  MailBoxes
//
//  Created by Taun Chapman on 02/05/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import "MBMimeViewerPluginsManager.h"
#import "MMPBaseMimeView.h"
#import "MMPPluginMissing.h"

NSString *ext = @"bundle";


@interface MBMimeViewerPluginsManager ()

@property (nonatomic,strong) NSMutableDictionary     *typeToClassMappings;

-(NSUInteger) loadPlugins;

@end


@implementation MBMimeViewerPluginsManager

+(instancetype) manager {
    
    static MBMimeViewerPluginsManager* sharedManager = nil;
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[self class] new];
    });
    
    return sharedManager;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        [self loadPlugins];
    }
    return self;
}

-(NSUInteger) loadPlugins {
    
    NSBundle *appBundle = [NSBundle mainBundle];
//    NSString* plugInsPath = [appBundle builtInPlugInsPath];
    
    NSArray* bundlePaths = [appBundle pathsForResourcesOfType:@"mmmimeviewerplugin"
                                         inDirectory:@"../PlugIns"];
    
    if ((bundlePaths.count >0) && (self.typeToClassMappings == nil)) {
        // only create the mapping if necessary
        _typeToClassMappings = [NSMutableDictionary new];
    }
    
    for (id fullPath in bundlePaths) {
        Class principalClass;
        
        NSBundle* bundle = [NSBundle bundleWithPath:fullPath];
        principalClass = [bundle principalClass];
        
        [self registerPluginClass: principalClass];
    }
    return  self.typeToClassMappings.count;
}

-(void) registerPluginClass:(Class)pluginClass {
    
    if ([pluginClass isSubclassOfClass: [MMPBaseMimeView class]]) {
        NSSet* contentTypes = [pluginClass contentTypes];
        for (NSString* contentType in contentTypes) {
            if (contentType.length > 0) {
                [self.typeToClassMappings setObject: pluginClass forKey: [contentType uppercaseString]];
            }
        }
    }
}

-(Class) classForMimeType: (NSString*) type subtype: (NSString*) subtype {
    Class pluginClass;
    
    if ((self.typeToClassMappings!=nil) && ([self.typeToClassMappings count] > 0)) {
        NSString* typeSubtypeUpper = [NSString stringWithFormat: @"%@/%@",[type uppercaseString], [subtype uppercaseString]];
        pluginClass = [self.typeToClassMappings objectForKey: typeSubtypeUpper];
        
        if (pluginClass==nil) {
            // no plugin available
            pluginClass = [MMPPluginMissing class];
        } else if (![pluginClass isSubclassOfClass: [MMPBaseMimeView class]]) {
            // double check it is the right class, was also checked before adding to mappings
            pluginClass = nil;
        }
   }
    return pluginClass;
}

//-(id) instanceForMimeViewerTypeSubtype:(NSString *)typeSubtype {
//    id pluginInstance;
//    
//    Class pluginClass = [self classForMimeTypeSubtype: typeSubtype];
//    if ([pluginClass isSubclassOfClass: [MoedaeMailPluginsBase class]]) {
//        pluginInstance = [pluginClass new];
//    }
//    return pluginInstance;
//}
@end
