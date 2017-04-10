//
//  ViewController.m
//  HDFScrollTableScene
//
//  Created by hdf on 2017/4/10.
//  Copyright © 2017年 hdf. All rights reserved.
//

#import "ViewController.h"
#import "DZNSegmentedControl.h"
#import "BackgroundCollectionCell.h"
#import "BaseSubScene.h"
#import "FirstSubScene.h"
#import "ScondSubScene.h"
#import "ThirdSubScene.h"
#import "FourthSubScene.h"

static NSString *const backgroundCellId = @"backgroundCellId";
#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<DZNSegmentedControlDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)DZNSegmentedControl *segment;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong)NSArray *titlesArray;
/** 控制器对应的字典 */
@property (nonatomic, strong) NSMutableDictionary *controllersDict;
/** 控制器缓存池 */
@property (nonatomic, strong) NSMutableDictionary *controllerCache;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_segment)
    {
        _segment = [[DZNSegmentedControl alloc] initWithItems:self.titlesArray];
        _segment.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40);
        _segment.delegate = self;
        _segment.selectedSegmentIndex = 0;
        _segment.bouncySelectionIndicator = NO;
        _segment.tintColor = [UIColor blueColor];
        _segment.showsCount = NO;
        _segment.height = 40.f;
        _segment.hairlineColor = [UIColor clearColor];
        [_segment addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    [self.view addSubview:_segment];
    [self.view addSubview:self.collectionView];
}

-(void)selectedSegment:(id)sender{
    
    DZNSegmentedControl *segmet = (DZNSegmentedControl *)sender;
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:segmet.selectedSegmentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}


- (NSMutableDictionary *)controllerCache {
    if (_controllerCache == nil) {
        _controllerCache = [[NSMutableDictionary alloc] init];
    }
    return _controllerCache;
}

- (NSMutableDictionary *)controllersDict {
    if (_controllersDict == nil) {
        NSMutableArray *objectsArray = [[NSMutableArray alloc] initWithObjects:[FirstSubScene class], [ScondSubScene class], [ThirdSubScene class],[FourthSubScene class], nil];
        NSMutableArray *keysArray = [[NSMutableArray alloc] initWithObjects:@"全部",@"未签收",@"已签收",@"回收站",nil];
        _controllersDict = [[NSMutableDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
    }
    return _controllersDict;
}

/**
 *  标题数组
 */
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"全部",@"未签收",@"已签收",@"回收站"];
    }
    return _titlesArray;
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        // 创建一个流水布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //cell间距
        flowLayout.minimumInteritemSpacing = 0;
        //cell行距
        flowLayout.minimumLineSpacing = 1;
        // 修改属性
        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-40);
        // 创建collectionView
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40+64, self.view.bounds.size.width, self.view.bounds.size.height-40) collectionViewLayout:flowLayout];
        // 注册一个cell
        [collectionView registerClass:[BackgroundCollectionCell class] forCellWithReuseIdentifier:backgroundCellId];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.bounces = NO;
        // 设置数据源对象
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled =NO;
        _collectionView = collectionView;
    }
    
    return _collectionView;
}


#pragma mark collectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titlesArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BackgroundCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:backgroundCellId forIndexPath:indexPath];
    BaseSubScene *showsVc = [self showsVc:self.titlesArray[indexPath.item]];
    cell.showsVc = showsVc;
    return cell;
}
/**
 *  根据文字获得对应的需要显示控制器
 */
- (BaseSubScene *)showsVc:(NSString *)titile {
    BaseSubScene *showsVc = self.controllerCache[titile];
    if (showsVc == nil) {
        // 创建控制器
        // 所有
        BaseSubScene *typeVc = [[[self.controllersDict objectForKey:titile] alloc] init];
        // 将产品列表控制器添加到缓冲池中
        [self.controllerCache setObject:typeVc forKey:titile];
        return typeVc;
    }
    return showsVc;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 一些临时变量
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat offsetX = self.collectionView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    [_segment setSelectedSegmentIndex:index animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
}



#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}


-(void)setSelecttheIndex:(int)selecttheIndex
{
    [_segment setSelectedSegmentIndex:selecttheIndex animated:YES];
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:selecttheIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}


@end
