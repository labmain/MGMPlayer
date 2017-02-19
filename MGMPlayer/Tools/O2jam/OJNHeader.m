//
//  OJNHeader.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "OJNHeader.h"

typedef struct header ojn_header;  //定义一个别名
@implementation OJNHeader

+ (OJNHeader *)getOJNHeader {
    ojn_header ojnInfoBuffer;//定义一个ojn_header的变量
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"o2ma100.ojn" ofType:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileName];
    
    OJNHeader *ojnheader = [[OJNHeader alloc] init];
    
//    NSLog(@"%lu",sizeof(ojnheader));
    if (fileHandle) {
        NSData *OJNHanderData = [fileHandle readDataOfLength:sizeof(ojn_header)];
        [OJNHanderData getBytes:&ojnInfoBuffer length:sizeof(ojn_header)];
        
        ojnheader.songid = ojnInfoBuffer.songid;
        ojnheader.signature = [NSString stringWithUTF8String:ojnInfoBuffer.signature];
        ojnheader.encode_version = ojnInfoBuffer.encode_version;
        ojnheader.genre = ojnInfoBuffer.genre;
        ojnheader.bpm = ojnInfoBuffer.bpm;
        
        NSMutableArray *mLevelArr = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            NSNumber *num = [NSNumber numberWithShort:ojnInfoBuffer.level[i]];
            [mLevelArr addObject:num];
        }
        ojnheader.level = [mLevelArr copy];
        
        NSMutableArray *mEventCount = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            NSNumber *num = [NSNumber numberWithInt:ojnInfoBuffer.event_count[i]];
            [mEventCount addObject:num];
        }
        ojnheader.event_count = [mEventCount copy];
        
        NSMutableArray *mNoteCount = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            NSNumber *num = [NSNumber numberWithInt:ojnInfoBuffer.note_count[i]];
            [mNoteCount addObject:num];
        }
        ojnheader.note_count = [mNoteCount copy];
        
        NSMutableArray *mMeasureCount = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            NSNumber *num = [NSNumber numberWithInt:ojnInfoBuffer.measure_count[i]];
            [mMeasureCount addObject:num];
        }
        ojnheader.measure_count = [mMeasureCount copy];
        
        NSMutableArray *mPackageCount = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            NSNumber *num = [NSNumber numberWithInt:ojnInfoBuffer.package_count[i]];
            [mPackageCount addObject:num];
        }
        ojnheader.package_count = [mPackageCount copy];
        
        ojnheader.old_encode_version = ojnInfoBuffer.old_encode_version;
        ojnheader.old_genre = [NSString stringWithUTF8String:ojnInfoBuffer.old_genre];
        ojnheader.bmp_size = ojnInfoBuffer.bmp_size;
        ojnheader.old_file_version = ojnInfoBuffer.old_file_version;
        
        ojnheader.title = [NSString stringWithUTF8String:ojnInfoBuffer.title];
        ojnheader.artist = [NSString stringWithUTF8String:ojnInfoBuffer.artist];
        ojnheader.noter = [NSString stringWithUTF8String:ojnInfoBuffer.noter];
        ojnheader.ojm_file = [NSString stringWithUTF8String:ojnInfoBuffer.ojm_file];
        
        ojnheader.cover_size = ojnInfoBuffer.cover_size;
        
        NSMutableArray *mTimeArr = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            NSNumber *num = [NSNumber numberWithInt:ojnInfoBuffer.time[i]];
            [mTimeArr addObject:num];
        }
        ojnheader.time = [mTimeArr copy];
        
        NSMutableArray *mNoteOffset = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            NSNumber *num = [NSNumber numberWithInt:ojnInfoBuffer.note_offset[i]];
            [mNoteOffset addObject:num];
        }
        ojnheader.note_offset = [mNoteOffset copy];
        
        ojnheader.cover_offset = ojnInfoBuffer.cover_offset;
        [fileHandle closeFile];
        
        return ojnheader;
    }
    return nil;
}
@end

@implementation OJNHeaderNotePackage



@end
@implementation OJNPackageHeader



@end
@implementation OJNNoteEvent



@end
