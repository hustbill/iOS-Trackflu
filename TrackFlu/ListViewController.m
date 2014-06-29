//
//  ListViewController.m
//  TrackFlu
//
//  Created by Hua Zhang on 5/1/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "ListViewController.h"
#import <sqlite3.h>

static NSString * const BaseURLString = @"https://bend.encs.vancouver.wsu.edu/~billyzhang/trackflu/";

@interface ListViewController ()

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *myDatabase;
@property (strong, nonatomic) NSString *statusOfGettingDataFromDB;
@property (strong, nonatomic) NSMutableArray *list;

@end

@implementation ListViewController

@synthesize databasePath;
@synthesize myDatabase;
@synthesize statusOfGettingDataFromDB;
@synthesize list;


-(instancetype)init {
    //Call the superclass's designed initializer
    self = [super initWithStyle:UITableViewStylePlain];
    return self ;
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init] ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getTextFomDB];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getTextFomDB {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //NSString *url = [NSString stringWithFormat:@"%@sampleDatabase.db", BaseURLString];
    NSString *url = @"sampleDatabase.db";
    // NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]
                    initWithString: [docsDir stringByAppendingPathComponent:url]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT * FROM SAMPLETABLE   ORDER BY MESSAGE DESC";
        
        const char *query_stmt = [querySQL UTF8String];
        list =[[NSMutableArray alloc] init];
        
        if (sqlite3_prepare_v2(myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            [list removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *text = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [list addObject:text];
                statusOfGettingDataFromDB = @"Found!";
                NSLog(@"count: %d", [list count]);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
}


- (IBAction)deleteTextFromDatabase:(id)sender
{

    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    //NSString *url = [NSString stringWithFormat:@"%@sampleDatabase.db", BaseURLString];
    NSString *url = @"sampleDatabase.db";
    // NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    
    // Build the path to the database file
    databasePath = [[NSString alloc]
                    initWithString: [docsDir stringByAppendingPathComponent:url]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK)
    {
        NSString *querySQL = @"Delete from SAMPLETABLE where MESSAGE";
        
        const char *query_stmt = [querySQL UTF8String];
        list =[[NSMutableArray alloc] init];
        
        if (sqlite3_prepare_v2(myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            [list removeAllObjects];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *text = [[NSString alloc]
                                  initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 1)];
                [list addObject:text];
                statusOfGettingDataFromDB = @"Found!";
                NSLog(@"count: %d", [list count]);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(myDatabase);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
