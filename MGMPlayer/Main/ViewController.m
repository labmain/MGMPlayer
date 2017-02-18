//
//  ViewController.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "ViewController.h"
#import "MGOJNHeader.h"
#import "MGOJMHeader.h"
#import "MGOJNDecode.h"

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
    
        [MGOJMHeader getMGOJMHeader];
    
    
    MGOJNDecode *ojnDecode = [MGOJNDecode ojnDecodeWithSongID:nil];
    NSLog(@"%@",ojnDecode.ojnHeader.title);
    NSError* error = nil;
    NSURL* oggUrl = [[NSBundle mainBundle] URLForResource:@"Rondo_Alla_Turka" withExtension:@".ogg"];
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:oggUrl error:&error];
    NSLog(@"Ogg Vorbis file duration is %g", decoder.duration);
    self.player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
    
    [self.player prepareToPlay];
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
