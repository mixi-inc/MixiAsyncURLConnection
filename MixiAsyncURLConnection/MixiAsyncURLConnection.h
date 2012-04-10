//
//  MixiAsyncURLConnection.h
//  MixiAsyncURLConnection
//
//  Created by Kenji Kinukawa on 12/04/10.
//  Copyright (c) 2012年 mixi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completeBlock_t)(id connection, NSData *data);
typedef void (^progressBlock_t)(id connection, NSDictionary *pDict);
typedef void (^errorBlock_t)(id connection, NSError *error);

@interface MixiAsyncURLConnection : NSObject

@property (nonatomic,retain) NSMutableData *data;
@property (nonatomic,copy) completeBlock_t completeBlock;
@property (nonatomic,copy) progressBlock_t progressBlock;
@property (nonatomic,copy) errorBlock_t errorBlock;
@property (nonatomic,retain) NSHTTPURLResponse *response;
@property (nonatomic,retain) NSURLRequest *request;
@property (nonatomic,retain) NSURLConnection *connection;
@property (nonatomic) CGFloat timeoutSec;

- (id)initWithRequest:(NSURLRequest *)req 
           timeoutSec:(CGFloat)sec
        completeBlock:(completeBlock_t)cBlock 
        progressBlock:(progressBlock_t)pBlock
           errorBlock:(errorBlock_t)eBlock;

- (void)performRequest;

- (void)cancel;

@end