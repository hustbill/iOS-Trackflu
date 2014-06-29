//
//  AddFluInfoViewController.m
//  TrackFlu
//
//  Created by hua zhang on 5/6/14.
//  Copyright (c) 2014 WSUV. All rights reserved.
//

#import "AddFluInfoViewController.h"
#import <sqlite3.h>

static NSString * const BaseURLString = @"https://bend.encs.vancouver.wsu.edu/~billyzhang/trackflu/";

@interface AddFluInfoViewController ()  <UITextFieldDelegate>
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *myDatabase;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSString *statusOfAddingToDB;
@end


@implementation AddFluInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add";
    [self prepareDatabase];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addTextToDatabase:(id)sender
{
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO SAMPLETABLE (MESSAGE) VALUES (\"%@\")",
                               self.textField.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            _statusOfAddingToDB = [NSString stringWithFormat:@"Text added -- %@", _textField.text];
        } else {
            _statusOfAddingToDB = @"Failed to add contact";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:_statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}

- (void)prepareDatabase
{
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    // Build the path to the database file
    //  NSString *url = [NSString stringWithFormat:@"%@sampleDatabase.db", BaseURLString];
    // _databasePath = [[NSString alloc] initWithString: url];
    
    
    NSString *fileName = @"sampleDatabase.db";
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:fileName]];
    NSLog(@"DB Path: %@", _databasePath);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO) {
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS SAMPLETABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, MESSAGE TEXT)";
            
            if (sqlite3_exec(_myDatabase, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                _statusOfAddingToDB = @"Failed to create table";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:_statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                _statusOfAddingToDB = @"Success in creating table";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:_statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            sqlite3_close(_myDatabase);
        } else {
            _statusOfAddingToDB = @"Failed to open/create database";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:_statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        
        //Create the database file on NSDocumentDirectory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        [filemgr changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
        
        // create the file for given fileName
        [filemgr createFileAtPath:fileName contents:nil attributes:nil];
        
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS SAMPLETABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, MESSAGE TEXT)";
            
            if (sqlite3_exec(_myDatabase, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                _statusOfAddingToDB = @"Failed to create table";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:_statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                _statusOfAddingToDB = @"Success in creating table";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:_statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            sqlite3_close(_myDatabase);
        } else {
            _statusOfAddingToDB = @"Failed to open/create database";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:_statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    if (tf == _textField) {
        [tf resignFirstResponder];
    }
    return NO;
}


- (IBAction) textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}


@end


