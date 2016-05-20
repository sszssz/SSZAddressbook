//
//  AddressBook.m
//  SSZAddressbook
//
//  Created by qijian on 16/4/27.
//  Copyright © 2016年 SSZ. All rights reserved.
//

#import "AddressBook.h"

#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>

#define IsSafeString(a)    ((a)&& (![(a) isEqual:[NSNull null]]) &&((a).length>0))

#define SafeString(a)    ((((a)==nil)||([(a) isEqual:[NSNull null]])||((a).length==0))?@"":(a))


static AddressBook *sharedAddressBook;

static dispatch_once_t onceToken;



@interface AddressBook()

@property (assign,nonatomic)ABAddressBookRef addressBooksRef;
@property (strong,nonatomic)NSMutableArray *addressBooksArr;

@end


@implementation AddressBook

+(AddressBook *)sharedInstance{
    
    dispatch_once(&onceToken, ^{
        
        sharedAddressBook = [[AddressBook alloc]init];
        
    });
    
    return sharedAddressBook;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}


#pragma mark -
-(ABAddressBookRef)addressBooksRef {
    
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip = 0;
    //声明一个通讯簿的引用
    _addressBooksRef = nil;
    
    if (!_addressBooksRef) {
        
        //因为在iOS6.0之后和之前的权限申请方式有所差别，这里做个判断
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        {
            //创建通讯录的引用,获取通讯录权限
            _addressBooksRef =  ABAddressBookCreateWithOptions(NULL, NULL);
            //创建出事信号量为0的信号
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            //申请访问权限
            ABAddressBookRequestAccessWithCompletion(_addressBooksRef, ^(bool granted, CFErrorRef error){
                
                //granted为yes时表示使用户允许，否则为不允许
                if (!granted) {
                    
                    tip = 1;
                }
                
                //发送一次信号
                dispatch_semaphore_signal(sema);
            });
            //等待信号触发
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        }else{
            
            //iOS6.0之前
            _addressBooksRef = ABAddressBookCreateWithOptions(_addressBooksRef, nil);
            //_addressBooksRef = ABAddressBookCreate();//禁用了
        }
        
        if (tip) {
            //做一个友好的提示
            UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示:" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alart show];
        }
    }
    return _addressBooksRef;
}

-(NSMutableArray *)addressBooksArr{
    
    if (!_addressBooksArr) {
        
        _addressBooksArr = [NSMutableArray array];
        
        //获取所有联系人的数组
        NSArray *contacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople([AddressBook sharedInstance].addressBooksRef);
        //获取联系人总数
        NSInteger contactsCount = [contacts count];
        
        //进行遍历
        for(int i = 0; i < contactsCount; i++) {
            
            //获取联系人对象的引用
            ABRecordRef record = (__bridge ABRecordRef)[contacts objectAtIndex:i];
            //获取联系人对象的引用
            AddressBookModel * addressBookObj = [[AddressBookModel alloc] init];
            
            //取得联系人的ID
            //addressBookObj.recordID = (int)ABRecordGetRecordID(record);
            
            //完整姓名 综合的名字
            CFStringRef compositeNameRef = ABRecordCopyCompositeName(record);
            
            
            
            // 公司名字
            addressBookObj.compositeName = SafeString((__bridge NSString *)compositeNameRef);
            
            compositeNameRef != NULL ? CFRelease(compositeNameRef) : NULL;
            
            
            
            
            NSString *organization = (__bridge NSString*)ABRecordCopyValue(record, kABPersonOrganizationProperty);
            
            addressBookObj.organization = organization;
            
            
            
            
            //            CFStringRef tmpCompanyname = ABRecordCopyCompositeName(record);
            //
            //            addressBookObj.organization = SafeString((__bridge  NSString *)tmpCompanyname);
            
            
            
            //            NSString* tmpCompanyname = (__bridge NSString*)ABRecordCopyValue(record, kABPersonOrganizationProperty);
            
            
            //            addressBookObj.organization =  SafeString((__bridge NSString *)tmpCompanyname);
            
            
            
            
            
            
            
            //处理联系人电话号码
            ABMultiValueRef  phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
            for(int i = 0; i < ABMultiValueGetCount(phones); i++)
            {
                CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phones, i);
                CFStringRef localizedPhoneLabelRef = ABAddressBookCopyLocalizedLabel(phoneLabelRef);
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, i);
                
                NSString * localizedPhoneLabel = (__bridge NSString *) localizedPhoneLabelRef;
                NSString * phoneNumber = (__bridge NSString *)phoneNumberRef;
                
                
                NSString *phone = [phoneNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phoneNumber length])];
                
                if (i == 0) {
                    addressBookObj.phone = SafeString(phone);
                }
                
                [addressBookObj.phoneInfo setValue:localizedPhoneLabel forKey:phone];
                
                //Release
                //phoneLabelRef == NULL ? : CFRelease(phoneLabelRef);
                //localizedPhoneLabelRef == NULL ? : CFRelease(localizedPhoneLabelRef);
                //phoneNumberRef == NULL ? : CFRelease(phoneNumberRef);
            }
            
            //if(phones != NULL) CFRelease(phones);
            
            
            if (IsSafeString(addressBookObj.phone)) {
                [_addressBooksArr addObject:addressBookObj];
            }
            
            //CFRelease(record);
        }
    }
    
    return _addressBooksArr;
    
}


+(NSMutableArray *)addressBooks{
    
    return [AddressBook sharedInstance].addressBooksArr;
}


+(BOOL)containPhoneNum:(NSString*)phoneNum{
    
    for (AddressBookModel *obj in [AddressBook sharedInstance].addressBooksArr) {
        
        if (obj.phoneInfo[phoneNum]) {
            
            return YES;
        }
    }
    return NO;
}

@end
