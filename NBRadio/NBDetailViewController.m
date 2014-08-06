//
//  NBDetailViewController.m
//  NBRadio
//
//  Created by Kanybek Momukeev on 06/08/14.
//  Copyright (c) 2014 Kanybek Momukeev. All rights reserved.
//

#import "NBDetailViewController.h"
#import "FSAudioController.h"
#import "FSAudioStream.h"
#import "FSPlaylistItem.h"
#import "SVProgressHUD.h"


@interface NBDetailViewController ()
@property (nonatomic, strong) FSAudioController *audioController;
@property (nonatomic, weak) IBOutlet UILabel *streamTitleLabel;
@end

@implementation NBDetailViewController


- (FSAudioController *)audioController
{
    if (!_audioController) {
        _audioController = [[FSAudioController alloc] init];
    }
    return _audioController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamStateDidChange:)
                                                 name:FSAudioStreamStateChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamErrorOccurred:)
                                                 name:FSAudioStreamErrorNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamMetaDataAvailable:)
                                                 name:FSAudioStreamMetaDataNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.audioController.url = [NSURL URLWithString:[self.detailItem objectForKey:@"radio_source"]];
    [self.audioController play];
    [self.audioController setVolume:0.5];
    self.title = [self.detailItem objectForKey:@"name"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.audioController stop];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)volumeDidChanged:(UISlider *)sender
{
    [self.audioController setVolume:sender.value];
}

#pragma mark - Selector methods
- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification
{
    
}

- (void)audioStreamStateDidChange:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    int state = [[dict valueForKey:FSAudioStreamNotificationKey_State] intValue];
    
    switch (state) {
        case kFsAudioStreamRetrievingURL:{

            [SVProgressHUD showWithStatus:@"Retrieving URL..."];
            }
            break;
            
        case kFsAudioStreamStopped:{

            }
            break;
            
        case kFsAudioStreamBuffering:{
                [SVProgressHUD showWithStatus:@"Buffering..."];
            }
            break;
            
        case kFsAudioStreamSeeking: {
                [SVProgressHUD showWithStatus:@"Seeking..."];
            }
            break;
            
        case kFsAudioStreamPlaying: {
            [SVProgressHUD dismiss];
        }
            break;
            
        case kFsAudioStreamFailed: {
            [SVProgressHUD showErrorWithStatus:@"Failed"];
        }
            break;
    }
}

- (void)audioStreamErrorOccurred:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    int errorCode = [[dict valueForKey:FSAudioStreamNotificationKey_Error] intValue];
    NSString *errorDescription;
    
    switch (errorCode) {
        case kFsAudioStreamErrorOpen:
            errorDescription = @"Cannot open the audio stream";
            break;
        case kFsAudioStreamErrorStreamParse:
            errorDescription = @"Cannot read the audio stream";
            break;
        case kFsAudioStreamErrorNetwork:
            errorDescription = @"Network failed: cannot play the audio stream";
            break;
        case kFsAudioStreamErrorUnsupportedFormat:
            errorDescription = @"Unsupported format";
            break;
        case kFsAudioStreamErrorStreamBouncing:
            errorDescription = @"Network failed: cannot get enough data to play";
            break;
        default:
            errorDescription = @"Unknown error occurred";
            break;
    }
    
    [SVProgressHUD showErrorWithStatus:errorDescription];
}

- (void)audioStreamMetaDataAvailable:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSDictionary *metaData = [dict valueForKey:FSAudioStreamNotificationKey_MetaData];
    NSMutableString *streamInfo = [[NSMutableString alloc] init];
    
    [metaData enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop){
        [streamInfo appendString:metaData[key]];
    }];
    
//    if (metaData[@"MPMediaItemPropertyArtist"] &&
//        metaData[@"MPMediaItemPropertyTitle"]) {
//        [streamInfo appendString:metaData[@"MPMediaItemPropertyArtist"]];
//        [streamInfo appendString:@" - "];
//        [streamInfo appendString:metaData[@"MPMediaItemPropertyTitle"]];
//    } else if (metaData[@"StreamTitle"]) {
//        [streamInfo appendString:metaData[@"StreamTitle"]];
//    }
    
    NSLog(@"%@", metaData);
    self.streamTitleLabel.text = streamInfo;
}

@end
