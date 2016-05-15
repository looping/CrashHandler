//
//  ViewController.m
//  testCrash
//
//  Created by Looping on 5/15/16.
//  Copyright © 2016 RidgeCorn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[];
    
    NSLog(@"%@", array[2]);
    
    NSMutableArray *arrayM = [@[] mutableCopy];
    
    id obj;
    
    [arrayM addObject:obj];
    [arrayM addObject:@""];
    
    [arrayM insertObject:@"" atIndex:3];
    
    NSMutableDictionary *dictionaryM = [@{} mutableCopy];
    
    [dictionaryM setObject:obj forKey:@""];
    
    [self crashMe];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [super methodSignatureForSelector:aSelector];
}

@end
