//
//  SQLManager.h
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 7/12/11.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "inc.h"
#import "Project.h"


@interface SQLManager : NSObject {
	
	sqlite3*				m_Database;
}

- (id)init;

- (BOOL)checkProjectsDB;
- (BOOL)createProjectsDB;
- (NSMutableArray*)readProjectsFromDB;
- (BOOL)saveProjects:(NSMutableArray*)projects;

- (void)saveProject:(Project*)project;


@end
