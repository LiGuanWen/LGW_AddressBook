//
//  CustomAddressBookViewController.m
//  LGW_AddressBook
//
//  Created by Lilong on 16/4/20.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import "CustomAddressBookViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Person.h"
#import "PersonCell.h"
#import "LGWSphereView.h"

//屏幕宽度
#define ScreenWidth             ( [[UIScreen mainScreen] bounds].size.width )
//屏幕高度
#define ScreenHeight            ( [[UIScreen mainScreen] bounds].size.height )

@interface CustomAddressBookViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) LGWSphereView *sphereView;

@property (assign, nonatomic) ABAddressBookRef addressBook;
@property (strong, nonatomic) NSMutableArray *allPerson;
@property (strong, nonatomic) NSMutableArray *allPersonCopy;
@end

@implementation CustomAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allPerson = [[NSMutableArray alloc] init];
    self.allPersonCopy = [[NSMutableArray alloc] init];
    //请求访问通讯录并初始化数据
    [self requestAddressBook];
     [self setSphereViewUI];
    /**点击手势*/
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditView)];
    [self.tableView addGestureRecognizer:tapGR];
    
    self.tableView.hidden = YES;
//    /**滑动手势*/
//    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(endEditView)];
//    [self.tableView addGestureRecognizer:panGR];
//    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:nil] forCellReuseIdentifier:@"PersonCell"];
    // Do any additional setup after loading the view.
}

- (void)setSphereViewUI{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    self.sphereView = [[LGWSphereView alloc] initWithFrame:CGRectMake((ScreenWidth - 320)/ 2, 133, 320, 320)];
    for (NSInteger i = 0; i < self.allPersonCopy.count; i ++) {
        Person *person = self.allPersonCopy[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[NSString stringWithFormat:@"%@",person.name] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:24.];
        btn.frame = CGRectMake(0, 0, 60, 20);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [self.sphereView addSubview:btn];
    }
    [self.sphereView setCloudTags:array];
    self.sphereView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sphereView];

}
- (void)buttonPressed:(UIButton *)btn
{
    [self.sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [self.sphereView timerStart];
        }];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allPerson.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    [cell setupCellWithPerson:self.allPerson[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark UISearchBarDelegate

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"changed");
    if (searchText != nil && searchText.length > 0) {
        NSMutableArray *searchData = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.allPersonCopy.count; i++) {
            Person *person = self.allPersonCopy[i];
            if ([person.name rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0) {
                [searchData addObject:person];
            }else{
                if ([person.phoneNum rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0) {
                    [searchData addObject:person];
                }
            }
        }
        self.allPerson = searchData;
        [self.tableView reloadData];
    }else{
        self.allPerson = nil;
        [self.tableView reloadData];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"shuould begin");
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = @"";
    NSLog(@"did begin");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"did end");
    searchBar.showsCancelButton = NO;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search clicked");

}

//点击搜索框上的 取消按钮时 调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancle clicked");
    _searchBar.text = @"";
    self.allPerson = self.allPersonCopy;
    [self.tableView reloadData];
    [_searchBar resignFirstResponder];
}


#pragma mark 私有方法
// 请求访问通讯录
- (void)requestAddressBook{
   //创建通讯录对象
    self.addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //请求访问用户通讯录(无论成功与否block都会调用)
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        if (!granted) {
            NSLog(@"为获得通讯录访问权限");
        }
        [self initAllPerson];
    });
}

// 取得所有用户信息
- (void)initAllPerson{
    //取得通讯录访问授权
    ABAuthorizationStatus authorization = ABAddressBookGetAuthorizationStatus();
    //如果未获得授权
    if (authorization != kABAuthorizationStatusAuthorized) {
        NSLog(@"为获得通讯录访问授权");
        return;
    }
    //获得通讯录所有联系人信息
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    NSMutableArray *arr = (__bridge NSMutableArray *)allPeople;
    // 数据转换 并且保存到allPerson
    for (int i = 0; i < arr.count; i++) {
        Person *person = [[Person alloc] init];
        //取得一条人员记录
        ABRecordRef recordRef = (__bridge ABRecordRef)arr[i];
        //取得记录中得信息
        NSString *firstName = (__bridge NSString *) ABRecordCopyValue(recordRef, kABPersonFirstNameProperty);//注意这里进行了强转，不用自己释放资源
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(recordRef, kABPersonLastNameProperty);
        ABMultiValueRef phoneNumbersRef= ABRecordCopyValue(recordRef, kABPersonPhoneProperty);//获取手机号，注意手机号是ABMultiValueRef类，有可能有多条
        //  NSArray *phoneNumbers=(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumbersRef);//取得CFArraryRef类型的手机记录并转化为NSArrary
        NSString *phoneNum = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneNumbersRef, 0)); // 只取第一条手机号码
       
        NSData *imageData = nil;
        if (ABPersonHasImageData(recordRef)) { //有照片
           imageData = (__bridge NSData *)(ABPersonCopyImageData(recordRef));
        }
        
        if (firstName.length <= 0) {
            firstName = @"";
        }
        if (lastName.length <= 0) {
            lastName = @"";
        }
        if (phoneNum.length <= 0) {
            phoneNum = @"";
        }

        person.name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        person.phoneNum = phoneNum;
        person.headerIcon = imageData;
        [self.allPerson addObject:person];
    }
    //释放资源
    CFRelease(allPeople);
    self.allPersonCopy = [self.allPerson copy];
   
    [self.tableView reloadData];
    [self setSphereViewUI];
}

- (void)endEditView{
    [self.searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
     [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
