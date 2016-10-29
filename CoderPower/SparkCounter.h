//
//  SparkCounter.h
//  CoderPower
//
//  Created by tyzual on 29/10/2016.
//  Copyright © 2016 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SparkCounter : NSObject

+(instancetype) getInstance;

-(uint32_t) getSparkCount;

@end
