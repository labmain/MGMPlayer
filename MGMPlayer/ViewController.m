//
//  ViewController.m
//  MGMPlayer
//
//  Created by 王顺 on 2017/2/17.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;
@property (weak, nonatomic) IBOutlet UIProgressView *songProgressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coverImgV.layer.cornerRadius = 150;
    self.coverImgV.layer.masksToBounds = YES;
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
