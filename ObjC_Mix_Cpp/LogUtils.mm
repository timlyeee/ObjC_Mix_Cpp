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

@implementation logUtil : NSObject{
    NSMutableDictionary* funcDic;
}
+(void)sayGoodbye{
    std::cout<<"Goodbye CPP"<<std::endl;
    NSLog(@"Goodbye!");
}
-(bool)addFunc:(NSString*)key:(strFunction)func{
    if([funcDic objectForKey:key] == NULL){
        NSLog(@"Great, this is a new key value");
        [funcDic setObject:func forKey:key];
        return true;
    }
    NSLog(@"Oh no, func already exist");
    return false;
}
-(bool)applyFunc:(NSString*)key:(const std::string&)arg{
    strFunction f = [funcDic objectForkey:key];
    if(f != nil){
        NSLog(@"function exist!")
        f(arg);
    }
    NSLog(@"failed to find function for key ");
    return false;
    
}
-(strFunction)removeFunc:(NSString)key{
    strFunction f = [funcDic objectForkey:key];
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

