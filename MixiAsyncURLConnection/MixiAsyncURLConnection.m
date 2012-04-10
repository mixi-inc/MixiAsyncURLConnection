//
//  MixiAsyncURLConnection.m
//  MixiAsyncURLConnection
//
//  Created by Kenji Kinukawa on 12/04/10.
//  Copyright (c) 2012年 mixi Inc. All rights reserved.
//

#import "MixiAsyncURLConnection.h"

static NSString const *kMixiTimeoutDesctiption = @"インターネット接続がオフラインのようです。";

@implementation MixiAsyncURLConnection
@synthesize data;
@synthesize completeBlock;
@synthesize progressBlock;
@synthesize errorBlock;
@synthesize response;
@synthesize request;
@synthesize connection;

@synthesize timeoutSec;

- (id)initWithRequest:(NSURLRequest *)req 
           timeoutSec:(CGFloat)sec
        completeBlock:(completeBlock_t)cBlock 
        progressBlock:(progressBlock_t)pBlock
           errorBlock:(errorBlock_t)eBlock
{
    if ((self=[super init])) {
        self.data = [NSMutableData data];
        
        self.completeBlock  = cBlock;
        self.progressBlock  = pBlock;
        self.errorBlock     = eBlock;
        
        self.request = req;
        self.timeoutSec = sec;
    }
    return self;
}


- (void)dealloc
{
    self.completeBlock  = nil;
    self.progressBlock  = nil;
    self.errorBlock     = nil;
    
    self.data           = nil;
    self.response       = nil;
    self.connection     = nil;
    self.request        = nil;
    [super dealloc];
}

#pragma mark - perform Request method
- (void)performRequest
{
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self performSelector:@selector(timeout) withObject:nil afterDelay:timeoutSec];
}

#pragma mark - request cancel.
-(void)cancel
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    [connection cancel];
}

#pragma mark - timeout handle.
-(void)timeout
{
    [self cancel];
    [self connection:connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:[NSDictionary dictionaryWithObjectsAndKeys:kMixiTimeoutDesctiption,NSLocalizedDescriptionKey, nil]]];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)res
{
    NSHTTPURLResponse *hres = (NSHTTPURLResponse *)res;
    self.response = hres; 
}

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)d
{
    [data appendData:d];
    if (progressBlock) {
        progressBlock(self, [NSDictionary dictionaryWithObjectsAndKeys:data,@"data", nil]);
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    if (completeBlock) {
        completeBlock(self, data);
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeout) object:nil];
    if (errorBlock) {
        errorBlock(self, error);
    }
    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (progressBlock) {
        progressBlock(self, [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:bytesWritten],@"bytesWritten", 
                             [NSNumber numberWithInt:totalBytesWritten],@"totalBytesWritten", 
                             [NSNumber numberWithInt:totalBytesExpectedToWrite],@"totalBytesExpectedToWrite", 
                             nil]);
    }
}

@end
