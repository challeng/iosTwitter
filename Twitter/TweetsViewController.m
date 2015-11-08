//
//  TweetsViewController.m
//  Twitter
//
//  Created by Jim Challenger on 11/8/15.
//  Copyright © 2015 Jim Challenger. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import <UIImageView+AFNetworking.h>

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    UITableViewController *dummyTableVC = [[UITableViewController alloc] init];
    dummyTableVC.tableView = self.tableView;
    dummyTableVC.refreshControl = self.refreshControl;
}

- (void)setupTable {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    User *user = tweet.user;
    
    cell.tweetLabel.text = tweet.text;
    cell.userName.text = tweet.user.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSString *stringFromDate = [formatter stringFromDate:tweet.createdAt];
    cell.timestamp.text = stringFromDate;
    
    [cell.userImage setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)fetchTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)onLogout:(id)sender {
    [User logout];
}

- (IBAction)onCompose:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"test tweet!!" forKey:@"status"];
    [[TwitterClient sharedInstance] publishTweetWithParams:params completion:^(NSObject *tweet, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
