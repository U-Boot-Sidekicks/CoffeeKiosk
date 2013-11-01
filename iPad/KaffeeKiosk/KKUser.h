//
//  KKUser.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/4/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *thumbnailFilename;
@property (nonatomic, copy) NSNumber *balance;
@property (nonatomic, copy) NSNumber *totalCups;

- (NSString *)formattedBalance;

- (BOOL)isValid;

@end
