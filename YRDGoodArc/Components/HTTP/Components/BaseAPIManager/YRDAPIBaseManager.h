//
//  YRDAPIBaseManager.h
//  YRDGoodArc
//
//  Created by yurongde on 16/5/23.
//  Copyright © 2016年 yurongde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRDURLResponse.h"

@class YRDAPIBaseManager;

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kYRDAPIBaseManagerRequestID = @"kYRDAPIBaseManagerRequestID";

/*************************************************************************************************/
/*                               YRDAPIManagerApiCallBackDelegate                                 */
/*************************************************************************************************/

//api回调
@protocol YRDAPIManagerApiCallBackDelegate <NSObject>
@optional
/**
 *  成功时
 *
 *  @param manager <#manager description#>
 */
- (void)managerCallAPIDidSuccess:(YRDAPIBaseManager *)manager;
/**
 *  失败时
 *
 *  @param manager <#manager description#>
 */
- (void)managerCallAPIDidFailed:(YRDAPIBaseManager *)manager;
@end


/*************************************************************************************************/
/*                               YRDAPIManagerCallbackDataReformer                                */
/*************************************************************************************************/
//负责重新组装API数据的对象
@protocol YRDAPIManagerCallbackDataReformer <NSObject>
@required
/*
 比如同样的一个获取电话号码的逻辑，二手房，新房，租房调用的API不同，所以它们的manager和data都会不同。
 即便如此，同一类业务逻辑（都是获取电话号码）还是应该写到一个reformer里面去的。这样后人定位业务逻辑相关代码的时候就非常方便了。
 
 代码样例：
 - (id)manager:(RTAPIBaseManager *)manager reformData:(NSDictionary *)data
 {
 if ([manager isKindOfClass:[xinfangManager class]]) {
 return [self xinfangPhoneNumberWithData:data];      //这是调用了派生后reformer子类自己实现的函数，别忘了reformer自己也是一个对象呀。
 //reformer也可以有自己的属性，当进行业务逻辑需要一些外部的辅助数据的时候，
 //外部使用者可以在使用reformer之前给reformer设置好属性，使得进行业务逻辑时，
 //reformer能够用得上必需的辅助数据。
 }
 
 if ([manager isKindOfClass:[zufangManager class]]) {
 return [self zufangPhoneNumberWithData:data];
 }
 
 if ([manager isKindOfClass:[ershoufangManager class]]) {
 return [self ershoufangPhoneNumberWithData:data];
 }
 }
 */
- (id)manager:(YRDAPIBaseManager *)manager reformData:(NSDictionary *)data;
@end


/*************************************************************************************************/
/*                                     YRDAPIManagerValidator                                     */
/*************************************************************************************************/
//验证器，用于验证API的返回或者调用API的参数是否正确
/*
 使用场景：
 当我们确认一个api是否真正调用成功时，要看的不光是status，还有具体的数据内容是否为空。由于每个api中的内容对应的key都不一定一样，甚至于其数据结构也不一定一样，因此对每一个api的返回数据做判断是必要的，但又是难以组织的。
 为了解决这个问题，manager有一个自己的validator来做这些事情，一般情况下，manager的validator可以就是manager自身。
 
 1.有的时候可能多个api返回的数据内容的格式是一样的，那么他们就可以共用一个validator。
 2.有的时候api有修改，并导致了返回数据的改变。在以前要针对这个改变的数据来做验证，是需要在每一个接收api回调的地方都修改一下的。但是现在就可以只要在一个地方修改判断逻辑就可以了。
 3.有一种情况是manager调用api时使用的参数不一定是明文传递的，有可能是从某个变量或者跨越了好多层的对象中来获得参数，那么在调用api的最后一关会有一个参数验证，当参数不对时不访问api，同时自身的errorType将会变为RTAPIManagerErrorTypeParamsError。这个机制可以优化我们的app。
 
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 */
@protocol YRDAPIManagerValidator <NSObject>
@required
/*
 所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
 因为判断逻辑都在这里做掉了。
 而且本来判断返回数据是否正确的逻辑就应该交给manager去做，不要放到回调到controller的delegate方法里面去做。
 */
