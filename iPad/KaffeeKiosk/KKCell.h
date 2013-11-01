//
//  KKCell.h
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/2/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSTCollectionView.h>
#import "KKUser.h"

@class KKCell;

@protocol KKCellSelectionDelegate <NSObject>

- (void)isSelectedKKCell:(KKCell *)kkCell;

@end


@interface KKCell : PSUICollectionViewCell

@property (nonatomic, assign) KKUser *user;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *labelEURO;
@property (strong, nonatomic) IBOutlet UILabel *labelCups;

@property (nonatomic, weak) id <KKCellSelectionDelegate> delegate;

@end
