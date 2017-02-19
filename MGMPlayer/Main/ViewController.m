//
//  ViewController.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "ViewController.h"
#import "OJNHeader.h"
#import "OJMHeader.h"
#import "OJNDecode.h"

#import "IDZAQAudioPlayer.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UIProgressView *songProgressView;
@property (nonatomic, strong) id<IDZAudioPlayer> player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    MGOJNHeader *ojnHeader = [MGOJNHeader getMGOJNHeader];
    
//    [MGOJNHeader getMGOJNHeader];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MGOJMHeader getMGOJMHeader];
        OJNDecode *ojnDecode = [OJNDecode ojnDecodeWithSongID:nil];
        NSLog(@"%@",ojnDecode.ojnHeader.title);
    });
//    NSError* error = nil;
//    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:@"Rondo_Alla_Turka" withExtension:@".ogg"];
//    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:oggUrl error:&error];
//    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
//    self.player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
//    
//    [self.player prepareToPlay];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playBtnClick:(id)sender {
    [self.player play];
    
}
- (IBAction)stopBtnClick:(id)sender {
    [self.player stop];
    
}
- (IBAction)suspendBtnClick:(id)sender {
    [self.player pause];
    
}

@end
