//
//  MGOJMHeader.h
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import <Foundation/Foundation.h>
struct M30_header {
    char signature[4]; // "M30"
    int file_format_version;
    int encryption_flag;
    int sample_count; // ojm 声音文件的数量
    int samples_offset; // 启动的位置
    int payload_size; // the payload_size is the size of the rest of the file, usually total_file_size – 28(header), in bytes.
    int padding;
};
struct M30_sample_header {
    char sample_name[32];
    int sample_size; // is the size, in bytes, of the actual sample data.
    short codec_code; //  there are 2 types(so far) on the M30, 0 means background sound(note type 4, M###), 5 means normal sound (W###).
    short unk_fixed;
    int unk_music_flag;
    short ref; // this is correspondent to the note ref, that means the sample ref X will be played when the note ref X is tapped.
    short unk_zero;
    int pcm_samples; // the total pcm samples on the ogg.
};
/*
 encryption_flag:
 1 – scramble1
 2 – scramble2
 4 – decode
 8 – decrypt
 16 – nami
 */
#define kOggLocalPath @"/Data/OGG"
@interface OJMHeader : NSObject

@end

