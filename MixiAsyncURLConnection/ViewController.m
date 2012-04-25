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
}

- (void)dealloc
{
    self.textView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//ボタン1を押した時のイベントハンドラ
//http://mixi.jp/にGETリクエストを投げて、レスポンスをtextViewに表示します。
- (IBAction)pressButton1:(id)sender
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mixi.jp/"]];

    MixiAsyncURLConnection * connection = [[[MixiAsyncURLConnection alloc]initWithRequest:req timeoutSec:10.0f completeBlock:^(id connection, NSData *data){
        self.textView.text = [[[NSString alloc]initWithData:data encoding:NSJapaneseEUCStringEncoding]autorelease];
    } progressBlock:nil errorBlock:nil] autorelease];
    
    [connection performRequest];
}

//ボタン2を押した時のイベントハンドラ
//http://localhost:3000/にGETリクエストを投げて、レスポンスをtextViewに表示します。
- (IBAction)pressButton2:(id)sender
{
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/"]];
    
    MixiAsyncURLConnection * connection = [[[MixiAsyncURLConnection alloc]initWithRequest:req timeoutSec:10.0f completeBlock:^(id connection, NSData *data){
        self.textView.text = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    } progressBlock:nil errorBlock:^(id connection, NSError *error){
        self.textView.text = error.localizedDescription;
    }] autorelease];
    
    [connection performRequest];

}

//ボタン3を押した時のイベントハンドラ
//http://localhost:3000/にPOSTリクエストを投げて、レスポンスをtextViewに表示します。
- (IBAction)pressButton3:(id)sender
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/"]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[@"data=hogefuga" dataUsingEncoding:NSUTF8StringEncoding]];
    
    MixiAsyncURLConnection * connection = [[[MixiAsyncURLConnection alloc]initWithRequest:req timeoutSec:1.0f completeBlock:^(id connection, NSData *data){
        self.textView.text = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    } progressBlock:nil errorBlock:^(id connection, NSError *error){
        self.textView.text = error.localizedDescription;
    }] autorelease];

    [connection performRequest];
}

@end
