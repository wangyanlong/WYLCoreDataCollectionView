//
//  WYLCoreDataCollectionView.m
//  WYLCoreDataCollectionView
//
//  Created by 王老师 on 16/2/25.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import "WYLCoreDataCollectionView.h"

@interface WYLCoreDataCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NSFetchedResultsControllerDelegate>

/*!
 *  when tableview is none datasource , shwo this view on window
 */
@property (nonatomic,strong)UIView *noneDataView;

@property (nonatomic,strong) NSMutableArray *sectionChanges;
@property (nonatomic,strong) NSMutableArray *itemChanges;

@end

@implementation WYLCoreDataCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.batchSize = 10;
        self.bounces = NO;
        
        [self addObserver:self forKeyPath:@"isShowNoneView" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    BOOL new = [[change objectForKey:@"new"] boolValue];
    
    if (new) {
        [self addSubview:self.noneDataView];
    }else{
        [self.noneDataView removeFromSuperview];
    }
    
}

- (UIView *)noneDataView{
    
    if (_noneDataView) {
        return _noneDataView;
    }
    
    _noneDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _noneDataView.backgroundColor = [UIColor whiteColor];
    [_noneDataView addSubview:self.noneView];
    
    return _noneDataView;
    
}

#pragma mark - fetch delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    _sectionChanges = [[NSMutableArray alloc] init];
    _itemChanges = [[NSMutableArray alloc] init];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self performBatchUpdates:^{
        
        for (NSDictionary *change in _sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                
                if (type == NSFetchedResultsChangeInsert) {
                    [self insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                }else if (type == NSFetchedResultsChangeDelete){
                    [self deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                }
                                
            }];
        }
        
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        _sectionChanges = nil;
        _itemChanges = nil;
    }];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    
    change[@(type)] = @(sectionIndex);
    
    [_sectionChanges addObject:change];
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    
    [_itemChanges addObject:change];
}


#pragma mark - set up

- (void)createFetchCollectionViewInfomation{
    [self configureFetch];
    [self performFetch];
}

- (void)performFetch{
    
    if (self.frc) {
        
        [self.context performBlockAndWait:^{
            
            if (![self.frc performFetch:nil]) {
                NSLog(@"Fetch error");
            }
            [self reloadData];
        }];
        
    }else{
        NSLog(@"没有创建 frc");
    }
    
}

- (void)configureFetch{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.context];
    
    [request setEntity:entity];
    
    [request setPredicate:self.predicate];
    
    if (self.sortArray.count > 0) {
        [request setSortDescriptors:self.sortArray];
    }
    
    [request setFetchBatchSize:self.batchSize];
    
    self.frc = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:self.sectionKey cacheName:self.cacheName];
    
    self.frc.delegate = self;
    
}

#pragma collection Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.frc sections].count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    WYLCoreDataCollectionView *cv = (WYLCoreDataCollectionView *)collectionView;
    
    NSInteger num = [[self.frc.sections objectAtIndex:section] numberOfObjects];
    
    if (num > 0 && cv.isShowNoneView){
        cv.isShowNoneView = NO;
    }else if (num == 0 && !cv.isShowNoneView){
        cv.isShowNoneView = YES;
    }
    
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
