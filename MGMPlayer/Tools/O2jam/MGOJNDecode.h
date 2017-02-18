//
//  MGOJNDecode.h
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGOJNHeaderNotePackage;
@class MGOJNHeader;
@interface MGOJNDecode : NSObject
@property (nonatomic, copy) NSString *songID;
@property (nonatomic, strong) MGOJNHeader *ojnHeader;
@property (nonatomic, strong) NSArray<MGOJNHeaderNotePackage *> *notePackageArray;

+ (MGOJNDecode *)ojnDecodeWithSongID:(NSString *)songID;
@end
