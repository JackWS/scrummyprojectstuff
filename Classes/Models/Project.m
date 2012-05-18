//
//  Project.m
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 7/12/11.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import "Project.h"


@implementation Task

@synthesize m_ProjectID, m_TaskID, m_TaskOrder, m_TaskName, m_TaskColor, m_TaskDuration;

- (id)init {
	self = [super init];
	if (self) {
		self.m_ProjectID = nil;
		self.m_TaskID = nil;
		self.m_TaskOrder = -1;
		self.m_TaskName = nil;
		self.m_TaskColor = nil;
		self.m_TaskDuration = -1;
	}
	return self;
}

- (id)initWithProjectID:(NSString*)projectID taskID:(NSString*)taskID order:(int)taskOrder name:(NSString*)taskName color:(NSString*)taskColor duration:(int)taskDuration {
	
	self = [self init];
	if (self) {
		self.m_ProjectID = projectID;
		self.m_TaskID = taskID;
		self.m_TaskOrder = taskOrder;
		self.m_TaskName = taskName;
		self.m_TaskColor = taskColor;
		self.m_TaskDuration = taskDuration;
	}
	return self;
}

- (void)dealloc {
	[self.m_ProjectID release];
	[self.m_TaskID release];
	[self.m_TaskName release];
	[self.m_TaskColor release];
	[super dealloc];
}

- (NSString*)getProjectID {
	return self.m_ProjectID;
}

- (NSString*)getTaskID {
	return self.m_TaskID;
}

- (int)getTaskOrder {
	return self.m_TaskOrder;
}

- (NSString*)getTaskName {
	return self.m_TaskName;
}

- (NSString*)getTaskColor {
	return self.m_TaskColor;
}

- (int)getTaskDuration {
	return self.m_TaskDuration;
}

- (void)updateTaskWith:(NSString*)prjId order:(int)taskOrder {
	self.m_ProjectID = prjId;
	self.m_TaskOrder = taskOrder;
}


@end


@implementation Milestone

@synthesize m_ProjectID, m_MilestoneName, m_MilestoneNumber;

- (id)init {
	self = [super init];
	if (self) {
		self.m_ProjectID = nil;
		self.m_MilestoneName = nil;
		self.m_MilestoneNumber = -1;
	}
	return self;
}

- (id)initWithProjectID:(NSString*)projectId milestoneName:(NSString*)milestoneName number:(int)milestoneNumber {
	
	self = [self init];
	if (self) {
		self.m_ProjectID = projectId;
		self.m_MilestoneName = milestoneName;
		self.m_MilestoneNumber = milestoneNumber;
	}
	return self;
}

- (void)dealloc {
	[self.m_ProjectID release];
	[self.m_MilestoneName release];
	[super dealloc];
}

- (NSString*)getProjectID {
	return self.m_ProjectID;
}

- (NSString*)getMilestoneName {
	return self.m_MilestoneName;
}

- (int)getMilestoneNumber {
	return self.m_MilestoneNumber;
}

- (void)updateMilestoneWith:(NSString*)prjId number:(int)milestoneNumber {
	self.m_ProjectID = prjId;
	self.m_MilestoneNumber = milestoneNumber;
}


@end


@implementation Project

@synthesize m_ProjectID, m_ProjectName, m_ProjectDesc;
@synthesize m_Tasks, m_Milestones;


- (id)init {
	self = [super init];
	if (self) {
		self.m_ProjectID = nil;
		self.m_ProjectName = nil;
		self.m_ProjectDesc = nil;
		self.m_Tasks = nil;
		self.m_Milestones = nil;
	}
	return self;
}

- (id)initWithProjectID:(NSString*)projectID name:(NSString*)projectName desc:(NSString*)projectDesc {
	
	self = [self init];
	if (self) {
		self.m_ProjectID = projectID;
		self.m_ProjectName = projectName;
		self.m_ProjectDesc = projectDesc;
	}
	return self;
}

