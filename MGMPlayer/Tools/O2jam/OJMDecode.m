//
//  OJMDecode.m
//  MGMPlayer
//
//  Created by 王顺 on 2017/2/19.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "OJMDecode.h"
#import "OJMHeader.h"

@implementation OJMDecode

+ (OJMDecode *)getOJMSounds {
        struct M30_header m30Header;
        struct M30_sample_header m30SampleHeader;
        
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"o2ma100.ojm" ofType:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:fileName];
        if (fileHandle) {
            
            OJMDecode *ojmDecode = [[OJMDecode alloc] init];
            
            NSData *OJNHanderData = [fileHandle readDataOfLength:sizeof(m30Header)];
            [OJNHanderData getBytes:&m30Header length:sizeof(m30Header)];
            
            NSMutableArray<OJMSoundPart *> *soundsArray = [NSMutableArray arrayWithCapacity:m30Header.sample_count];
            
            for (int i = 0; i < m30Header.sample_count; i++) {
                NSData *M30SampleData = [fileHandle readDataOfLength:52];
                if (M30SampleData == nil) {
                    break;
                }
                [M30SampleData getBytes:&m30SampleHeader length:52];
                
                int value = m30SampleHeader.ref;
                
                OJMSoundPart *soundPart = [[OJMSoundPart alloc] init];
                soundPart.ojmLocalPath = fileName;
                soundPart.soundPartID = value;
                soundPart.soundStartOffset = fileHandle.offsetInFile;
                
                soundPart.codec_code = m30SampleHeader.codec_code;
                
                [fileHandle readDataOfLength:m30SampleHeader.sample_size];
                
                soundPart.soundEndOffset = fileHandle.offsetInFile;
                
                [soundsArray addObject:soundPart];
                
            }
            ojmDecode.soundArray = [soundsArray copy];
            
            [fileHandle closeFile];
            return ojmDecode;
        }
        
    return nil;
}

@end

@implementation OJMSoundPart


- (NSURL *)getSoundPartUrl {
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.ojmLocalPath];
    [fileHandle seekToFileOffset:self.soundStartOffset];
    NSData *OGGData = [fileHandle readDataOfLength:self.soundEndOffset - self.soundStartOffset];
    //    NSLog(@"%d",m30SampleHeader.sample_size);
    
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
    
    // 背景音乐
    if (self.codec_code == 0) {
        self.soundPartID += 1000;
    }
    NSString *fileName = [NSString stringWithFormat:@"%d",self.soundPartID];
    NSString *filePath = [NSString stringWithFormat:@"/Documents/Data/OGG/%@.ogg",fileName];
    
    // 检查路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:kOggLocalPath];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!exist) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:kOggLocalPath];
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *writeFilePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    [oggData writeToFile:writeFilePath atomically:YES];
    NSURL *soundPartPath = [[NSURL alloc] initFileURLWithPath:writeFilePath];
    return soundPartPath;
}
@end
