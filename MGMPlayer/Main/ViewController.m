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
#import "OJMDecode.h"

#import "IDZAQAudioPlayer.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UIProgressView *songProgressView;
@property (nonatomic, strong) id<IDZAudioPlayer> player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    OJNDecode *ojnDecode = [OJNDecode ojnDecodeWithSongID:@""];
    OJMDecode *ojmDecode = [OJMDecode getOJMSounds];
    
    OJMSoundPart *backgroundMuisc = [ojmDecode.soundArray lastObject];
    
    NSError* error = nil;
    IDZOggVorbisFileDecoder* decoder = [[IDZOggVorbisFileDecoder alloc] initWithContentsOfURL:[backgroundMuisc getSoundPartUrl]error:&error];
    
    if (!error) {
        self.player = [[IDZAQAudioPlayer alloc] initWithDecoder:decoder error:nil];
        
        [self.player prepareToPlay];
    }
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
