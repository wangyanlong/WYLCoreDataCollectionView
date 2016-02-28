//
//  ComicCollectionViewCell.m
//  WYLCoreDataCollectionView
//
//  Created by 王老师 on 16/2/28.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "ComicCollectionViewCell.h"
static int iii = 0;
@implementation ComicCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.label = [[UILabel alloc]initWithFrame:self.bounds];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        self.contentView.backgroundColor = [UIColor grayColor];
        NSLog(@"%d",iii);
        iii++;
        
    }
    
    return self;
}

@end
