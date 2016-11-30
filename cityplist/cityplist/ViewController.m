//
//  ViewController.m
//  cityplist
//
//  Created by 白永炳 on 16/11/10.
//  Copyright © 2016年 BYB. All rights reserved.
//

#import "ViewController.h"


@interface cityInfoModel : NSObject

@property(nonatomic, strong)NSString *province;
@property(nonatomic, strong)NSString *pro_code;
@property(nonatomic, strong)NSString *city;
@property(nonatomic, strong)NSString *code;

@end

@implementation cityInfoModel

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self getSingleCityInfo];
    
    /*
//NSArray *arr = [self getCityListWithProvince:@"河北省"];
 //   for (NSString *city in arr) {
        NSLog(@"city == %@", city);
   // }
 //   NSLog(@"count == %ld",  arr.count);
     */
}

-(NSArray *)getProvinceList
{
    NSMutableArray *provinceList=[[NSMutableArray alloc]init];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    if (path==nil) {
        NSLog(@"没有检测到plist资源文件");
    }
    NSArray *array=[NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dictionary in array) {
        [provinceList addObject:[dictionary objectForKey:@"province"]];
    }
    return provinceList;
    
}
-(NSArray *)getCityListWithProvince:(NSString *)province
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    if (path==nil) {
        NSLog(@"没有检测到plist资源文件");
    }
    NSArray *array=[NSArray arrayWithContentsOfFile:path];
    NSMutableArray *cityList=[[NSMutableArray alloc]init];
    for (NSDictionary *dictionary in array) {
        if ([province isEqualToString:[dictionary objectForKey:@"province"]])
        {
            NSArray *array= [dictionary objectForKey:@"citys"];
            for (NSDictionary *cityDictionary in array) {
                [cityList addObject:[cityDictionary objectForKey:@"city"]];
            }
        }
    }
    return cityList;
}


- (void)getSingleCityInfo
{
    
    NSString *cityInfoPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSString *cityInfos = [[NSString alloc] initWithContentsOfFile:cityInfoPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *cityInfoArr= [cityInfos componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSLog(@"cityinfoCount == %ld", cityInfoArr.count);
    
    NSString *cityPlistPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/city.plist"];
    
    NSMutableArray *plistInfoArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i = 0 ; i < cityInfoArr.count ; i++) {
        
        cityInfoModel *model = [self singleInfowithStr:cityInfoArr[i]];
        [modelArr addObject: model];
        
    }
    
    for (NSInteger i = 0 ; i < modelArr.count ; i++) {
        
        cityInfoModel *model = modelArr[i];
        NSLog(@"city == %@", model.city);
        
        if (plistInfoArr.count > 0) {
            
            cityInfoModel *lastModel = modelArr[i-1];
            if ([lastModel.province isEqualToString:model.province]) {
                NSMutableArray *cityArr = [plistInfoArr.lastObject objectForKey:@"citys"];
                [cityArr addObject:@{@"city":model.city,@"code":model.code}];
                
            }else
            {
                NSMutableArray *cityArr = [[NSMutableArray alloc] init];
                [cityArr addObject:@{@"city":model.city,@"code":model.code}];
                [plistInfoArr addObject:@{@"province":model.province,@"procode":model.pro_code,@"citys":cityArr}];
            }
        }else
        {
            NSMutableArray *cityArr = [[NSMutableArray alloc] init];
            [cityArr addObject:@{@"city":model.city,@"code":model.code}];
            [plistInfoArr addObject:@{@"province":model.province,@"procode":model.pro_code,@"citys":cityArr}];
        }
        
    }
    NSLog(@"plist == %@", plistInfoArr);
    
    [plistInfoArr writeToFile:cityPlistPath atomically:YES];
    
}


- (cityInfoModel *)singleInfowithStr:(NSString *)info
{
    NSArray *infoArr = [[NSArray alloc] init];
    if (info.length > 0&&info != nil) {
        infoArr = [info componentsSeparatedByString:@"\t"];
    }
    
//    for ( NSString *STR in infoArr) {
//        NSLog(@"%@", STR);
//    }
    cityInfoModel *model = [[cityInfoModel alloc] init];
    model.code = infoArr.firstObject;
    model.pro_code = infoArr[1];
    model.city = infoArr[3];
    
    NSArray *arr = [infoArr[5] componentsSeparatedByString:@"，"];
    if (arr.count == 2) {
        model.province = arr.lastObject;
    }else
    {
        model.province = arr[1];
    }
    
    return model;
}

@end
