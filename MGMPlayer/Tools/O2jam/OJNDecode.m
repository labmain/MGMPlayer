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
/*
 整个ojn文件结构:
 {
 header  300 byte
 data  easy
 data  normal
 data  hard
 jpg  载入界面图片
 bmp  bmp小预览图
 }
 
 sizeof(header) :0-300字节是描述歌曲信息的部分
 
 note_offset[0]: 这个值通常就是300 表示easy难度的数据区首地址
 
 note_offset[1]: normal数据区首地址
 
 note_offset[2]:hard难度首地址
 
 cover_offset: jpg首地址
 
 cover_offset+cover_size: bmp首地址
 ojn whole file size: bmp尾地址
 
 */
// note_offset 每个区域：包(package_header+note_event[])+包(package_header+note_event[])+包(package_header+note_event[])

/*
 channel的取值:
 0        measure fraction       //nt里有一列可以调 一个小节要显示百分之多少就是这列  和ibmsc里的小节线比例等同
 1        BPM change             //bpm 值
 2        note on 1st lane
 3        note on 2nd lane
 4        note on 3rd lane
 5        note on 4th lane(middle button)
 6        note on 5th lane
 7        note on 6th lane
 8        note on 7th lane
 9~22   auto-play samples      //bgm列
 注意的是 当channel为 0或1的时候 note_event是个float类型(4字节)
 当channel为2-22时note_event类型(也是4字节)  也就是package_header后面跟的数组实际解释类型取决于channel列的取值 可以把note_event和float看成一个union类型
 */
struct package_header {
    int   measure; // 标明这个package是属于第几小节线
    short channel; // 标明这个package是第几列的  具体取值见下面
    short events;  // 标明这个package 使用的是多少格线.  最大是192线(我已经测过).比如是64线那么package_header后面就会紧跟上一个note_event[64]数组;
};

/*
 value 表示Key音列表的索引值 比如这个值为17 那么key表索引值=17的地方如果有放一个
 "abc.ogg"的音频key 那么击打时就会自动播放
 
 volume; 播放key的音量，1-15,0为最大  基本用不到 置0即可
 pan;  左右声道权重，1-7 左，0或8表示中间，9-15右 用不到 置0
 note_type ; 为0时表示米粒，2表示LN的开头,3表示LN的结尾,4 不确定 可能表示  当wav和ogg同时存在时 辨别是不是ogg用的
 */
struct note_event {
    char value;
    char volume;
    char pan;
    char note_type;
};
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
