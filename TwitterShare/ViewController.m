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

- (void) configureTweetTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTweetTextView];
}

- (IBAction)showShareAction:(id)sender {
    if([self.tweetTextView isFirstResponder]){
        [self.tweetTextView resignFirstResponder];
    }
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Test title" message:@"Tweet your note" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:actionController animated:YES completion:nil];
}

- (void) configureTweetTextView{
    self.tweetTextView.layer.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0].CGColor;
    self.tweetTextView.layer.cornerRadius = 10.0;
    self.tweetTextView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    self.tweetTextView.layer.borderWidth = 2.0;
}

@end
