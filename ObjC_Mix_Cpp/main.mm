//
//  main.m
//  ObjC_Mix_Cpp
//
//  Created by LX on 13/09/2021.
//

#import <Foundation/Foundation.h>
#import "LogUtils.h"
#include <string.h>
#include <iostream>

int main(int argc, const char * argv[]) {
    //logUtil* lutil = [logUtil new];
    logUtil* lutil = [logUtil sharedInstance];
    std::cout<<"lutil address is : "<< &lutil << std::endl;
    logUtil* lutil2 = [logUtil new];
    std::cout<<"lutil2 address is :"<< &lutil2 <<std::endl;
    //std::cout<<"lutil2 address is : "<< &lutil2 << std::endl;
    
    //sharedInstance;
    [lutil sayHello];
    strFunction sayBB = ^void (const std::string& str){
        std::cout<<str<<std::endl;
    };
    
    [lutil addFunc:@"sayGoodbye":sayBB];
    [lutil applyFunc:@"sayGoodbye":"HHHH"];
    @autoreleasepool {
    }
    return 0;
}
