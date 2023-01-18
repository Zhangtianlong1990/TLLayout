//
//  ViewController.m
//  TLLayout
//
//  Created by 张天龙 on 2023/1/15.
//

#import "ViewController.h"
#import "TLViewModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray<TLViewModel *> *datas;
@end

@implementation ViewController

- (UITableView *)tableView{
    if (_tableView == nil) {
        CGFloat tableViewH = [UIScreen mainScreen].bounds.size.height;
        CGFloat tableViewW = [UIScreen mainScreen].bounds.size.width;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tableViewW, tableViewH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return  _tableView;
}

- (NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return  _datas;
}

- (void)getStatus{
    for (int i = 0 ; i < 20; i++) {
        TLViewModel *model = [[TLViewModel alloc] init];
        model.index = i;
        model.cellHeight = 50;
        [self.datas addObject:model];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - 10, 30, 50, 50)];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self getStatus];
    
}

- (void)didClickButton{
    self.datas[3].cellHeight = 100;
    //用户不滑动的时候才会刷新，用户体验更好
    [self performSelector:@selector(updateTheHeightOfCell) withObject:nil afterDelay:2.0 inModes:@[NSDefaultRunLoopMode]];
}

- (void)updateTheHeightOfCell{
    //会在此调用heightForRowAtIndexPath而不需要重新加载cell，重新获取高度
    //一般来说，这对函数里面放着是插入，删除cell这些操作的，不能reloadData方法
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.datas[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TLViewModel *model = self.datas[indexPath.row];
    
    static NSString *cellID = @"cellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld row",model.index];
    
    return  cell;
    
}


@end
