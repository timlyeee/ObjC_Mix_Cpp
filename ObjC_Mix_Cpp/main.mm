//
//  main.m
//  ObjC_Mix_Cpp
//
//  Created by LX on 13/09/2021.
//

#import <Foundation/Foundation.h>
#import "LogUtils.h"
#include <string.h>

int main(int argc, const char * argv[]) {
    logUtil* lutil = [logUtil new];
    [lutil sayHello];
    [lutil addFunc:@"sayGoodbye":sayGoodb];
    [lutil applyFunc:@"sayGoodbye":std::string("HHHH")];
    @autoreleasepool {
    }
    return 0;
}
