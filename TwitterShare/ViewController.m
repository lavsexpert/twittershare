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
@property (weak, nonatomic) IBOutlet UITextView *facebookTextiView;
@property (weak, nonatomic) IBOutlet UITextView *popupTextView;

- (void) configureTextView :(int) typeView :(UITextView *) view;
- (void) showAlertMessage :(NSString *) myMessage;

@end

@implementation ViewController

int const TWEET_VIEW = 1;
int const FACEBOOK_VIEW = 2;
int const POPUP_VIEW = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Оформление TextView
    [self configureTextView :TWEET_VIEW :self.tweetTextView];
    [self configureTextView :FACEBOOK_VIEW :self.facebookTextiView];
    [self configureTextView :POPUP_VIEW :self.popupTextView];
}

// Показ сообщения в модальном окне
- (void) showAlertMessage: (NSString *) myMessage{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Поделиться" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// При нажатии на кнопку
- (IBAction)showShareAction:(id)sender {
    // Скрываем клавиатуру если она открыта
    if([self.tweetTextView isFirstResponder]){
        [self.tweetTextView resignFirstResponder];
    }
    
    // Настраиваем окно с сообщением
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Поделиться" message:@"Где поделиться текстом?" preferredStyle:UIAlertControllerStyleAlert];
    
    // Настраиваем кнопку отмены
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault  handler:nil];
    
    // Настраиваем кнопку tweet
    UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:@"Твитнуть" style:UIAlertActionStyleDefault  handler:
          ^(UIAlertAction *action){
              if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                  SLComposeViewController *twitterVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                  
                  // Отправляем текст в Twitter (обрезая до 140 символов, если он длиннее)
                  if([self.tweetTextView.text length] < 140){
                      [twitterVC setInitialText:self.tweetTextView.text];
                  } else {
                      NSString *shortText = [self.tweetTextView.text substringToIndex:140];
                      [twitterVC setInitialText:shortText];
                  }
                  [self presentViewController:twitterVC animated:YES completion:nil];
                  
              // Если не удалось подключиться к Twitter - сообщаем об этом
              } else {
                  [self showAlertMessage:@"Ты не вошёл в Twitter"];
              }
          }];
    
    // Настраиваем кнопку facebook
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Пост в Фейсбуке" style:UIAlertActionStyleDefault  handler:^(UIAlertAction *action){
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
            //[self showShareAction:@"Фейсбук доступен"];
            SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookVC setInitialText:self.tweetTextView.text];
            [self presentViewController:facebookVC animated:YES completion:nil];
        } else {
            [self showAlertMessage:@"Войдите в Фейсбук"];
        }
    }];
    
    // Настраиваем кнопку Ещё
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"Ещё" style:UIAlertActionStyleDefault  handler:^(UIAlertAction *action){
        UIActivityViewController *moreVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.tweetTextView.text] applicationActivities:nil];
        [self presentViewController:moreVC animated:YES completion:nil];
        
    }];

    // Добавляем кнопки
    [actionController addAction:tweetAction];
    [actionController addAction:facebookAction];
    [actionController addAction:moreAction];
    [actionController addAction:cancelAction];

    // Показываем окно с сообщением
    [self presentViewController:actionController animated:YES completion:nil];
}

// Оформление текстового поля
- (void) configureTextView :(int) typeView :(UITextView*) view{
    switch (typeView) {
        case TWEET_VIEW:
            view.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0].CGColor;
            view.layer.cornerRadius = 10.0;
            view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            view.layer.borderWidth = 2.0;
            break;
        case FACEBOOK_VIEW:
            view.layer.backgroundColor = [UIColor colorWithRed:1.0 green:0.9 blue:1.0 alpha:1.0].CGColor;
            view.layer.cornerRadius = 20.0;
            view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            view.layer.borderWidth = 3.0;
            break;
        case POPUP_VIEW:
            view.layer.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:1.0 alpha:1.0].CGColor;
            view.layer.cornerRadius = 30.0;
            view.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
            view.layer.borderWidth = 4.0;
            break;

        default:
            break;
    }

}

@end
