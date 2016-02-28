//
//  WYLCoreDataCollectionView.h
//  WYLCoreDataCollectionView
//
//  Created by 王老师 on 16/2/25.
//  Copyright © 2016年 wyl. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface WYLCoreDataCollectionView : UICollectionView<NSFetchedResultsControllerDelegate>

/*!
 *  Default FetchedResultsController.Used to coordinate with tableview query data
 */
@property (nonatomic,strong)NSFetchedResultsController *frc;

/*!
 *  Required - Used to check the additions and deletions to the managedObject
 */
@property (nonatomic,strong)NSManagedObjectContext *context;

/*!
 *  Required - FetchedResultsController's batchSize , set the number of each load
 */
@property (nonatomic,assign)NSInteger batchSize;

/*!
 *  Required - FetchedResultsController's entityName , query the data you want through entityName
 */
@property (nonatomic,strong)NSString *entityName;

/*!
 *  Optional - FetchedResultsController's cacheName , set up the data cache to improve the query efficiency.
 */
@property (nonatomic,strong)NSString *cacheName;

/*!
 *  Optional - FetchedResultsController's sectionKey , set up tableView's section
 */
@property (nonatomic,strong)NSString *sectionKey;

/*!
 *  Required - NSFetchRequest's sortArray , set the rules for the query
 */
@property (nonatomic,strong)NSArray *sortArray;

/*!
 *  Optional - NSFetchRequest's predicate , you can set query rules by predicate
 */
@property (nonatomic,strong)NSPredicate *predicate;

/*!
 *  when collectionView is none datasource , isShowNoneView is YES. default NO
 */
@property (nonatomic,assign)BOOL isShowNoneView;

/*!
 *  Custom ImageView . Show this view on noneDataView.Show the information you want to convey to the user.
 */
@property (nonatomic,strong)UIView *noneView;

/*!
 *  set up FetchTableView
 */
- (void)createFetchCollectionViewInfomation;

@end
