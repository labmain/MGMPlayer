//
//  OJMDecode.h
//  MGMPlayer
//
//  Created by 王顺 on 2017/2/19.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OJMSoundPart;
@interface OJMDecode : NSObject
@property (nonatomic, strong) NSArray<OJMSoundPart *> *soundArray;

+ (OJMDecode *)getOJMSounds;

@end


@interface OJMSoundPart : NSObject
@property (nonatomic, copy) NSString *ojmLocalPath;
@property (nonatomic, assign) int soundPartID;
@property (nonatomic, assign) long long soundStartOffset;
@property (nonatomic, assign) long long soundEndOffset;

@property (nonatomic, assign) short codec_code;
//@property (nonatomic, strong) NSURL *soundPartUrl;
//@property (nonatomic, assign) int soundType;

- (NSURL *)getSoundPartUrl;
@end
