//
//  ViewController.m
//  WYLCoreDataCollectionView
//
//  Created by 王老师 on 16/2/25.
//  Copyright © 2016年 wyl. All rights reserved.
//
#import "Comic.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "ComicCollectionView.h"
#import "ComicCollectionViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(0, 20, 50, 50);
    [add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [add setTitle:@"add" forState:UIControlStateNormal];
    add.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:add];
    
    UIButton *remove = [UIButton buttonWithType:UIButtonTypeCustom];
    remove.frame = CGRectMake(70, 20, 80, 50);
    [remove addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [remove setTitle:@"remove" forState:UIControlStateNormal];
    remove.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:remove];
    
    UIButton *update = [UIButton buttonWithType:UIButtonTypeCustom];
    update.frame = CGRectMake(170, 20, 80, 50);
    [update addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    [update setTitle:@"update" forState:UIControlStateNormal];
    update.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    [self.view addSubview:update];
    
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width / 4, self.view.frame.size.height / 4);
    
    CGFloat y = 120;
    
    ComicCollectionView *ctv = [[ComicCollectionView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height-y) collectionViewLayout:flowLayout];
    ctv.backgroundColor = [UIColor colorWithRed:(arc4random()%255/255.0) green:(arc4random()%255/255.0) blue:(arc4random()%255/255.0) alpha:1];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"comicID" ascending:YES];
    ctv.context = app.managedObjectContext;
    ctv.sortArray = @[sortDescriptor];
    ctv.entityName = @"Comic";
    [ctv createFetchCollectionViewInfomation];
    
    [ctv registerClass:[ComicCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];

    [self.view addSubview:ctv];
    
}

static int i = 0;

- (void)add{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Comic *c = [NSEntityDescription insertNewObjectForEntityForName:@"Comic" inManagedObjectContext:app.managedObjectContext];
    c.name = [NSString stringWithFormat:@"%d",i];
    c.comicID = @(i);
    
    [app.managedObjectContext save:nil];
    i++;
}

- (void)remove{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *r = [NSFetchRequest fetchRequestWithEntityName:@"Comic"];
    NSArray *arr = [app.managedObjectContext executeFetchRequest:r error:nil];
    Comic *c = [arr firstObject];
    [app.managedObjectContext deleteObject:c];
    [app.managedObjectContext save:nil];
}

- (void)update{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *r = [NSFetchRequest fetchRequestWithEntityName:@"Comic"];
    NSArray *arr = [app.managedObjectContext executeFetchRequest:r error:nil];
    Comic *c = [arr firstObject];
    c.name = [NSString stringWithFormat:@"%d",i*100];
    [app.managedObjectContext save:nil];
    i++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
