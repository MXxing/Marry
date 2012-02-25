//
//  RequestResult.m
//  Marry
//
//  Created by EagleDu on 12/2/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RequestResult.h"

@implementation RequestResult
@synthesize success;
@synthesize error;
@synthesize errorMsg;
@synthesize extraData;
@synthesize requestXHR;

-(id)init:(BOOL) isSuccess error:(NSError *)err errorMsg:(NSString*) errMsg extraData:(id) extra httpRequest:(ASIHTTPRequest*) request;
{
    if(self=[super init]){
        success=isSuccess;
        error=err;
        errorMsg=errMsg;
        extraData=extra;
        requestXHR=request;
    }
    return self;
}
@end
