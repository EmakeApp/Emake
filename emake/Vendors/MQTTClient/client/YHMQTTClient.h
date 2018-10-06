//
//  YHMQTTClient.h
//  MQTTClientManager
//
//  Created by 谷伟 on 2017/9/30.
//  Copyright © 2017年 谷伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient/MQTTClient.h>
#import "YHMQTTClientDelegate.h"

typedef void(^MQTTMessageBlock)(MQTTMessage *);

@interface YHMQTTClient : NSObject

//单利属性
@property (nonatomic,strong)MQTTCFSocketTransport *transport;

@property (nonatomic,strong)MQTTSession *session;


@property(nonatomic, weak)UIViewController<YHMQTTClientDelegate>* delegate;//代理
//消息topic
@property(nonatomic, copy)NSString *messageTopic;
//消息topic
@property(nonatomic, copy)NSString *mymessageTopic;
//CMDTopic
@property(nonatomic, copy)NSString *CMDTopic;
//消息另一个topic
@property(nonatomic, copy)NSString *messageAnotherTopic;

//消息个数
@property(nonatomic, assign)NSInteger messageCount;

//消息个数
@property(nonatomic, strong)NSMutableDictionary * messageCountDic;
// 单例
+ (YHMQTTClient *)sharedClient;

//连接
-(void)connectToHost:(NSString *)host Port:(NSInteger)port withUserID:(NSString *)userId;

//发送消息
- (void)sendMessage:(NSDictionary *)data withTopic:(NSString *)Topic complete:(void(^)(NSError *error))completeBlock;

//发送指令
- (void)sendCommmand:(NSDictionary *)command withSelfTopic:(NSString *)selfTopic complete:(void(^)(NSError *error))completeBlock;

//获取某聊天室的客服个数
- (void)sendRequestChatroomCustomerListCMDWith:(NSString *)userId andStoreId:(NSString *)storeId;

//断开连接
- (void)disConnect;

//是否连接
- (BOOL)isMQTTConnect;

@end



