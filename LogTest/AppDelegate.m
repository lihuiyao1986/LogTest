//
//  AppDelegate.m
//  LogTest
//
//  Created by jk on 2017/4/26.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLumberjack.h>
#import "CatchCrash.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    //这将在你的日志框架中添加两个“logger”。也就是说你的日志语句将被发送到Console.app和Xcode控制 台（就像标准的NSLog）
    
    //这个框架的好处之一就是它的灵活性，如果你还想要你的日志语句写入到一个文件中，你可以添加和配置一个file logger:
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
    
    [self uploadErrorLog];
    
    //注册消息处理函数的处理方法
    //如此一来，程序崩溃时会自动进入CatchCrash.m的uncaughtExceptionHandler()方法
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // Override point for customization after application launch.
    return YES;
}

-(void)uploadErrorLog{
    
    //若crash文件存在，则写入log并上传，然后删掉crash文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *errorLogPath = [NSString stringWithFormat:@"%@/Documents/error.log", NSHomeDirectory()];
    
    if ([fileManager fileExistsAtPath:errorLogPath]) {
        //用CocoaLumberJack库的fileLogger.logFileManager自带的方法创建一个新的Log文件，这样才能获取到对应文件夹下排序的Log文件
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
        
        [fileLogger.logFileManager createNewLogFile];
        //此处必须用firstObject而不能用lastObject，因为是按照日期逆序排列的，即最新的Log文件排在前面
        NSString *newLogFilePath = [fileLogger.logFileManager sortedLogFilePaths].firstObject;
        NSError *error = nil;
        NSString *errorLogContent = [NSString stringWithContentsOfFile:errorLogPath encoding:NSUTF8StringEncoding error:nil];
        DLog(@"错误日志内容%@",errorLogContent);
        BOOL isSuccess = [errorLogContent writeToFile:newLogFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (!isSuccess) {
            DLog(@"crash文件写入log失败: %@", error.userInfo);
        } else {
            DLog(@"crash文件写入log成功");
            NSError *error = nil;
            BOOL isSuccess = [fileManager removeItemAtPath:errorLogPath error:&error];
            if (!isSuccess) {
                DLog(@"删除本地的crash文件失败: %@", error.userInfo);
            }
        }
        
        //上传最近的3个log文件，
        //至少要3个，因为最后一个是crash的记录信息，另外2个是防止其中后一个文件只写了几行代码而不够分析
        NSArray *logFilePaths = [fileLogger.logFileManager sortedLogFilePaths];
        NSUInteger logCounts = logFilePaths.count;
        if (logCounts >= 3) {
            for (NSUInteger i = 0; i < 3; i++) {
                NSString *logFilePath = logFilePaths[i];
                //上传服务器
            
            }
        } else {
            for (NSUInteger i = 0; i < logCounts; i++) {
                NSString *logFilePath = logFilePaths[i];
                //上传服务器
                
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
