//
//  MGOJNDecode.h
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OJNHeaderNotePackage;
@class OJNHeader;
@interface OJNDecode : NSObject
//@property (nonatomic, copy) NSString *songID;
@property (nonatomic, strong) OJNHeader *ojnHeader;
@property (nonatomic, strong) NSArray<OJNHeaderNotePackage *> *easyNotePackageArray;
@property (nonatomic, strong) NSArray<OJNHeaderNotePackage *> *normalNotePackageArray;
@property (nonatomic, strong) NSArray<OJNHeaderNotePackage *> *hardNotePackageArray;

+ (OJNDecode *)ojnDecodeWithSongID:(NSString *)songID;
@end
