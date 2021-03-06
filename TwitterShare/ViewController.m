//
//  ViewController.m
//  TwitterShare
//
//  Created by Sergey Lavrov on 20.02.2019.
//  Copyright © 2019 +1. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController()

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UITextView *facebookTextView;
@property (weak, nonatomic) IBOutlet UITextView *moreTextView;

- (void) configureTextView :(int) typeView :(UITextView *) view;
- (void) showAlertMessage :(NSString *) myMessage;

@end

@implementation ViewController

int const TWEET_VIEW = 1;
int const FACEBOOK_VIEW = 2;
int const MORE_VIEW = 3;

int const TWEET_BUTTON = 1;
int const FACEBOOK_BUTTON = 2;
int const MORE_BUTTON = 3;
int const POPUP_BUTTON = 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Оформление TextView
    [self configureTextView :TWEET_VIEW :self.tweetTextView];
    [self configureTextView :FACEBOOK_VIEW :self.facebookTextView];
    [self configureTextView :MORE_VIEW :self.moreTextView];
}

- (void) showAlertMessage: (NSString *) myMessage{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Share" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)tweetShareAction :(id)sender {
    [self showShareAction :sender :TWEET_BUTTON :self.tweetTextView];
}
- (IBAction)facebookShareAction :(id)sender {
    [self showShareAction :sender :FACEBOOK_BUTTON :self.facebookTextView];
}
- (IBAction)avcShareAction :(id)sender {
    [self showShareAction :sender :MORE_BUTTON :self.moreTextView];
}
- (IBAction)popupShareAction :(id)sender {
    [self showShareAction :sender :POPUP_BUTTON :self.moreTextView];
}

- (IBAction)showShareAction :(id)sender :(int) typeButton :(UITextView *) view{
    if([view isFirstResponder]){
        [view resignFirstResponder];
    }
    
    switch (typeButton) {
        case TWEET_BUTTON:
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                if([view.text length] < 140){
                    [twitterVC setInitialText:view.text];
                } else {
                    NSString *shortText = [view.text substringToIndex:140];
                    [twitterVC setInitialText:shortText];
                }
                [self presentViewController:twitterVC animated:YES completion:nil];
                
            } else {
                [self showAlertMessage:@"Please, sign to Twitter"];
            }
            break;
            
        case FACEBOOK_BUTTON:
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
                SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [facebookVC setInitialText:view.text];
                [self presentViewController:facebookVC animated:YES completion:nil];
            } else {
                [self showAlertMessage:@"Please, enter to the Facebook"];
            }
            break;
            
        case MORE_BUTTON:
            if([UIActivityViewController alloc]){
                UIActivityViewController *moreVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.moreTextView.text] applicationActivities:nil];
                [self presentViewController:moreVC animated:YES completion:nil];
            } else {
                [self showAlertMessage:@"We have a problem with Dialog"];
            }
            break;
            
        case POPUP_BUTTON:
            if(![UIActivityViewController alloc]){
                break;
            }

            UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Share" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:@"Tweet" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self showShareAction :sender :TWEET_BUTTON :self.tweetTextView];
            }];
            UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self showShareAction :sender :FACEBOOK_BUTTON :self.facebookTextView];
            }];
            UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"More" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [self showShareAction :sender :MORE_BUTTON :self.moreTextView];
            }];

            [actionController addAction:tweetAction];
            [actionController addAction:facebookAction];
            [actionController addAction:moreAction];
            [actionController addAction:cancelAction];
            [self presentViewController:actionController animated:YES completion:nil];
            break;
            
    }
}

// Оформление текстового поля
- (void) configureTextView :(int) typeView :(UITextView*) view{
    switch (typeView) {
        case TWEET_VIEW:
            view.layer.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.95 alpha:1.0].CGColor;
            view.layer.cornerRadius = 10.0;
            view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            view.layer.borderWidth = 2.0;
            break;
        case FACEBOOK_VIEW:
            view.layer.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.5 alpha:1.0].CGColor;
            view.layer.cornerRadius = 20.0;
            view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            view.layer.borderWidth = 3.0;
            break;
        case MORE_VIEW:
            view.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.5 alpha:1.0].CGColor;
            view.layer.cornerRadius = 30.0;
            view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            view.layer.borderWidth = 4.0;
            break;

        default:
            break;
    }

}

@end
