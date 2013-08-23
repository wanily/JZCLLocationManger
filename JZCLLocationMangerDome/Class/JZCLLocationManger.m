//
//  JZCLLocationManger.m
//  JZCLLocationManger
//
//  Created by jack zhou on 13-8-22.
//  Copyright (c) 2013年 JZ. All rights reserved.
//

#import "JZCLLocationManger.h"
#import "JZLocationConverter.h"
@interface JZCLLocationManger()
@property(nonatomic,strong) CLLocationManager * manger;
@end
@implementation JZCLLocationManger
static JZCLLocationManger* shareJZCLLocationManger;
+ (JZCLLocationManger*)shareCLLocationManager {
	@synchronized(self) {
		if(!shareJZCLLocationManger) {
			shareJZCLLocationManger = [[[self class] alloc] init];
            shareJZCLLocationManger.manger = [[CLLocationManager alloc]init];
            shareJZCLLocationManger.manger.delegate = shareJZCLLocationManger;
        }
	}
	return shareJZCLLocationManger;
}

+ (void)stop
{
    [[JZCLLocationManger shareCLLocationManager].manger stopUpdatingLocation];
}

+ (void)startUpdateLocalSuccess:(LOCAL_SUCCESS_BLOCK)successBlock
                     failBlock:(LOCAL_FAIL_BLOCK)failBlock
                          type:(PTType)type
                      accuracy:(CLLocationAccuracy)accuracy
{
    [JZCLLocationManger stop];
    JZCLLocationManger * jzManager = [JZCLLocationManger shareCLLocationManager];
    jzManager.manger.desiredAccuracy = accuracy;
    jzManager.success = successBlock;
    jzManager.type = type;
    jzManager.fail = failBlock;
    [jzManager.manger startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D ptNew;
    CLLocationCoordinate2D ptOld;
    switch (_type) {
        case PTType_WGS_84:
            ptNew = newLocation.coordinate;
            ptOld = oldLocation.coordinate;
            break;
        case PTType_BD_09:
            ptNew = [JZLocationConverter wgs84ToBd09:newLocation.coordinate];
            ptOld = [JZLocationConverter wgs84ToBd09:oldLocation.coordinate];
            break;
        case PTType_GCJ_02:
            ptNew = [JZLocationConverter wgs84ToGcj02:newLocation.coordinate];
            ptOld = [JZLocationConverter wgs84ToGcj02:oldLocation.coordinate];
            break;
        default:
            break;
    }
    CLLocation * cllocationNew = [[CLLocation alloc]initWithCoordinate:ptNew
                                                              altitude:newLocation.altitude
                                                    horizontalAccuracy:newLocation.horizontalAccuracy
                                                      verticalAccuracy:newLocation.verticalAccuracy
                                                                course:newLocation.course
                                                                 speed:newLocation.speed
                                                             timestamp:newLocation.timestamp];
    
    CLLocation * cllocationOld = [[CLLocation alloc]initWithCoordinate:ptOld
                                                              altitude:oldLocation.altitude
                                                    horizontalAccuracy:oldLocation.horizontalAccuracy
                                                      verticalAccuracy:oldLocation.verticalAccuracy
                                                                course:oldLocation.course
                                                                 speed:oldLocation.speed
                                                             timestamp:oldLocation.timestamp];
    if (_success) {
        _success(cllocationNew,cllocationOld,manager);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [JZCLLocationManger stop];
    if (_fail) {
        _fail(error);
    }
}

@end
