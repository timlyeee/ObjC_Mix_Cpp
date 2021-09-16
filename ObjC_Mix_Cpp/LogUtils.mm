//
//  LogUtils.m
//  ObjC_Mix_Cpp
//
//  Created by LX on 13/09/2021.
//

#import <Foundation/Foundation.h>
#import "LogUtils.h"
#include <iostream>

void sayGoodb(const std::string& str ){
    std::cout<<"str is" + str;
    [logUtil sayGoodbye];
}

@interface logUtil()
-(void)privateMethod;
@end

@implementation logUtil : NSObject{
    NSMutableDictionary* funcDic;
}

static logUtil* instance = nil;
+(instancetype)sharedInstance{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
            instance = [[super allocWithZone:NULL]init];
    });
    return instance;
    
}
+(id)allocWithZone:(struct _NSZone *)zone{
    return [logUtil sharedInstance];
}
-(id)copyWithZone:(struct _NSZone *)zone{
    return [logUtil sharedInstance];
}
+(void)sayGoodbye{
    std::cout<<"Goodbye CPP"<<std::endl;
    NSLog(@"Goodbye!");
}

-(void)privateMethod{
    NSLog(@"Is private");
}

-(id)init{
    if(self = [super init]){
        funcDic = [[NSMutableDictionary alloc]init];
    }
    [self privateMethod];
    return self;
}
-(bool)addFunc:(NSString*)key:(strFunction)f{
    if([funcDic objectForKey:key] == nil){
        NSLog(@"Great, this is a new key value");
        [funcDic setObject:f forKey:key];
        return true;
    }
    NSLog(@"Oh no, func already exist");
    return false;
}
-(bool)applyFunc:(NSString*)key:(const std::string&)arg{
    strFunction f = [funcDic objectForKey:key];
    if(f != nil){
        NSLog(@"function exist!");
        f(arg);
        return true;
    }
    NSLog(@"failed to find function for key ");
    return false;
    
}
-(strFunction)removeFunc:(NSString*)key{
    strFunction f = [funcDic objectForKey:key];
    if(f != nil){
        [funcDic removeObjectForKey:key];
    }
    return f;
}
-(void)sayHello{
    std::cout<<"Hello CPP"<<std::endl;
    NSLog(@"Hello world!");
}
@end

