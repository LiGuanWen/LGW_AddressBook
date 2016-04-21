//
//  PersonCell.h
//  LGW_AddressBook
//
//  Created by Lilong on 16/4/20.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface PersonCell : UITableViewCell

- (void)setupCellWithPerson:(Person *)person;
@end
