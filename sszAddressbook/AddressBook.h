//
//  AddressBook.h
//  SSZAddressbook
//
//  Created by qijian on 16/4/27.
//  Copyright © 2016年 SSZ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AddressBookModel.h"

@interface AddressBook : NSObject

/*
 
 获取通讯录
 
*/
+(AddressBook *)sharedInstance;


/**
 * 返回通讯录对象
 *
 * @return (AddressBookObj)
 **/
+(NSMutableArray *)addressBooks;


/**
 * 判断是否存在 phoneNum
 *
 * @param phoneNum 联系人电话
 *
 * @return (NSMutableArray)
 **/

+(BOOL)containPhoneNum:(NSString *)phoneNum;



@end
