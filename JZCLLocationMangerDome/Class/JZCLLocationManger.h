//
//  JZCLLocationManger.h
//  JZCLLocationManger
//
//  Created by jack zhou on 13-8-22.
//  Copyright (c) 2013年 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef enum
{
    PTType_WGS_84,  //国际标准坐标
    PTType_GCJ_02,  //中国国测局坐标（火星坐标）此项仅在中国大陆有效 位置超出中国大陆，返回 国际标准坐标
    PTType_BD_09    //百度地图坐标
}PTType;    //返回坐标类型
typedef void(^LOCAL_SUCCESS_BLOCK)(CLLocation * newLocation,CLLocation * oldLocation,CLLocationManager * manager);
typedef void(^LOCAL_FAIL_BLOCK)(NSError * error);

@interface JZCLLocationManger : NSObject<CLLocationManagerDelegate>
@property(nonatomic,copy) LOCAL_SUCCESS_BLOCK success;
@property(nonatomic,copy) LOCAL_FAIL_BLOCK fail;
@property(nonatomic,unsafe_unretained) PTType type;

/**
 *	@brief	开始（开始后周期请求位置）
 *
 *	@param 	successBlock 	定位成功后的block
 *	@param 	failBlock 	定位失败后的block
 *	@param 	type 	返回的坐标类型
 *  @param  accuracy 定位精度 
 */
+ (void)startUpdateLocalSuccess:(LOCAL_SUCCESS_BLOCK)successBlock
                     failBlock:(LOCAL_FAIL_BLOCK)failBlock
                          type:(PTType)type
                      accuracy:(CLLocationAccuracy)accuracy;


/**
 *	@brief	停止定位
 */
+ (void)stop;


@end
