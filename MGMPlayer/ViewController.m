//
//  ViewController.m
//  MGMPlayer
//
//  Created by Labmen on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "ViewController.h"
#import "MGOJNHeader.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UIProgressView *songProgressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGOJNHeader *ojnHeader = [MGOJNHeader getO2m100OJN];
    
    NSLog(@"ojnheader Title :%@", ojnHeader.description);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playBtnClick:(id)sender {
    
}
- (IBAction)stopBtnClick:(id)sender {
    
}
- (IBAction)suspendBtnClick:(id)sender {
    
}

@end
