//
//  Project.h
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 7/12/11.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
<item>
	<ProjectID></ProjectID>
	<ProjectName></ProjectName>
	<ProjectDesc></ProjectDesc>
	<Tasks>
		<Task>
			<TaskID></TaskID>
			<TaskOrder></TaskOrder>
			<TaskName></TaskName>
			<TaskColor></TaskColor>
			<TaskDuration></TaskDuration>
		</Task>
	</Tasks>
	<Milestones>
		<Milestone>
			<MilestoneName></MilestoneName>
			<MilestoneNumber></MilestoneNumber>
		</Milestone>
	</Milestones>
</item>
*/

@interface Task : NSObject {
	
	NSString*			m_ProjectID;
	NSString*			m_TaskID;
	int					m_TaskOrder;
	NSString*			m_TaskName;
	NSString*			m_TaskColor;
	int					m_TaskDuration;
}

@property (nonatomic, retain) NSString* m_ProjectID;
@property (nonatomic, retain) NSString* m_TaskID;
@property (nonatomic, assign) int m_TaskOrder;
@property (nonatomic, retain) NSString* m_TaskName;
@property (nonatomic, retain) NSString* m_TaskColor;
@property (nonatomic, assign) int m_TaskDuration;

- (id)init;
- (id)initWithProjectID:(NSString*)projectID taskID:(NSString*)taskID order:(int)taskOrder name:(NSString*)taskName color:(NSString*)taskColor duration:(int)taskDuration;

- (NSString*)getProjectID;
- (NSString*)getTaskID;
- (int)getTaskOrder;
- (NSString*)getTaskName;
- (NSString*)getTaskColor;
- (int)getTaskDuration;

- (void)updateTaskWith:(NSString*)prjId order:(int)taskOrder;


@end


@interface Milestone : NSObject {
	
	NSString*			m_ProjectID;
	NSString*			m_MilestoneName;
	int					m_MilestoneNumber;
}

@property (nonatomic, retain) NSString* m_ProjectID;
@property (nonatomic, retain) NSString* m_MilestoneName;
@property (nonatomic, assign) int m_MilestoneNumber;

- (id)init;
- (id)initWithProjectID:(NSString*)projectId milestoneName:(NSString*)milestoneName number:(int)milestoneNumber;

- (NSString*)getProjectID;
- (NSString*)getMilestoneName;
- (int)getMilestoneNumber;

- (void)updateMilestoneWith:(NSString*)prjId number:(int)milestoneNumber;


@end


@interface Project : NSObject {

	NSString*			m_ProjectID;
	NSString*			m_ProjectName;
	NSString*			m_ProjectDesc;
	
	NSMutableArray*		m_Tasks;
	NSMutableArray*		m_Milestones;
}

@property (nonatomic, retain) NSString* m_ProjectID;
@property (nonatomic, retain) NSString* m_ProjectName;
@property (nonatomic, retain) NSString* m_ProjectDesc;
@property (nonatomic, retain) NSMutableArray* m_Tasks;
@property (nonatomic, retain) NSMutableArray* m_Milestones;

- (id)init;
- (id)initWithProjectID:(NSString*)projectID name:(NSString*)projectName desc:(NSString*)projectDesc;

- (NSString*)getProjectID;
- (NSString*)getProjectName;
- (NSString*)getProjectDesc;

- (NSMutableArray*)getTasks;
- (void)setTasks:(NSMutableArray*)taskList;
- (NSMutableArray*)getMilestones;
- (void)setMilestones:(NSMutableArray*)milestoneList;

- (void)updateTaskWith:(Task*)task taskOrder:(int)taskOrder milestoneNumber:(int)milestoneNumber isAdd:(BOOL)add;
- (void)updateMilestoneWith:(Milestone*)milestone milestoneNumber:(int)milestoneNumber isAdd:(BOOL)add;


@end
