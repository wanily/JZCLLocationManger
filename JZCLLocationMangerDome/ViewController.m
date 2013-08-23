//
//  ViewController.m
//
//  Created by jack zhou on 13-8-22.
//  Copyright (c) 2013年 JZ. All rights reserved.
//

#import "ViewController.h"
#import "JZCLLocationManger.h"
@interface ViewController ()
@property(nonatomic,weak) IBOutlet UILabel * infoLable;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self gcj02];
}

- (void)gcj02
{
    _infoLable.text = @"正在定位...";
    [JZCLLocationManger startUpdateLocalSuccess:^(CLLocation * new,
                                                  CLLocation * old,
                                                  CLLocationManager * manager)
    {
        _infoLable.text = [NSString stringWithFormat:@"国测局坐标：\n %f,%f",
                           new.coordinate.latitude,
                           new.coordinate.longitude];
    } failBlock:^(NSError * error){
        
    } type:PTType_GCJ_02 accuracy:kCLLocationAccuracyBest];
}

- (void)wgs84
{
    _infoLable.text = @"正在定位...";
    [JZCLLocationManger startUpdateLocalSuccess:^(CLLocation * new,
                                                  CLLocation * old,
                                                  CLLocationManager * manager)
     {
         _infoLable.text = [NSString stringWithFormat:@"世界标准坐标：\n %f,%f",
                            new.coordinate.latitude,
                            new.coordinate.longitude];
     } failBlock:^(NSError * error){
         
     } type:PTType_WGS_84 accuracy:kCLLocationAccuracyBest];
}

- (void)bd09
{
    _infoLable.text = @"正在定位...";
    [JZCLLocationManger startUpdateLocalSuccess:^(CLLocation * new,
                                                   CLLocation * old,
                                                  CLLocationManager * manager)
     {
         _infoLable.text = [NSString stringWithFormat:@"百度坐标：\n %f,%f",
                            new.coordinate.latitude,
                            new.coordinate.longitude];
     } failBlock:^(NSError * error){
         
     } type:PTType_BD_09 accuracy:kCLLocationAccuracyBest];
}

- (IBAction)typeChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self gcj02];
            break;
        case 1:
            [self wgs84];
            break;
        case 2:
            [self bd09];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
