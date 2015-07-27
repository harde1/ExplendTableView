//
//  ViewController.m
//  ExpandTableView
//
//  Created by cong on 15/7/27.
//  Copyright (c) 2015年 cong. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ViewFrameGeometry.h"

#define KEY_DICT_DATASOURCE @"KEY_DICT_DATASOURCE"
#define KEY_DICT_ALREADY @"KEY_DICT_ALREADY"
#define RESULTID @"RESULTID"
#define KEY_DICT3 @"key_dict3"

#define KEY_DICT_HEAD @"key_dict_head"

#define wImage(str) [UIImage imageNamed:(str)]



//5.rgb颜色转换（16进制->10进制）

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//可展开的tableview
@property(nonatomic) NSMutableArray *headerViews; // of UIView
@property(nonatomic) NSUInteger selectedSection; //当前选择的section
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, strong) NSMutableDictionary *alreadyDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
      _alreadyDictionary = [@{} mutableCopy];
    _selectedSection = -1;
    _dataSource = @[@{KEY_DICT_DATASOURCE:@[
  @{KEY_DICT_ALREADY:@"aaaaaa1",RESULTID:@"bbbb1",@"key_dict3":@"ccccc"},
  @{KEY_DICT_ALREADY:@"aaaaaa2",RESULTID:@"bbbb2",@"key_dict3":@"ccccc"},
  @{KEY_DICT_ALREADY:@"aaaaaa3",RESULTID:@"bbbb3",@"key_dict3":@"ccccc"}
  ],KEY_DICT_HEAD:@"我是头1"
                      
                      },
  @{KEY_DICT_DATASOURCE:@[
  @{KEY_DICT_ALREADY:@"aaaaa21",RESULTID:@"bbbb21",@"key_dict3":@"ccccc"},
  @{KEY_DICT_ALREADY:@"aaaaa22",RESULTID:@"bbbb22",@"key_dict3":@"ccccc"},
  @{KEY_DICT_ALREADY:@"aaaaa23",RESULTID:@"bbbb23",@"key_dict3":@"ccccc"}]
    ,KEY_DICT_HEAD:@"我是头2"
    }];

    

}



// tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataSource.count > 0) {
        return [_dataSource count];
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.selectedSection == section) {
        return [_dataSource[section][KEY_DICT_DATASOURCE] count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ExpandCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                    forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"tick_box_unselected"];
    
    cell.imageView.tag = 110;//标识起来好改图片
    
    cell.textLabel.text =
    _dataSource[indexPath.section][KEY_DICT_DATASOURCE][indexPath.row][KEY_DICT_ALREADY];
    
    
    if ([[_alreadyDictionary allKeys] containsObject:_dataSource[indexPath.section][KEY_DICT_DATASOURCE][indexPath.row][KEY_DICT_ALREADY]]) {
        //包含
        cell.imageView.image = [UIImage imageNamed:@"tick_box_selected"];
        
    } else {
        //不包含
        cell.imageView.image = [UIImage imageNamed:@"tick_box_unselected"];
        
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = _dataSource[indexPath.section][KEY_DICT_DATASOURCE][indexPath.row][KEY_DICT_ALREADY];
    NSString *resultid = _dataSource[indexPath.section][KEY_DICT_DATASOURCE][indexPath.row][RESULTID];//目的值
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *tick_box = (UIImageView *) [cell.contentView viewWithTag:110];
  
    
    if ([[_alreadyDictionary allKeys] containsObject:key]) {
        [_alreadyDictionary removeObjectForKey:key];
        tick_box.image = [UIImage imageNamed:@"tick_box_unselected"];
    } else {
        tick_box.image = [UIImage imageNamed:@"tick_box_selected"];
        [_alreadyDictionary setObject:resultid forKey:key];
    }
    
      NSLog(@"didSelectRowAtIndexPath:%@", key);
    NSLog(@"已经选择的cell的resultid字段是：%@",_alreadyDictionary);
    
    
}

- (void)tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectZero];
    sectionView.height =
    [self tableView:tableView heightForHeaderInSection:section];
    sectionView.width = tableView.width;
    self.headerViews[section] = sectionView;
    
    UITapGestureRecognizer *tapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSection:)];
    [sectionView addGestureRecognizer:tapGR];
    
    UILabel *label_text = [[UILabel alloc] init];
    label_text.text = _dataSource[section][KEY_DICT_HEAD];
                      
    [label_text sizeToFit];
    label_text.center = sectionView.center;
    [sectionView addSubview:label_text];
    
    UIView *lineV =
    [[UIView alloc] initWithFrame:CGRectMake(0, 59, tableView.width, 1)];
    lineV.backgroundColor = [UIColor yellowColor]; //[UIColor colorWithRed:225./255
    //green:225./255 blue:225./255 alpha:1.];
    [sectionView addSubview:lineV];
    
    UIImageView *iv_right = [[UIImageView alloc] init];
    [sectionView addSubview:iv_right];
    iv_right.tag = 111;
    iv_right.width = 20;
    iv_right.height = 20;
    iv_right.center = sectionView.center;
    iv_right.left = 10;
    
  
    if (section != _selectedSection) {
        iv_right.image = wImage(@"iv_expand_add");
    } else {
        iv_right.image = wImage(@"iv_expand_jian");
    }
    

    if (section % 2 == 0) {
        sectionView.backgroundColor = [UIColor whiteColor];
    } else {
        sectionView.backgroundColor = UIColorFromRGB(0xf9fcff);
    }
    
    return sectionView;
}

//展开section二级目录 的 操作
- (void)showSection:(UITapGestureRecognizer *)tapGR {
    NSLog(@"展开二级菜单,ready");
    
    NSUInteger index = [self.headerViews indexOfObject:tapGR.view];
    if (index < [self.dataSource count]) {
        
        if (index != _selectedSection && _selectedSection != -1) {
            UIView *sectionView = self.headerViews[_selectedSection];
            UIImageView *iv = (UIImageView *) [sectionView viewWithTag:111];
            iv.image = wImage(@"iv_expand_add");
        }
        
        
        [self _showSectionAtIndex:index];
        
        
    }
}

- (NSArray *)indexPathsForSection:(NSUInteger)section {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < [self tableView:_tableView numberOfRowsInSection:section];
         i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:section];
        [array addObject:path];
    }
    
    return [array copy];
}

- (void)_showSectionAtIndex:(NSUInteger)index {
    NSLog(@"展开二级菜单，动画");
    
    UIView *view = self.headerViews[index];
    UIImageView *iv = (UIImageView *) [view viewWithTag:111];
    [self.tableView beginUpdates];
    //先删除，点中同一个也删，后插入
    if (self.selectedSection < [self.dataSource count]) {
        [self.tableView
         deleteRowsAtIndexPaths:[self indexPathsForSection:self.selectedSection]
         withRowAnimation:UITableViewRowAnimationFade];
        
        iv.image = wImage(@"iv_expand_add");
        
        if (self.selectedSection == index) {
            self.selectedSection = -1;
            [self.tableView endUpdates];
            return;
        }
    }
    self.selectedSection = index;
    [self.tableView insertRowsAtIndexPaths:[self indexPathsForSection:index]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    iv.image = wImage(@"iv_expand_jian");
    [self.tableView endUpdates];
}

- (NSMutableArray *)headerViews {
    if (!_headerViews)
        _headerViews = [NSMutableArray array];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wall"
    for (id object in self.dataSource)
        [_headerViews addObject:[NSNull null]];
#pragma clang diagnostic pop
    
    return _headerViews;
}


@end
