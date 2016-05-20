//
//  AddressBookModel.h
//  SSZAddressbook
//
//  Created by qijian on 16/4/27.
//  Copyright © 2016年 SSZ. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 
 通讯录中内容
 
*/

@interface AddressBookModel : NSObject


@property (nonatomic,assign) int recordID;
@property (nonatomic,strong) NSString *compositeName;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSMutableDictionary *phoneInfo;
@property (nonatomic, copy) NSString *organization;



+(instancetype)modelWithCompositeName:(NSString *)compositeName
                                phone:(NSString *)phone
                         organization:(NSString *)organization;

@end
