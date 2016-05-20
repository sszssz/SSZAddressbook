//
//  AddressBookModel.m
//  SSZAddressbook
//
//  Created by qijian on 16/4/27.
//  Copyright © 2016年 SSZ. All rights reserved.
//

#import "AddressBookModel.h"

@implementation AddressBookModel


-(NSMutableDictionary *)phoneInfo
{
    if(_phoneInfo == nil)
    {
        _phoneInfo = [[NSMutableDictionary alloc] init];
    }
    return _phoneInfo;
}


+(instancetype)modelWithCompositeName:(NSString *)compositeName
                                phone:(NSString *)phone
                         organization:(NSString *)organization
{
    
    AddressBookModel *model = [[AddressBookModel alloc] init];
    model.compositeName = compositeName;
    model.phone= phone;
    model.organization = organization;
    
    return model;
    
    
}




@end
