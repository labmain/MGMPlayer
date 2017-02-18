//
//  MGOJNDecode.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "MGOJNDecode.h"
#import "MGOJNHeader.h"
#define KPackageHeaderLenght 8
#define kPackageNoteEventLenght 6
struct package_header {
    int   measure;
    short channel;
    short events;
};

struct note_event {
    short value;
    char volume;
    char pan;
    char note_type;
};
@implementation MGOJNDecode
+ (MGOJNDecode *)ojnDecodeWithSongID:(NSString *)songID {
    MGOJNHeader *ojnHeader = [MGOJNHeader getMGOJNHeader];
    
    MGOJNDecode *ojnDecode = [[MGOJNDecode alloc] init];
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"o2ma100.ojn" ofType:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileName];
    
    if (fileHandle) {
        NSMutableArray<MGOJNHeaderNotePackage *> *notePackageArray = [NSMutableArray arrayWithCapacity:ojnHeader.note_offset.count];
        // 难度
        [fileHandle readDataOfLength:300];
        for (int i = 0; i < ojnHeader.note_offset.count; i ++) {
//            NSNumber *num = ojnHeader.note_offset[i];
            MGOJNHeaderNotePackage *notePackage = [[MGOJNHeaderNotePackage alloc] init];
            
            // package_header
            for (int j = 0; i < ojnHeader.package_count[i].intValue; j++) {
                
                MGOJNPackageHeader *notePackageHeader = [[MGOJNPackageHeader alloc] init];
                
                struct package_header packageHeaderStruct;
                NSData *packageHeaderData = [fileHandle readDataOfLength:sizeof(packageHeaderStruct)];
                [packageHeaderData getBytes:&packageHeaderStruct length:sizeof(packageHeaderStruct)];
                
                notePackageHeader.measure = packageHeaderStruct.measure;
                notePackageHeader.channel = packageHeaderStruct.channel;
                notePackageHeader.events = packageHeaderStruct.events;
                
                NSMutableArray<MGOJNNoteEvent *> *noteEventMArray = [NSMutableArray arrayWithCapacity:ojnHeader.package_count[i].intValue];
                 NSLog(@"measure : %d channel : %d note_events : %d",notePackageHeader.measure, notePackageHeader.channel, notePackageHeader.events);
                // event[]
                for (int k = 0; k < notePackageHeader.events; k++) {
                    struct note_event noteEventStruct;
                    NSData *noteEventData = nil;
                    if (notePackageHeader.channel >= 0 && notePackageHeader.channel <=2) {
                        [fileHandle readDataOfLength:4];
                        continue;
                    } else {
                        [fileHandle readDataOfLength:sizeof(noteEventStruct)];
                    }
                    [noteEventData getBytes:&noteEventStruct length:sizeof(noteEventStruct)];
                    MGOJNNoteEvent *noteEvent = [[MGOJNNoteEvent alloc] init];
                    noteEvent.value = noteEventStruct.value;
                    noteEvent.volume = noteEventStruct.volume;
                    noteEvent.pan = noteEventStruct.pan;
                    noteEvent.note_type = noteEventStruct.note_type;
                    if (noteEvent.note_type > 0 && noteEvent.note_type <= 4) {
                        NSLog(@"note_type : %d",noteEvent.note_type);
                    } else {
                        NSLog(@"Error!!!!");
                        return nil;
                    }
                    [noteEventMArray addObject:noteEvent];
                }
                
                notePackage.packageHeader = notePackageHeader;
                notePackage.noteEventArray = [noteEventMArray copy];
                [notePackageArray addObject:notePackage];
            }
        }
        
        ojnDecode.songID = songID;
        ojnDecode.ojnHeader = ojnHeader;
        ojnDecode.notePackageArray = [notePackageArray copy];
        return ojnDecode;
    }
    return nil;
}
@end
