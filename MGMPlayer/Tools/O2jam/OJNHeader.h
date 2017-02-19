//
//  OJNHeader.h
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OJNHeader : NSObject
@property (nonatomic, assign) int songid;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) float encode_version;
@property (nonatomic, assign) int genre;
/**
 初始BPM
 */
@property (nonatomic, assign) float bpm;
@property (nonatomic, strong) NSArray<NSNumber *> *level;
@property (nonatomic, strong) NSArray<NSNumber *> *event_count;
@property (nonatomic, strong) NSArray<NSNumber *> *note_count;
/**
 3个难度各自有多少小节数
 */
@property (nonatomic, strong) NSArray<NSNumber *> *measure_count;
/**
 标记包的数量 3难度，package代表一个小节中的某一列
 */
@property (nonatomic, strong) NSArray<NSNumber *> *package_count;
@property (nonatomic, assign) short old_encode_version;
@property (nonatomic, assign) short old_songid;
@property (nonatomic, copy) NSString *old_genre;
@property (nonatomic, assign) int bmp_size;
@property (nonatomic, assign) int old_file_version;
/**
 歌名
 */
@property (nonatomic, copy) NSString *title;
/**
 作曲家名
 */
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *noter;
@property (nonatomic, copy) NSString *ojm_file;
/**
 这是封面图片的大小，以字节为单位
 */
@property (nonatomic, assign) int cover_size;
/**
 3 难度歌曲时长 单位是秒
 */
@property (nonatomic, strong) NSArray<NSNumber *> *time;
/**
 容易，普通，困难 的 note 位置
 */
@property (nonatomic, strong) NSArray<NSNumber *> *note_offset;
/**
 jpg首地址  cover_offset+cover_size: bmp首地址  ojn whole file size: bmp尾地址
 */
@property (nonatomic, assign) int cover_offset;


+ (OJNHeader *)getOJNHeader;

@end

@class OJNPackageHeader;
@class OJNNoteEvent;
@interface OJNHeaderNotePackage : NSObject
@property (nonatomic, strong) OJNPackageHeader *packageHeader;
@property (nonatomic, strong) NSArray<OJNNoteEvent *> *noteEventArray;
@end
@interface OJNPackageHeader : NSObject

/**
 标明这个package是属于第几小节线
 */
@property (nonatomic, assign) int measure;

/**
 标明这个package是第几列的  具体取值见下面
 */
@property (nonatomic, assign) short channel;

/**
 标明这个package 使用的是多少格线.
 */
@property (nonatomic, assign) short events;
@end

@interface OJNNoteEvent : NSObject
/**
  value 表示Key音列表的索引值 比如这个值为17 那么key表索引值=17的地方如果有放一个"abc.ogg"的音频key 那么击打时就会自动播放
 */
@property (nonatomic, assign) short value;

/**
 volume; 播放key的音量，1-15,0为最大  基本用不到 置0即可
 */
@property (nonatomic, assign) short volume;

/**
 左右声道权重，1-7 左，0或8表示中间，9-15右 用不到 置0
 */
@property (nonatomic, assign) short pan;

/**
 为0时表示米粒，2表示LN的开头,3表示LN的结尾,4 不确定 可能表示  当wav和ogg同时存在时 辨别是不是ogg用的
 */
@property (nonatomic, assign) short note_type;
@end

