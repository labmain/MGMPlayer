//
//  MGOJNDecode.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "OJNDecode.h"
#import "OJNHeader.h"
#define KPackageHeaderLenght 8
#define kPackageNoteEventLenght 6

@implementation OJNDecode
+ (OJNDecode *)ojnDecodeWithSongID:(NSString *)songID {
    OJNHeader *ojnHeader = [OJNHeader getOJNHeader];
    
    OJNDecode *ojnDecode = [[OJNDecode alloc] init];
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"o2ma100.ojn" ofType:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileName];
    long long offsetZero = 0;
    [fileHandle seekToFileOffset:offsetZero];
    
    if (fileHandle) {
        NSMutableArray<OJNHeaderNotePackage *> *notePackageArray = [NSMutableArray arrayWithCapacity:ojnHeader.note_offset.count];
        // 难度
        long long offsetHeader = 300;
        [fileHandle readDataOfLength:offsetHeader];
        
        for (int i = 0; i < ojnHeader.note_offset.count; i ++) {
            //            NSNumber *num = ojnHeader.note_offset[i];
            
            // package_header
            for (int j = 0; j < ojnHeader.package_count[i].intValue; j++) {
                OJNHeaderNotePackage *notePackage = [[OJNHeaderNotePackage alloc] init];
                
                OJNPackageHeader *notePackageHeader = [[OJNPackageHeader alloc] init];
                
                struct package_header packageHeaderStruct;
                NSData *packageHeaderData = [fileHandle readDataOfLength:sizeof(packageHeaderStruct)];
                [packageHeaderData getBytes:&packageHeaderStruct length:sizeof(packageHeaderStruct)];
                
                notePackageHeader.measure = packageHeaderStruct.measure;
                notePackageHeader.channel = packageHeaderStruct.channel;
                notePackageHeader.events = packageHeaderStruct.events;
                
                NSMutableArray<OJNNoteEvent *> *noteEventMArray = [NSMutableArray arrayWithCapacity:ojnHeader.package_count[i].intValue];
                NSLog(@"measure : %d channel : %d note_events : %d",notePackageHeader.measure, notePackageHeader.channel, notePackageHeader.events);
                // event[]
                for (int k = 0; k < notePackageHeader.events; k++) {
                    struct note_event noteEventStruct;
                    NSData *noteEventData = nil;
                    // 这个不论是 float 还是 note_event 都是读取 4 个字节
                    if (notePackageHeader.channel == 0 && notePackageHeader.channel == 1) {
                        noteEventData = [fileHandle readDataOfLength:sizeof(float)];
                        continue;
                    } else {
                        noteEventData = [fileHandle readDataOfLength:sizeof(noteEventStruct)];
                    }
                    [noteEventData getBytes:&noteEventStruct length:sizeof(noteEventStruct)];
                    if (noteEventStruct.value == 0) {
                        continue;
                    }
                    if (noteEventStruct.note_type >= 0 && noteEventStruct.note_type <= 4) {
                        OJNNoteEvent *noteEvent = [[OJNNoteEvent alloc] init];
                        noteEvent.value = noteEventStruct.value;
                        noteEvent.volume = noteEventStruct.volume;
                        noteEvent.pan = noteEventStruct.pan;
                        noteEvent.note_type = noteEventStruct.note_type;
//                        switch (noteEventStruct.note_type) {
//                            case 0:
//                                NSLog(@"value : %d || 🔴",noteEventStruct.value);
//                                break;
//                            case 2:
//                                NSLog(@"value : %d || 🔻",noteEventStruct.value);
//                                break;
//                            case 3:
//                                NSLog(@"value : %d || 🔺",noteEventStruct.value);
//                                break;
//                            case 4:
//                                NSLog(@"value : %d || ❗️",noteEventStruct.value);
//                                break;
//                            default:
//                                break;
//                        }
                        [noteEventMArray addObject:noteEvent];
                    } else {
                        NSLog(@"Error!!!!");
                        return 0;
                    }
                }
                
                notePackage.packageHeader = notePackageHeader;
                notePackage.noteEventArray = [noteEventMArray copy];
                [notePackageArray addObject:notePackage];
            }
            if (i == 0) {
                ojnDecode.easyNotePackageArray = [notePackageArray copy];
            } else if (i == 1) {
                ojnDecode.normalNotePackageArray = [notePackageArray copy];
            } else if (i == 2) {
                ojnDecode.hardNotePackageArray = [notePackageArray copy];
            }
        }
        
//        ojnDecode.songID = songID;
        ojnDecode.ojnHeader = ojnHeader;
        
        [fileHandle closeFile];
        return ojnDecode;
    }
    return nil;
}
@end
