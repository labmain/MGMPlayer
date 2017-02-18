//
//  MGOJNHeader.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "MGOJNHeader.h"
/*
 *定义一个header类型
 */
struct header {
    int songid;
    char signature[4];
    float encode_version;
    int genre;
    float bpm; // 初始BPM
    short level[4]; // 歌曲的3个等级  只使用前3个 范围0~65535
    int event_count[3];
    int note_count[3];
    int measure_count[3]; // 3个难度各自有多少小节数
    int package_count[3]; // 标记包的数量 3难度，package代表一个小节中的某一列
    short old_encode_version;
    short old_songid;
    char old_genre[20];
    int bmp_size; // 缩略图图像的大小
    int old_file_version;
    char title[64]; // 歌名
    char artist[32]; // 作曲家名
    char noter[32]; // noter名
    char ojm_file[32]; // 相关联的ojm文件名，一般o2maxxxx.ojm
    int cover_size;//这是封面图片的大小，以字节为单位
    int time[3]; // 3 难度歌曲时长 单位是秒
    int note_offset[3];// 容易，普通，困难 的 note 位置
    int cover_offset;
};
/*
 genre:
 0	Ballad
 1	Rock
 2	Dance
 3	Techno
 4	Hip-hop
 5	Soul/R&B
 6	Jazz
 7	Funk
 8	Classical
 9	Traditional
 10	Etc
 */
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
struct package_header {
    int   measure; // 标明这个package是属于第几小节线
    short channel; // 标明这个package是第几列的  具体取值见下面
    short events;  // 标明这个package 使用的是多少格线.  最大是192线(我已经测过).比如是64线那么package_header后面就会紧跟上一个note_event[64]数组;
};
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

struct note_event {
    short value;
    char volume;
    char pan;
    char note_type;
};
/*
 value 表示Key音列表的索引值 比如这个值为17 那么key表索引值=17的地方如果有放一个
 "abc.ogg"的音频key 那么击打时就会自动播放
 
 volume; 播放key的音量，1-15,0为最大  基本用不到 置0即可
 pan;  左右声道权重，1-7 左，0或8表示中间，9-15右 用不到 置0
 note_type ; 为0时表示米粒，2表示LN的开头,3表示LN的结尾,4 不确定 可能表示  当wav和ogg同时存在时 辨别是不是ogg用的
 */
typedef struct header ojn_header;  //定义一个别名
#define MAXCOUNT 4095

@interface MGOJNHeader ()
@property (nonatomic, assign) int songid;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) float encode_version;
@property (nonatomic, assign) int genre;
@property (nonatomic, assign) float bpm;
@property (nonatomic, strong) NSArray<NSNumber *> *level;
@property (nonatomic, strong) NSArray<NSNumber *> *event_count;
@property (nonatomic, strong) NSArray<NSNumber *> *note_count;
@property (nonatomic, strong) NSArray<NSNumber *> *measure_count;
@property (nonatomic, strong) NSArray<NSNumber *> *package_count;
@property (nonatomic, assign) short old_encode_version;
@property (nonatomic, assign) short old_songid;
@property (nonatomic, copy) NSString *old_genre;
@property (nonatomic, assign) int bmp_size;
@property (nonatomic, assign) int old_file_version;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *noter;
@property (nonatomic, copy) NSString *ojm_file;
@property (nonatomic, assign) int cover_size;
@property (nonatomic, strong) NSArray<NSNumber *> *time;
@property (nonatomic, strong) NSArray<NSNumber *> *note_offset;
@property (nonatomic, assign) int cover_offset;
@end
@implementation MGOJNHeader

+ (instancetype)getO2m100OJN {
    ojn_header ojnInfoBuffer;//定义一个ojn_header的变量
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"o2ma100.ojn" ofType:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileName];
    
    MGOJNHeader *ojnheader = [[MGOJNHeader alloc] init];
    
    
    NSLog(@"%lu",sizeof(ojnheader));
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
        
        return ojnheader;
    }
    return nil;
}
@end
