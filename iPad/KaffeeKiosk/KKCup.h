//
//  KKCup.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/4/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKCup : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSNumber *price;
@property (nonatomic, copy) NSDate *date;

@end
