//
//  MoedaeMailPluginsNSCatTests.m
//  MoedaeMailPlugins
//
//  Created by Taun Chapman on 04/29/14.
//  Copyright (c) 2014 MOEDAE LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+IMAPConversions.h"

@interface MoedaeMailPluginsNSCatTests : XCTestCase

@end

@implementation MoedaeMailPluginsNSCatTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testUIDCompression1 {
    NSArray* sortedArray = @[@1,@2,@3,@5,@7,@8,@9,@10,@11,@12,@20];
    NSArray* sequenceArray = [sortedArray asArrayOfIMAPSequenceStringsMaxSequence: 30 MaxLength: 100];
    NSString* refString = @"1:3,5,7:12,20";
    BOOL result = NO;
    if ((sequenceArray.count==1) && [sequenceArray[0] isEqualToString: refString]) {
        result = YES;
    }
    XCTAssertTrue(result, @"");
}
-(void) testUIDCompression2 {
    NSArray* sortedArray = @[@1,@2,@3,@5,@6,@7,@8,@9,@10,@11,@12,@20,@21,@22,@24,@27,@30];
    NSArray* sequenceArray = [sortedArray asArrayOfIMAPSequenceStringsMaxSequence: 5 MaxLength: 100];
    NSArray* refArray = @[@"1:3,5:6",@"7:11",@"12,20:22,24",@"27,30"];
    BOOL result = [sequenceArray isEqualToArray: refArray];
    
    XCTAssertTrue(result, @"");
}
-(void) testUIDCompression3 {
    NSArray* sortedArray = @[@1,@2,@3,@5,@6,@7,@8,@9,@10,@11,@12,@20,@21,@22,@24,@27,@30];
    NSArray* sequenceArray = [sortedArray asArrayOfIMAPSequenceStringsMaxSequence: 10 MaxLength: 100];
    NSArray* refArray = @[@"1:3,5:11",@"12,20:22,24,27,30"];
    BOOL result = [sequenceArray isEqualToArray: refArray];
    
    XCTAssertTrue(result, @"");
}
-(void) testUIDCompression4 {
    NSArray* sortedArray = @[@1,@2,@3,@5,@6,@7,@8,@9,@10,@11,@12,@20,@21,@22,@24,@27,@30];
    NSArray* sequenceArray = [sortedArray asArrayOfIMAPSequenceStringsMaxSequence: 10 MaxLength: 5];
    NSArray* refArray = @[@"1:3,5",@"6:12,20",@"21:22",@"24,27",@"30"];
    BOOL result = [sequenceArray isEqualToArray: refArray];

    XCTAssertTrue(result, @"");
}
-(void) testUIDCompression5 {
    NSArray* sortedArray = @[@1,@2,@3,@5,@6,@7,@8,@9,@10,@11,@12,@20,@21,@22,@24,@27,@30];
    NSArray* sequenceArray = [sortedArray asArrayOfIMAPSequenceStringsMaxSequence: 0 MaxLength: 0];
    NSArray* refArray = @[@"1:3,5:12,20:22,24,27,30"];
    BOOL result = [sequenceArray isEqualToArray: refArray];

    XCTAssertTrue(result, @"");
}
-(void) testUIDCompression6 {
    NSArray* sortedArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@20,@21,@22,@24,@27,@30];
    NSArray* sequenceArray = [sortedArray asArrayOfIMAPSequenceStringsMaxSequence: 5 MaxLength: 0];
    NSArray* refArray = @[@"1:5",@"6:10",@"11:12,20:22",@"24,27,30"];
    BOOL result = [sequenceArray isEqualToArray: refArray];

    XCTAssertTrue(result, @"");
}
@end
