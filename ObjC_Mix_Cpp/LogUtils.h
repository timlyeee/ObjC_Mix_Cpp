//
//  LogoutUtils.h
//  ObjC_Mix_Cpp
//
//  Created by LX on 13/09/2021.
//

#ifndef LogoutUtils_h
#define LogoutUtils_h
#include <string>

void (*strFunction)(const std::string&);

void sayGoodb(const std::string& str );

@interface logUtil : NSObject
-(void)sayHello;
-(bool)addFunc:(NSString *)key:(strFunction)func;
-(bool)applyFunc:(NSString *)key;
-(strFunction)removeFunc:(NSString *)key;
+(void)sayGoodbye;

@end
#endif /* LogoutUtils_h */
