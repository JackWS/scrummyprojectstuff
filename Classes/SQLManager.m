//
//  SQLManager.m
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 7/12/11.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import "SQLManager.h"
#import "Project.h"


@implementation SQLManager

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)dealloc {
	[super dealloc];
}

- (NSString*)getCurTime {
	
	NSDate* now = [NSDate date];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* curTime = [formatter stringFromDate:now];
	[formatter release];
	
	return curTime;
}

- (BOOL)checkProjectsDB {
	
	BOOL retValue = NO;
	
	NSString* db_path = [DOCS_FOLDER stringByAppendingPathComponent:DB_NAME];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	retValue = [fileManager fileExistsAtPath:db_path];
	[fileManager release];
	
	return retValue;
}

- (BOOL)createProjectsDB {
	
	BOOL retValue = YES;
	
	NSString* db_path = [DOCS_FOLDER stringByAppendingPathComponent:DB_NAME];
	int result = sqlite3_open([db_path UTF8String], &m_Database);
	
	if(result != SQLITE_OK) {
		sqlite3_close(m_Database);
		retValue = NO;
	} else {
		char* errorMsg;
		
		// create projects table
		NSString* strQuery = SQL_Create_Projects;
		if (sqlite3_exec(m_Database, [strQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
			sqlite3_close(m_Database);
			NSAssert1(0, @"Error createing projects table: %s", errorMsg);
			retValue = NO;
		}
		
		// create tasks table
		strQuery = SQL_Create_Tasks;
		if (sqlite3_exec(m_Database, [strQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
			sqlite3_close(m_Database);
			NSAssert1(0, @"Error createing tasks table: %s", errorMsg);
			retValue = NO;
		}
		
		// create milestones table
		strQuery = SQL_Create_Milestones;
		if (sqlite3_exec(m_Database, [strQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
			sqlite3_close(m_Database);
			NSAssert1(0, @"Error createing milestones table: %s", errorMsg);
			retValue = NO;
		}
	}
	sqlite3_close(m_Database);
	
	return retValue;
}

- (NSMutableArray*)readTasksFromDB:(NSString*)projectId {
	
	if (projectId == nil || [projectId length] < 1)
		return nil;
	
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:0];
	
	// get database path
	NSString* db_path = [DOCS_FOLDER stringByAppendingPathComponent:DB_NAME];
	
	// Open the database from the users filessytem
	if(sqlite3_open([db_path UTF8String], &m_Database) == SQLITE_OK) {
		
		// Setup the SQL Statement and compile it for faster access
		NSString* strQuery = [NSString stringWithFormat:SQL_SelectAllWithProjectID, TableName_Tasks, projectId, @"task_order"];
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(m_Database, [strQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
			
			// Loop through the results and add them to the feeds array
			while (sqlite3_step(stmt) == SQLITE_ROW) {
				
				// Read the data from the result row
				char* charProjectID = (char *)sqlite3_column_text(stmt, 0);
				char* charTaskID = (char *)sqlite3_column_text(stmt, 1);
				int taskOrder = sqlite3_column_int(stmt, 2);
				char* charTaskName = (char *)sqlite3_column_text(stmt, 3);
				char* charTaskColor = (char *)sqlite3_column_text(stmt, 4);
				int taskDuration = sqlite3_column_int(stmt, 5);
				
				NSString* projectID = (charProjectID != nil) ? [NSString stringWithUTF8String:charProjectID] : nil;
				NSString* taskID = (charTaskID != nil) ? [NSString stringWithUTF8String:charTaskID] : nil;
				NSString* taskName = (charTaskName != nil) ? [NSString stringWithUTF8String:charTaskName] : nil;
				NSString* taskColor = (charTaskColor != nil) ? [NSString stringWithUTF8String:charTaskColor] : nil;
				
				Task* task = [[Task alloc] initWithProjectID:projectID taskID:taskID order:taskOrder name:taskName color:taskColor duration:taskDuration];
				[result addObject:task];
				[task release];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(stmt);
	}
	sqlite3_close(m_Database);
	
	return result;
}

- (NSMutableArray*)readMilestonesFromDB:(NSString*)projectId {
	
	if (projectId == nil || [projectId length] < 1)
		return nil;
	
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:0];
	
	// get database path
	NSString* db_path = [DOCS_FOLDER stringByAppendingPathComponent:DB_NAME];
	
	// Open the database from the users filessytem
	if(sqlite3_open([db_path UTF8String], &m_Database) == SQLITE_OK) {
		
		// Setup the SQL Statement and compile it for faster access
		NSString* strQuery = [NSString stringWithFormat:SQL_SelectAllWithProjectID, TableName_Milestones, projectId, @"number"];
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(m_Database, [strQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
			
			// Loop through the results and add them to the feeds array
			while (sqlite3_step(stmt) == SQLITE_ROW) {
				
				// Read the data from the result row
				char* charProjectID = (char *)sqlite3_column_text(stmt, 0);
				char* charMilestoneName = (char *)sqlite3_column_text(stmt, 1);
				int milestoneNumber = sqlite3_column_int(stmt, 2);
				
				NSString* projectID = (charProjectID != nil) ? [NSString stringWithUTF8String:charProjectID] : nil;
				NSString* milestoneName = (charMilestoneName != nil) ? [NSString stringWithUTF8String:charMilestoneName] : nil;
				
				Milestone* milestone = [[Milestone alloc] initWithProjectID:projectID milestoneName:milestoneName number:milestoneNumber];
				[result addObject:milestone];
				[milestone release];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(stmt);
	}
	sqlite3_close(m_Database);
	
	return result;
}

- (NSMutableArray*)readProjectsFromDB {
	NSMutableArray* projects = [NSMutableArray arrayWithCapacity:0];
	
	// get database path
	NSString* db_path = [DOCS_FOLDER stringByAppendingPathComponent:DB_NAME];
	
	// Open the database from the users filessytem
	if(sqlite3_open([db_path UTF8String], &m_Database) == SQLITE_OK) {
		
		// Setup the SQL Statement and compile it for faster access
		NSString* strQuery = [NSString stringWithFormat:SQL_SelectAll, TableName_Projects];
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(m_Database, [strQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
			
			// Loop through the results and add them to the feeds array
			while (sqlite3_step(stmt) == SQLITE_ROW) {
				
				// Read the data from the result row
				char* charProjectID = (char *)sqlite3_column_text(stmt, 0);
				char* charProjectName = (char *)sqlite3_column_text(stmt, 1);
				char* charProjectDesc = (char *)sqlite3_column_text(stmt, 2);
				
				NSString* projectID = (charProjectID != nil) ? [NSString stringWithUTF8String:charProjectID] : nil;
				NSString* projectName = (charProjectName != nil) ? [NSString stringWithUTF8String:charProjectName] : nil;
				NSString* projectDesc = (charProjectDesc != nil) ? [NSString stringWithUTF8String:charProjectDesc] : nil;
				
				Project* project = [[Project alloc] initWithProjectID:projectID name:projectName desc:projectDesc];
				
				NSMutableArray* tasks = [self readTasksFromDB:projectID];
				[project setTasks:tasks];
				
				NSMutableArray* milestones = [self readMilestonesFromDB:projectID];
				[project setMilestones:milestones];
				
				[projects addObject:project];
				[project release];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(stmt);
	}
	sqlite3_close(m_Database);
	
	return projects;
}

- (BOOL)saveProjects:(NSMutableArray*)projects {
	
	BOOL retValue = YES;
	
	if (projects == nil || [projects count] < 1)
		return retValue;
	
	NSString* db_path = [DOCS_FOLDER stringByAppendingPathComponent:DB_NAME];
	
	if (sqlite3_open([db_path UTF8String], &m_Database) != SQLITE_OK) {
		sqlite3_close(m_Database);
		retValue = NO;
	} else {
		char* errorMsg;
		
		//@"INSERT INTO %@ (current_state, date_modified) VALUES ('%@', '%@');"
		NSString* projectQuery = nil;
		NSString* taskQuery = nil;
		NSString* milestoneQuery = nil;

		for (int prjIndex = 0; prjIndex < [projects count]; prjIndex ++) {
			Project* project = (Project*)[projects objectAtIndex:prjIndex];
			
			NSString* projectId = [project getProjectID];
			NSString* projectName = [project getProjectName];
			NSString* projectDesc = [project getProjectDesc];
			
			projectId = projectId == nil ? @"" : [projectId stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
			projectName = projectName == nil ? @"" : [projectName stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
			projectDesc = projectDesc == nil ? @"" : [projectDesc stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
			
			if (projectQuery == nil) {
				projectQuery = [NSString stringWithFormat:@"INSERT INTO %@ (project_id, project_name, project_desc) SELECT \"%@\", \"%@\", \"%@\"",
								TableName_Projects, projectId, projectName, projectDesc];
			} else {
				projectQuery = [projectQuery stringByAppendingFormat:@" UNION SELECT \"%@\", \"%@\", \"%@\"", projectId, projectName, projectDesc];
			}
			
			NSMutableArray* tasks = [project getTasks];
			if (tasks != nil && [tasks count] > 0) {
				for (int taskIndex = 0; taskIndex < [tasks count]; taskIndex ++) {
					Task* task = (Task*)[tasks objectAtIndex:taskIndex];
					if (task == nil)
						continue;
					
					NSString* taskId = [task getTaskID];
					int taskOrder = [task getTaskOrder];
					NSString* taskName = [task getTaskName];
					NSString* taskColor = [task getTaskColor];
					int taskDuration = [task getTaskDuration];
					
					taskId = taskId == nil ? @"" : [taskId stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
					taskName = taskName == nil ? @"" : [taskName stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
					taskColor = taskColor == nil ? @"" : [taskColor stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
					
					if (taskQuery == nil) {
						taskQuery = [NSString stringWithFormat:
									 @"INSERT INTO %@ (project_id, task_id, task_order, task_name, task_color, task_duration) SELECT \"%@\", \"%@\", %d, \"%@\", \"%@\", %d",
									 TableName_Tasks, projectId, taskId, taskOrder, taskName, taskColor, taskDuration];
					} else {
						taskQuery = [taskQuery stringByAppendingFormat:@" UNION SELECT \"%@\", \"%@\", %d, \"%@\", \"%@\", %d",
									 projectId, taskId, taskOrder, taskName, taskColor, taskDuration];
					}
				}
			}
			
			NSMutableArray* milestones = [project getMilestones];
			if (milestones != nil && [milestones count] > 0) {
				for (int milestoneIndex = 0; milestoneIndex < [milestones count]; milestoneIndex ++) {
					Milestone* milestone = (Milestone*)[milestones objectAtIndex:milestoneIndex];
					if (milestone == nil)
						continue;
					
					NSString* milestoneName = [milestone getMilestoneName];
					int milestoneNumber = [milestone getMilestoneNumber];
					
					milestoneName = milestoneName == nil ? @"" : [milestoneName stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
					
					if (milestoneQuery == nil) {
						milestoneQuery = [NSString stringWithFormat:@"INSERT INTO %@ (project_id, name, number) SELECT \"%@\", \"%@\", %d",
										  TableName_Milestones, projectId, milestoneName, milestoneNumber];
					} else {
						milestoneQuery = [milestoneQuery stringByAppendingFormat:@" UNION SELECT \"%@\", \"%@\", %d", projectId, milestoneName, milestoneNumber];
					}
				}
			}
		}
		
		if (projectQuery != nil && [projectQuery length] > 0) {
			if (sqlite3_exec(m_Database, [projectQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				NSLog(@"%s : %@\n", errorMsg, projectQuery);
				retValue = NO;
			} else {
				if (taskQuery != nil && [taskQuery length] > 0) {
					if (sqlite3_exec(m_Database, [taskQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
						NSLog(@"%s : %@\n", errorMsg, taskQuery);
						retValue = NO;
					}
				}
				
				if (milestoneQuery != nil && [milestoneQuery length] > 0) {
					if (sqlite3_exec(m_Database, [milestoneQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
						NSLog(@"%s : %@\n", errorMsg, milestoneQuery);
						retValue = NO;
					}
				}
			}
		}
	}
	sqlite3_close(m_Database);
	
	return retValue;
}


- (void)saveProject:(Project*)project {
	
	if (project == nil)
		return;
	
	NSString* db_path = [DOCS_FOLDER stringByAppendingPathComponent:DB_NAME];
	
	if (sqlite3_open([db_path UTF8String], &m_Database) != SQLITE_OK) {
		sqlite3_close(m_Database);
	} else {
		char* errorMsg;
		
		NSString* taskQuery = nil;
		NSString* milestoneQuery = nil;
		
		NSString* projectId = [project getProjectID];
		projectId = projectId == nil ? @"" : [projectId stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
		
		
		NSMutableArray* tasks = [project getTasks];
		if (tasks != nil && [tasks count] > 0) {
			for (int taskIndex = 0; taskIndex < [tasks count]; taskIndex ++) {
				Task* task = (Task*)[tasks objectAtIndex:taskIndex];
				if (task == nil)
					continue;
				
				NSString* taskId = [task getTaskID];
				int taskOrder = [task getTaskOrder];
				NSString* taskName = [task getTaskName];
				NSString* taskColor = [task getTaskColor];
				int taskDuration = [task getTaskDuration];
				
				taskId = taskId == nil ? @"" : [taskId stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
				taskName = taskName == nil ? @"" : [taskName stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
				taskColor = taskColor == nil ? @"" : [taskColor stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
				
				if (taskQuery == nil) {
					taskQuery = [NSString stringWithFormat:
								 @"INSERT INTO %@ (project_id, task_id, task_order, task_name, task_color, task_duration) SELECT \"%@\", \"%@\", %d, \"%@\", \"%@\", %d",
								 TableName_Tasks, projectId, taskId, taskOrder, taskName, taskColor, taskDuration];
				} else {
					taskQuery = [taskQuery stringByAppendingFormat:@" UNION SELECT \"%@\", \"%@\", %d, \"%@\", \"%@\", %d",
								 projectId, taskId, taskOrder, taskName, taskColor, taskDuration];
				}
			}
		}
		
		NSMutableArray* milestones = [project getMilestones];
		if (milestones != nil && [milestones count] > 0) {
			for (int milestoneIndex = 0; milestoneIndex < [milestones count]; milestoneIndex ++) {
				Milestone* milestone = (Milestone*)[milestones objectAtIndex:milestoneIndex];
				if (milestone == nil)
					continue;
				
				NSString* milestoneName = [milestone getMilestoneName];
				int milestoneNumber = [milestone getMilestoneNumber];
				
				milestoneName = milestoneName == nil ? @"" : [milestoneName stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
				
				if (milestoneQuery == nil) {
					milestoneQuery = [NSString stringWithFormat:@"INSERT INTO %@ (project_id, name, number) SELECT \"%@\", \"%@\", %d",
									  TableName_Milestones, projectId, milestoneName, milestoneNumber];
				} else {
					milestoneQuery = [milestoneQuery stringByAppendingFormat:@" UNION SELECT \"%@\", \"%@\", %d", projectId, milestoneName, milestoneNumber];
				}
			}
		}
		
		NSString* deleteQuery = [NSString stringWithFormat:@"DELETE FROM tasks WHERE project_id=\"%@\"; DELETE FROM milestones WHERE project_id=\"%@\"", projectId, projectId];
		if (deleteQuery != nil && [deleteQuery length] > 0) {
			if (sqlite3_exec(m_Database, [deleteQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
				NSLog(@"%s : %@\n", errorMsg, deleteQuery);
			} else {
				if (taskQuery != nil && [taskQuery length] > 0) {
					if (sqlite3_exec(m_Database, [taskQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
						NSLog(@"%s : %@\n", errorMsg, taskQuery);
					}
				}
				
				if (milestoneQuery != nil && [milestoneQuery length] > 0) {
					if (sqlite3_exec(m_Database, [milestoneQuery UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
						NSLog(@"%s : %@\n", errorMsg, milestoneQuery);
					}
				}
			}
		}
	}
	sqlite3_close(m_Database);
}


@end
