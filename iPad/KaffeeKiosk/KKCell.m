//
//  KKCell.m
//  KaffeeKiosk
//
//  Created by Alex Lobunets on 12/2/12.
//  Copyright (c) 2012 Fraunhofer FIT. All rights reserved.
//

#import "KKCell.h"
#import "KKCustomCellBackground.h"

@implementation KKCell

@synthesize delegate;
@synthesize user;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view
        KKCustomCellBackground *backgroundView = [[KKCustomCellBackground alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView = backgroundView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected && [delegate respondsToSelector:@selector(isSelectedKKCell:)] ) {
        [delegate isSelectedKKCell:self];
    }
}

@end
