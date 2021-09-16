# Programming by Objective-c mix C++
# 混编 Objective-c 和 C++ 实现方法注册类

## 简介

基于C++编程经验而入门的Objective-c，并利用机制实现一个能够储存Objective-c方法Block（也许有Selcetor？的写法？）的类。

本文会从类的构造开始写，并且逐渐引入C++声明objective-c实现的写法。

## m文件和mm文件

后缀名为m的文件只能编写oc代码和c代码，而mm文件则支持cpp混编。h头文件同样支持cpp和oc。这为我们跨语言提供了支持。

## Class->Interface

简单理解，Objective-c中的interface就是C++中的class，两者在用法上面没有太大的区别，那么我们以c++的语言习惯而言，可以在头文件中进行类的声明而在mm文件中进行类的实现

```objc
#ifndef LogoutUtils_h
#define LogoutUtils_h
#include <string>

@interface logUtil : NSObject
-(void)sayHello;
-(bool)addFunc:(NSString *)key:(strFunction)func;
-(bool)applyFunc:(NSString *)key:(const std::string&)arg;
-(strFunction)removeFunc:(NSString *)key;
+(void)sayGoodbye;

@end
#endif /* LogoutUtils_h */
```
### 函数的名称和参数

在obj-c中，函数的参数以：的形式跟随在函数名称的后面，并且类型以（）括号包裹在变量前。
```objc
/*sayHello without params*/
(void)sayHello;
== equals to ==>
void sayHello();

/*addFunc with params*/
(bool)addFunc:(NSString*)key:(NSObject*)obj;
== equals to ==>
bool addFunc(NSString* key, NSObject* obj);
```
不过返回值和C++很像的是其写在函数名称之前。只不过也需要通过（）包含起来。

### 静态成员函数

静态成员函数的定义写法也有很大的区别。我们可以不再使用static关键字，而是使用+ -符号来表示一个函数是否是静态的。+即代表该方法是静态的。比如
```objc
+(void)sayGoodbye;
== equals to ==
static void sayGoodbye();
```
### 私有成员和共有成员

公有成员一般在类声明中并指定@public关键字。
```objc
@interface logUtil:NSObject{
    @public NSString* name;
}
@end
```
有两种方法可以定义私有的成员变量但是使用时需要尽量保持统一：

- 类扩展：用interface+（）的写法作为类在mm实现域中的扩展。
```objc
@interface logUtil(){
    NSString* familyName;
}
@end
```
- 类别：用implementation关键字定义，通常用来定义函数，声明私有成员。
```objc
@implementation logUtil{
    NSString* familyName;
}
@end
```

### 私有成员函数

在C++中很好用的private成员函数在Objc中并没有对应的方便的写法，尽管Objc中提供了名为类拓展的方法，能够模拟私有成员函数的作用。
```objc
//in .h
@interface logUtil : NSObject
-(void)publicMethod;
@end

//in .mm
@interface logUtil()
-(void) privateMtd;
@end
```
## Alloc+Init=new

在objc中，创建某个类的对象并分配空间比较偏向c语言中的alloc和release。（所以才会有autoreleasePool等。）如果我们定义了某些数据结构并且没有初始化它的值，那么会导致后续该变量一直保持nil（～=null）。

```objc 
@interface logUtil : NSObject{
    NSMutableDictionnary* NameDic;
}
-(void)addName:(NSString*)keyValue:(NSString*)name;
-(NSString*)getName:(NSString*)key;
@end
@implementation logUtil
-(void)addName:(NSString*)keyValue:(NSString*)name{
    [NameDic setObject:name forKey:keyValue];//can be done
}
-(NSString*)getName:(NSString*)key{
    return [NameDic ObjectForKey:key]; //error, NameDic is nil!!!
}
@end
```
此时我们就需要一个构造函数来初始化我们的值，因为NSMutableDictionnary不会自动创建，而且Objc里面都是指针写法，所以最终仍然会保持空指针。

变量初始化的时候，我们可以写为NSObject* n = [NSObject new]，其实际上是在调用[[NSObject alloc] init]。所以我们需要重载init函数来初始化我们的值

```objc
@implementation logUtil
-(id)init{
    self = [super init];
    if(self){
        //Create a new dic
        NameDic = [[NSMutableDictionnary alloc] init];
    }
    return self；
}
@end
```
注意这里的id是objc中的泛用指针，但并不是Void*指针，它必须指向一个object并且拥有retain和release方法。

## 拓展单例模式
将这个对象设置为单例模式可以帮助我们单独维护一个map而不需要去特意找它的地址。

### Static Instance的简单实现

```objc
@implementation logUtil : NSObject
static logUtil* instance = nil;
+(instancetype)getInstance{
    if(!instance){
        instance = [logUtil new];
    }
    return instance;
}
@end
```
在getInstance的实现上面和C++没有太大的区别，但是作为单例模式我们并不希望这个Instance的构造函数暴露为公开接口，但init函数又是公开接口，所以我们需要先封住这个接口。

### GCD: Grand Central Dispatch

这个取名大概是参考纽约市的grand central terminal的？objective-c的GCD机制可以帮助代码更容易实现线程安全，而线程安全问题就是单例模式最需要注意的。

使用dispatch_once可以解决这个问题
```objc
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
```

