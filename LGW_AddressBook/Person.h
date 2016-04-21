//
//  Person.h
//  LGW_AddressBook
//
//  Created by Lilong on 16/4/20.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *phoneNum;

@property (strong, nonatomic) NSData *headerIcon;
@end
