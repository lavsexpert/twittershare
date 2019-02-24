//
//  ViewController.m
//  TwitterShare
//
//  Created by Sergey Lavrov on 20.02.2019.
//  Copyright © 2019 +1. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Оформление TextView
    [self configureTextView :TWEET_VIEW :self.tweetTextView];
    [self configureTextView :FACEBOOK_VIEW :self.facebookTextView];
    [self configureTextView :MORE_VIEW :self.moreTextView];
}

// Показ сообщения в модальном окне
- (void) showAlertMessage: (NSString *) myMessage{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Share" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)tweetShareAction :(id)sender {
    [self showShareAction :sender :TWEET_VIEW :self.tweetTextView];
}
- (IBAction)facebookShareAction :(id)sender {
    [self showShareAction :sender :FACEBOOK_VIEW :self.facebookTextView];
}
- (IBAction)avcShareAction :(id)sender {
    [self showShareAction :sender :MORE_VIEW :self.moreTextView];
}
- (IBAction)popupShareAction :(id)sender {
    [self showShareAction :sender :MORE_VIEW :self.moreTextView];
}


// При нажатии на кнопку
- (IBAction)showShareAction :(id)sender :(int) typeView :(UITextView *) view{
    // Скрываем клавиатуру если она открыта
    if([view isFirstResponder]){
        [view resignFirstResponder];
    }
    
    switch (typeView) {
        case TWEET_VIEW:
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                // Отправляем текст в Twitter (обрезая до 140 символов, если он длиннее)
                if([view.text length] < 140){
                    [twitterVC setInitialText:view.text];
                } else {
                    NSString *shortText = [view.text substringToIndex:140];
                    [twitterVC setInitialText:shortText];
                }
                [self presentViewController:twitterVC animated:YES completion:nil];
                
                // Если не удалось подключиться к Twitter - сообщаем об этом
            } else {
                [self showAlertMessage:@"Please, sign to Twitter"];
            }
            break;
            
        case FACEBOOK_VIEW:
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
                //[self showShareAction:@"Фейсбук доступен"];
                SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [facebookVC setInitialText:view.text];
                [self presentViewController:facebookVC animated:YES completion:nil];
            } else {
                [self showAlertMessage:@"Please, enter to the Facebook"];
            }
            break;
            
        case MORE_VIEW:
            /*
             UIActivityViewController *moreVC = [UIActivityViewController alloc];
             [moreVC initWithActivityItems:@[view.text] applicationActivities:nil];
             [self presentViewController:moreVC animated:YES completion:nil];
             */
            break;
            
        default:
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