- (void)dealloc {
	[self.m_ProjectID release];
	[self.m_ProjectName release];
	[self.m_ProjectDesc release];
	[self.m_Tasks release];
	[self.m_Milestones release];
	[super dealloc];
}

- (NSString*)getProjectID {
	return self.m_ProjectID;
}

- (NSString*)getProjectName {
	return self.m_ProjectName;
}

- (NSString*)getProjectDesc {
	return self.m_ProjectDesc;
}

- (NSMutableArray*)getTasks {
	return self.m_Tasks;
}

- (void)setTasks:(NSMutableArray*)taskList {
	self.m_Tasks = taskList;
}

- (NSMutableArray*)getMilestones {
	return self.m_Milestones;
}

- (void)setMilestones:(NSMutableArray*)milestoneList {
	self.m_Milestones = milestoneList;
}

- (void)updateTaskWith:(Task*)task taskOrder:(int)taskOrder milestoneNumber:(int)milestoneNumber isAdd:(BOOL)add {
	
	if (task == nil)
		return;
	
	if (self.m_Tasks == nil)
		self.m_Tasks = [[NSMutableArray alloc] initWithCapacity:0];
	
	if (add) {
		for (Task* aTask in self.m_Tasks) {
			int aTaskOrder = [aTask getTaskOrder];
			if (aTaskOrder >= taskOrder)
				aTask.m_TaskOrder ++;
		}
		for (Milestone* aMilestone in self.m_Milestones) {
			int aMilestoneNumber = [aMilestone getMilestoneNumber];
			if (aMilestoneNumber >= milestoneNumber)
				aMilestone.m_MilestoneNumber ++;
		}
		[task updateTaskWith:self.m_ProjectID order:taskOrder];
		if ([self.m_Tasks count] < 1)
			[self.m_Tasks addObject:task];
		else
			[self.m_Tasks insertObject:task atIndex:(taskOrder - 1)];
		
	} else {
		[self.m_Tasks removeObject:task];
		for (Task* aTask in self.m_Tasks) {
			int aTaskOrder = [aTask getTaskOrder];
			if (aTaskOrder < taskOrder)
				continue;
			
			aTask.m_TaskOrder --;
		}
		for (Milestone* aMilestone in self.m_Milestones) {
			int aMilestoneNumber = [aMilestone getMilestoneNumber];
			if (aMilestoneNumber < taskOrder)
				continue;
			
			aMilestone.m_MilestoneNumber --;
		}
	}
}

- (void)updateMilestoneWith:(Milestone*)milestone milestoneNumber:(int)milestoneNumber isAdd:(BOOL)add {
	
	if (milestone == nil)
		return;
	
	if (self.m_Milestones == nil)
		self.m_Milestones = [[NSMutableArray alloc] initWithCapacity:0];
	
	if (add) {
		//int milestoneNumber = index + 1;
		BOOL added = NO;
		int addIndex = -1;
		
		[milestone updateMilestoneWith:self.m_ProjectID number:milestoneNumber];
		for (Milestone* aMilestone in self.m_Milestones) {
			addIndex ++;
			int aMilestoneNumber = [aMilestone getMilestoneNumber];
			if (aMilestoneNumber < milestoneNumber)
				continue;
			
			if ([self.m_Milestones count] < 1) {
				[self.m_Milestones addObject:milestone];
			} else {
				[self.m_Milestones insertObject:milestone atIndex:addIndex];
			}
			added = YES;
			break;
		}
		
		if (!added)
			[self.m_Milestones addObject:milestone];
	} else {
		
		for (int delIndex = [self.m_Milestones count] - 1; delIndex >= 0; delIndex --) {
			Milestone* aMilestone = [self.m_Milestones objectAtIndex:delIndex];
			int aMilestoneNumber = [aMilestone getMilestoneNumber];
			if (aMilestoneNumber != milestoneNumber)
				continue;
			
			if (aMilestoneNumber == milestoneNumber)
				[self.m_Milestones removeObject:aMilestone];
		} 
	}
}


@end
