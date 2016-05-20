//
//  ViewController.m
//  SSZAddressbook
//
//  Created by qijian on 16/4/27.
//  Copyright © 2016年 SSZ. All rights reserved.
//

#import "ViewController.h"

#import "AddressBook.h"

#define  WIDTH  [[UIScreen mainScreen] bounds].size.width

#define  HEIGHT  [[UIScreen mainScreen] bounds].size.height



@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //*******************************************
    //当 automaticallyAdjustsScrollViewInsets为 NO 时,tableview是从屏幕的最上边开始，也就是被 导航栏 & 状态栏覆盖
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self createtTableView];
}


-(void)createtTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 100, 300, 450) style:UITableViewStylePlain];
    
    //UITableView *tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:UITableViewStylePlain];

    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //tableView.backgroundColor = [UIColor greenColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    tableView.separatorColor = [UIColor redColor];
    
    [self.view addSubview:tableView];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [AddressBook addressBooks].count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        
       AddressBookModel *obj = [AddressBook addressBooks][indexPath.row];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 50)];
        //label.backgroundColor = [UIColor purpleColor];
        [cell.contentView addSubview:label];
        
        label.text = [NSString stringWithFormat:@"    %@ : %@", obj.compositeName,obj.phone];
        
        //cell.detailTextLabel.text = obj.phone;
        //NSLog(@"===%@",label.text);
        
        //cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
