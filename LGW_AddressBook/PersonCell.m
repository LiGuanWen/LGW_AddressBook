//
//  PersonCell.m
//  LGW_AddressBook
//
//  Created by Lilong on 16/4/20.
//  Copyright © 2016年 第七代目. All rights reserved.
//

#import "PersonCell.h"
@interface PersonCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;

@end
@implementation PersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerIcon.layer.cornerRadius = self.headerIcon.frame.size.width/2;
    self.headerIcon.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setupCellWithPerson:(Person *)person{
    if (person.headerIcon) {
         self.headerIcon.image = [UIImage imageWithData:person.headerIcon];
    }else{
        self.headerIcon.image = [UIImage imageNamed:@"default_header_icon"];
    }
    self.nameLab.text = person.name;
    self.phoneNumLab.text = person.phoneNum;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
