//  FISJukeboxViewController.m

#import "FISJukeboxViewController.h"
#import "FISPlaylist.h"

@interface FISJukeboxViewController ()

@property (strong, nonatomic) FISPlaylist *playlist;
@property (weak, nonatomic) IBOutlet UITextView *playlistView;
@property (weak, nonatomic) IBOutlet UITextField *songSelectorField;

@end

@implementation FISJukeboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self setup];
}

-(void)setup
{
    self.playlist = [[FISPlaylist alloc] init];
    self.playlistView.text = self.playlist.text;
}

-(void)dismissKeyboard
{
    [self.songSelectorField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAVAudioPlayWithFileName:(NSString *)fileName
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:fileName
                                         ofType:@"mp3"]];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]
                    initWithContentsOfURL:url
                    error:&error];
    if (error) {
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    } else {
        [self.audioPlayer prepareToPlay];
    }
}


- (IBAction)playButtonTapped:(id)sender {
    NSUInteger trackNumber = [self.songSelectorField.text integerValue];
    FISSong *selectedSong = [self.playlist songForTrackNumber:trackNumber];
    
    if (selectedSong) {
        [self setupAVAudioPlayWithFileName:selectedSong.fileName];
        [self.audioPlayer play];
    } else {
        self.songSelectorField.text = nil;
    }
    
    [self dismissKeyboard];
}

- (IBAction)stopButtonTapped:(id)sender {
    [self dismissKeyboard];
    [self.audioPlayer stop];
}

@end
