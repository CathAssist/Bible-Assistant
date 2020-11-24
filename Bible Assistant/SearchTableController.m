//
//  SearchTableController.m
//  Bible Assistant
//
//  Created by yaojinhai on 2020/11/24.
//  Copyright © 2020 nixWork. All rights reserved.
//

#import "SearchTableController.h"
#import "SearchResultCell.h"

#import "BAAppDelegate.h"
#import <Ono.h>

@interface SearchTableController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    NSMutableArray* bibleSearchResults;
    UISearchBar *bibleSearchBar;
}
@end

@implementation SearchTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    bibleSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 260, 32)];
//    self.navigationController.navigationItem
    bibleSearchBar.delegate = self;
    self.navigationItem.titleView = bibleSearchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bibleSearchResults.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    if (bibleSearchResults.count <= indexPath.row) {
        cell.titleLabel.text = @"title";
        cell.contentLabel.text = @"content";
        return  cell;
    }
    
    NSDictionary *volume = bibleSearchResults[indexPath.section];
    NSArray *volumeChapters = volume[@"volumeChapters"];
    NSDictionary *resultDic = volumeChapters[indexPath.row];
    
    //NSLog(@"resultDic %@", resultDic);
    
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", resultDic[@"volume"], resultDic[@"chapter"] ,resultDic[@"sectionNumText"]];//resultDic[@"volume"];
    
    cell.contentLabel.text = resultDic[@"text"];
#if 0
//    cell.c.text = resultDic[@"text"];
#else
    NSString *text = resultDic[@"text"];
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"(%@)", bibleSearchBar.text] options:kNilOptions error:nil];

    NSRange range = NSMakeRange(0, text.length);
    
    [regex enumerateMatchesInString:text options:kNilOptions range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange subStringRange = [result rangeAtIndex:1];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor alizarinColor] range:subStringRange];
    }];
    
    cell.contentLabel.attributedText = mutableAttributedString;
#endif
    
    return cell;
    
    return  cell;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self searchBibleWithString:searchBar.text];
}


- (void)searchBibleWithString:(NSString *)string {
    
    bibleSearchResults = [NSMutableArray array];
    
    ONOXMLDocument *bible = ((BAAppDelegate *)[[UIApplication sharedApplication] delegate]).bible;
    
    for (ONOXMLElement *element in bible.rootElement.children) {
        if ([element.tag isEqualToString:@"template"]) {
            NSString *volumeTitle = element.attributes[@"name"];
            NSString *volumeBigTitle = element.attributes[@"sname"];
            
            NSString *volumeNum = element.attributes[@"value"];
            
            NSMutableArray *volumeChapters = [NSMutableArray array];
            
            for (ONOXMLElement *elementChapter in element.children) {
                if ([elementChapter.tag isEqualToString:@"chapter"]) {
                    
                    NSString *chapterTitle = elementChapter.attributes[@"title"];
                    NSString *chapterNum = elementChapter.attributes[@"value"];
                    
                    NSInteger sectionNum = 0;
                    for (ONOXMLElement *elementSection in elementChapter.children) {
                        if ([elementSection.tag isEqualToString:@"section"]) {
                            
                            NSString *bibleText = elementSection.stringValue;
                            if ([bibleText rangeOfString:string].location != NSNotFound) {
                                
                                NSString *sectionNumText = elementSection.attributes[@"value"];
                                [volumeChapters addObject:@{@"volume":volumeTitle,
                                                            @"volumeNum":volumeNum,
                                                            @"chapter":chapterTitle,
                                                            @"chapterNum":chapterNum,
                                                            @"sectionNum":@(sectionNum),
                                                            @"sectionNumText":sectionNumText,
                                                            @"text":bibleText}];
                            }
                        }
                        sectionNum++;
                    }
                }
            }
            if (volumeChapters.count > 0) {
                [bibleSearchResults addObject:@{@"volumeChapters": volumeChapters, @"volumeBigTitle": volumeBigTitle}];
            }
            
        }
    }
}

@end
