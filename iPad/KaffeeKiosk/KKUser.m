//
//  KKUser.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/4/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import "KKUser.h"

@implementation KKUser

@synthesize userId, name, email, thumbnailFilename, balance, totalCups;

- (NSString *)formattedBalance
{
    return [NSString stringWithFormat:@"%0.2f EUR", [balance floatValue]];
}

- (BOOL)isValid
{
    return ![self.name isEqualToString:@""] && ![self.email isEqualToString:@""];
}

@end
