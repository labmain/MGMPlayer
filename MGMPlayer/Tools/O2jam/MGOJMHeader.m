//
//  MGOJMHeader.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "MGOJMHeader.h"
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
@implementation MGOJMHeader
+ (void)getMGOJMHeader {
    struct M30_header m30Header;
    
    struct M30_sample_header m30SampleHeader;
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"o2ma100.ojm" ofType:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileName];
    if (fileHandle) {
        
        NSData *OJNHanderData = [fileHandle readDataOfLength:sizeof(m30Header)];
        [OJNHanderData getBytes:&m30Header length:sizeof(m30Header)];
        
        NSLog(@"%d",m30Header.encryption_flag);
        
        for (int i = 0; i < m30Header.sample_count; i++) {
            
            NSData *M30SampleData = [fileHandle readDataOfLength:52];
            if (M30SampleData == nil) {
                break;
            }
            [M30SampleData getBytes:&m30SampleHeader length:52];
            
            NSData *OGGData = [fileHandle readDataOfLength:m30SampleHeader.sample_size];
            NSLog(@"%d",m30SampleHeader.sample_size);
            
            NSUInteger len = [OGGData length];
            Byte *byteData = (Byte*)[OGGData bytes];
            
            NSString *nami = @"nami";
            NSData *namidata = [nami dataUsingEncoding: NSUTF8StringEncoding];
            Byte *namiByte = (Byte *)[namidata bytes];
            
            for(int i=0; i+3 < len;i+=4)
            {
                byteData[i+0] ^= namiByte[0];
                byteData[i+1] ^= namiByte[1];
                byteData[i+2] ^= namiByte[2];
                byteData[i+3] ^= namiByte[3];
            }
            
            NSData *oggData = [NSData dataWithBytes:byteData length:len];
            
            int value = m30SampleHeader.ref;
            if (m30SampleHeader.codec_code == 0) {
                value += 1000;
            }
            NSString *fileName = [NSString stringWithFormat:@"%d",value];
            NSString *filePath = [NSString stringWithFormat:@"Data/OGG/%@.ogg",fileName];
            [oggData writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:filePath] atomically:YES];
        }
    }

}
@end
