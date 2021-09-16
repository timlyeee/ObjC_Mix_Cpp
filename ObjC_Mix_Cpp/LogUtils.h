//
//  LogoutUtils.h
//  ObjC_Mix_Cpp
//
//  Created by LX on 13/09/2021.
//

#ifndef LogoutUtils_h
#define LogoutUtils_h
#include <string>

typedef void (^strFunction)(const std::string&);

void sayGoodb(const std::string& str );

@interface logUtil : NSObject {
}
+(id)getInstance;
+(void)sayGoodbye;
+(instancetype)sharedInstance;
-(void)sayHello;
-(bool)addFunc:(NSString *)key:(strFunction)func;
-(bool)applyFunc:(NSString *)key:(const std::string&)arg;
-(strFunction)removeFunc:(NSString *)key;


@end
#endif /* LogoutUtils_h */
