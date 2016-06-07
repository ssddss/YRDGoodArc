//
//  MethodsMacro.h
//  YRDGoodArc
//
//  Created by yurongde on 16/6/7.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#ifndef MethodsMacro_h
#define MethodsMacro_h

// 设置userDefault的value

#define USER_DEFAULTS_SET(__OBJECT,__KEY) {\
[[NSUserDefaults standardUserDefaults] setObject:__OBJECT forKey:__KEY];\
[[NSUserDefaults standardUserDefaults] synchronize];}

// 获取userDefault的value

#define USER_DEFAULTS_GET(__KEY) ([[NSUserDefaults standardUserDefaults] objectForKey:__KEY])



#endif /* MethodsMacro_h */
