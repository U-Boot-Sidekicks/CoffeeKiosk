//
//  KKViewController.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/2/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import <PSTCollectionView.h>
#import "KKCell.h"

@interface KKViewController : PSUICollectionViewController <KKCellSelectionDelegate> {
    NSInteger lastUsedFilter;
}

@property (strong, nonatomic) NSArray *users;

- (void)reloadUsersWithFilter:(NSInteger)filterNumber;

@end
