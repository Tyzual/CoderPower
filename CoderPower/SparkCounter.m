//
//  SparkCounter.m
//  CoderPower
//
//  Created by tyzual on 29/10/2016.
//  Copyright © 2016 Dawn. All rights reserved.
//

#import "SparkCounter.h"

@interface SparkCounter ()

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) dispatch_queue_t dispatchQueue;
@property (nonatomic) uint32_t sparkCount;

@end

@implementation SparkCounter

+(instancetype) getInstance {
	static dispatch_once_t _onceFlag = 0;
	static SparkCounter *_instance = nil;
	dispatch_once(&_onceFlag, ^{
		_instance = [[SparkCounter alloc] init];
	});
	return _instance;
}

-(instancetype) init {
	if ((self = [super init]) != nil) {
		self.dispatchQueue = dispatch_queue_create("Spark Counter", DISPATCH_QUEUE_SERIAL);
		self.timer = nil;
		self.sparkCount = 0;
	}
	return self;
}

-(uint32_t) getSparkCount {
	dispatch_sync(self.dispatchQueue, ^{
		@autoreleasepool {
			[self.timer invalidate];
			self.timer = nil;
			self.sparkCount += 5;
			
			dispatch_async(dispatch_get_main_queue(), ^{
				@autoreleasepool {
					self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block:^(NSTimer * _Nonnull timer) {
						[self resetSparkCount];
					}];
				}
			});
		}
	});
	return self.sparkCount;
}

-(void) resetSparkCount {
	dispatch_async(self.dispatchQueue, ^{
		@autoreleasepool {
			self.sparkCount = 0;
		}
	});
}

@end
