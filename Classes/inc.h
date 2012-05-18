/*
 *  inc.h
 *  Project40
 *
 *  Created by John Stack on 6/15/11.
 *  Copyright 2012 Cexi Me LLC. All rights reserved.
 *
 */

#ifndef _Project40_INC
#define _Project40_INC

#define TMP_FOLDER						[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define DOCS_FOLDER						[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define GROW_ANIMATION_DURATION_SECONDS		0.15    // Determines how fast a piece size grows when it is moved.
#define SHRINK_ANIMATION_DURATION_SECONDS	0.15  // Determines how fast a piece size shrinks when a piece stops moving.

#define AddTask							0
#define DeleteTask						1

#define WrapperView_Margin				30.0
#define TaskButton_Width				150.0
#define TaskButton_Height				70.0
#define TaskButton_MarginTop			5.0
#define TaskButton_MarginBottom			30.0
#define TaskButton_MarginLeft			10.0
#define MilestoneButton_Width			10.0
#define MilestoneButton_Height			98.0
#define MilestoneButton_MarginTop		1.0
#define MilestoneButton_MarginLeft		5.0
#define MilestoneButton_VerticalWidth			150.0
#define MilestoneButton_VerticalHeight			15.0
#define MilestoneButton_VerticalMarginTop		10.0

#define ProjectView_VerticalWidth		TaskButton_Width + 2 * TaskButton_MarginLeft
#define ProjectView_HorizontalHieght	120.0

// DB macros
#define DB_NAME							@"Project40.db"
#define TableName_Projects				@"projects"
#define TableName_Tasks					@"tasks"
#define TableName_Milestones			@"milestones"


#define SQL_SelectAll					@"SELECT * FROM %@;"
#define SQL_SelectAllWithProjectID		@"SELECT * FROM %@ WHERE project_id='%@' ORDER BY %@;"
#define SQL_DeleteTable					@"DELETE FROM %@;"

// Projects strings macros
#define SQL_Create_Projects				[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
																		project_id CHAR(64) NOT NULL PRIMARY KEY,\
																		project_name TEXT,\
																		project_desc TEXT);", TableName_Projects]

#define SQL_Insert_Projects				@"INSERT INTO %@ (project_id, project_name, project_desc) VALUES ('%@', '%@', '%@');"

// Tasks strings macros
#define SQL_Create_Tasks				[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
																		project_id CHAR(64), \
																		task_id CHAR(64), \
																		task_order INTEGER, \
																		task_name TEXT, \
																		task_color CHAR(32), \
																		task_duration INTEGER);", TableName_Tasks]

#define SQL_Insert_Tasks				@"INSERT INTO %@ (\
											project_id, task_id, task_order, task_name, task_color, task_duration) \
										VALUES ('%@', '%@', %d, '%@', '%@', %d);"

// Milestones strings macros
#define SQL_Create_Milestones			[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (\
											project_id CHAR(64), name TEXT, number INTEGER);", TableName_Milestones]

#define SQL_Insert_Milestones			@"INSERT INTO %@ (project_id, name, number) VALUES ('%@', '%@', %d);"


#endif