- (BOOL)manager:(YRDAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

/*
 
 “
 william补充（2013-12-6）：
 4.特殊场景：租房发房，用户会被要求填很多参数，这些参数都有一定的规则，比如邮箱地址或是手机号码等等，我们可以在validator里判断邮箱或者电话是否符合规则，比如描述是否超过十个字。从而manager在调用API之前可以验证这些参数，通过manager的回调函数告知上层controller。避免无效的API请求。加快响应速度，也可以多个manager共用.
 ”
 
 所以不要以为这个params验证不重要。当调用API的参数是来自用户输入的时候，验证是很必要的。
 当调用API的参数不是来自用户输入的时候，这个方法可以写成直接返回true。反正哪天要真是参数错误，QA那一关肯定过不掉。
 不过我还是建议认真写完这个参数验证，这样能够省去将来代码维护者很多的时间。
 
 */
- (BOOL)manager:(YRDAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end

/*************************************************************************************************/
/*                                YRDAPIManagerParamSourceDelegate                                */
/*************************************************************************************************/
//让manager能够获取调用API所需要的数据
@protocol YRDAPIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(YRDAPIBaseManager *)manager;
@end

/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI。（安居客PAD就有这样的需求，sigh～）
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger, YRDAPIManagerErrorType){
    YRDAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    YRDAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    YRDAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    YRDAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    YRDAPIManagerErrorTypeTimeout,       //请求超时。RTApiProxy设置的是20秒超时，具体超时时间的设置请自己去看RTApiProxy的相关代码。
    YRDAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, YRDAPIManagerRequestType){
    YRDAPIManagerRequestTypeGet,
    YRDAPIManagerRequestTypePost,
    YRDAPIManagerRequestTypeRestGet,
    YRDAPIManagerRequestTypeRestPost
};

/*************************************************************************************************/
/*                                         YRDAPIManager                                          */
/*************************************************************************************************/
/*
  YRDAPIBaseManager的派生类必须符合这些protocal
 */
@protocol  YRDAPIManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (YRDAPIManagerRequestType)requestType;

@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end

/*************************************************************************************************/
/*                                    YRDAPIManagerInterceptor  拦截器                                  */
/*************************************************************************************************/
/*
 YRDAPIBaseManager的派生类必须符合这些protocal
 */
@protocol YRDAPIManagerInterceptor <NSObject>

@optional
- (void)manager:(YRDAPIBaseManager *)manager beforePerformSuccessWithResponse:(YRDURLResponse *)response;
- (void)manager:(YRDAPIBaseManager *)manager afterPerformSuccessWithResponse:(YRDURLResponse *)response;

- (void)manager:(YRDAPIBaseManager *)manager beforePerformFailWithResponse:(YRDURLResponse *)response;
- (void)manager:(YRDAPIBaseManager *)manager afterPerformFailWithResponse:(YRDURLResponse *)response;

- (BOOL)manager:(YRDAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(YRDAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end
/*************************************************************************************************/
/*                                       YRDAPIBaseManager                                        */
/*************************************************************************************************/
typedef void(^YRDRequestCompletionBlock)(YRDAPIBaseManager *manager);

@interface YRDAPIBaseManager : NSObject

@property (nonatomic, weak) id<YRDAPIManagerApiCallBackDelegate> delegate;/**< 请求回调*/
@property (nonatomic, weak) id<YRDAPIManagerParamSourceDelegate> paramSource;/**< 请求参数*/
@property (nonatomic, weak) id<YRDAPIManagerValidator> validator;/**< 请求与结果验证器*/
@property (nonatomic, weak) NSObject<YRDAPIManager> *child; /**< 请求方式，请求路径,里面会调用到NSObject的方法，所以这里不用id*/

@property (nonatomic, weak) id<YRDAPIManagerInterceptor> interceptor;/**< 拦截器*/

/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要通过extension来在保证errorMessage在对外只读的情况下使派生的manager子类对errorMessage具有写权限。
 */
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) YRDAPIManagerErrorType errorType;/**< 状态*/


@property (nonatomic, copy) YRDRequestCompletionBlock successCompletionBlock;/**< 成功后的block回调*/

@property (nonatomic, copy) YRDRequestCompletionBlock failureCompletionBlock;/**< 失败后的block回调*/

@property (nonatomic, assign, readonly) BOOL isReachable;/**< 网络连接状态*/

@property (nonatomic, assign, readonly) BOOL isLoading;/**< 正在请求，判断方式是请求列表里有没有这个requestId*/

/**
 *  数据模型转换器
 *
 *  @param reformer
 *
 *  @return
 */
- (id)fetchDataWithReformer:(id<YRDAPIManagerCallbackDataReformer>)reformer;
//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
//使用代理处理请求
- (NSInteger)loadData;


/// block启动请求
/*
 记得使用weakSelf,不然如果网络超时的时候会延长生命周期。
@weakify(self)
[self doSomething^{
    @strongify(self)
    if (!self) return;
    ...
}];
*/
- (void)startWithCompletionBlockWithSuccess:(YRDRequestCompletionBlock)success
                                    failure:(YRDRequestCompletionBlock)failure;
//设置block
- (void)setCompletionBlockWithSuccess:(YRDRequestCompletionBlock)success
                              failure:(YRDRequestCompletionBlock)failure;

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

/**
 取消当前apimanager请求所有请求
 */
- (void)cancelAllRequests;
/**
 *  取消某个请求
 *
 *  @param requestID 
 */
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// 拦截器方法，继承之后需要调用一下super
- (void)beforePerformSuccessWithResponse:(YRDURLResponse *)response;
- (void)afterPerformSuccessWithResponse:(YRDURLResponse *)response;

- (void)beforePerformFailWithResponse:(YRDURLResponse *)response;
- (void)afterPerformFailWithResponse:(YRDURLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

/*
 用于给继承的类做重载，在调用API之前额外添加一些参数,但不应该在这个函数里面修改已有的参数。
 子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
 YRDAPIBaseManager会先调用这个函数，然后才会调用到 id<YRDAPIManagerValidator> 中的 manager:isCorrectWithParamsData:
 所以这里返回的参数字典还是会被后面的验证函数去验证的。
 
 假设同一个翻页Manager，ManagerA的paramSource提供page_size=15参数，ManagerB的paramSource提供page_size=2参数
 如果在这个函数里面将page_size改成10，那么最终调用API的时候，page_size就变成10了。然而外面却觉察不到这一点，因此这个函数要慎用。
 
 这个函数的适用场景：
 当两类数据走的是同一个API时，为了避免不必要的判断，我们将这一个API当作两个API来处理。
 那么在传递参数要求不同的返回时，可以在这里给返回参数指定类型。
 
 
 */
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;

@end
