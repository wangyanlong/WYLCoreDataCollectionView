//
//  TComicCollectionTableView.m
//  NSFetchedRequestController_TableViewDemo
//
//  Created by 王老师 on 15/9/15.
//  Copyright (c) 2015年 wyl. All rights reserved.
//
#import "ComicCollectionViewCell.h"
#import "ComicCollectionView.h"
#import "Comic.h"

@implementation ComicCollectionView

- (ComicCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ComicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    Comic *c = [self.frc objectAtIndexPath:indexPath];
    
    cell.label.text = c.name;
    
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
