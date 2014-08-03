//
//  UILocalNotification+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 18/05/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADLembrete.h"

#define LocalNotificationDomain @"mobi.fabionogueira.alldayDO"

@interface UILocalNotification (ADToolkitAdditions)

+ (instancetype)defaultLocalNotificationWith:(ADLembrete *)lembrete;

- (NSDate *)myNextFireDateAfterDate:(NSDate *)afterDate;

@end
