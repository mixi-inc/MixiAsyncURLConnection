//
//  ViewController.m
//  MixiAsyncURLConnection
//
//  Created by Kenji Kinukawa on 12/04/10.
//  Copyright (c) 2012年 mixi Inc. All rights reserved.
//

#import "ViewController.h"
#import "MixiAsyncURLConnection.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)doRequest:(NSURLRequest *)request cBlock:(completeBlock_t)cBlock pBlock:(progressBlock_t)pBlock eBlock:(errorBlock_t)eBlock
{
    MixiAsyncURLConnection * connection = [[[MixiAsyncURLConnection alloc]initWithRequest:request 
                                                                               timeoutSec:10.0f 
                                                                            completeBlock:cBlock 
                                                                            progressBlock:pBlock 
                                                                               errorBlock:eBlock] autorelease];
    [connection performRequest];
}

- (IBAction)pressButton1:(id)sender
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mixi.jp/"]];
    [self doRequest:req cBlock:^(id connection, NSData *data){
        self.textView.text = [[[NSString alloc]initWithData:data encoding:NSJapaneseEUCStringEncoding]autorelease];
    }pBlock:nil eBlock:nil];
}

- (IBAction)pressButton2:(id)sender
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/"]];
    [self doRequest:req cBlock:^(id connection, NSData *data){
        self.textView.text = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    }pBlock:nil eBlock:nil];    
}

- (IBAction)pressButton3:(id)sender
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/"]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[@"data=hogefuga" dataUsingEncoding:NSUTF8StringEncoding]];
    [self doRequest:req cBlock:^(id connection, NSData *data){
        self.textView.text = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    }pBlock:nil eBlock:nil];
}

@end
