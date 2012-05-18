//
//  DataParser.m
//  Project40
//
//  Created by John Stack on 7/12/11.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import "DataParser.h"
#import "Project40AppDelegate.h"
#import "Project.h"


@implementation DataParser

@synthesize m_Projects;

- (id)init {
	self = [super init];
	if (self) {
		m_SQLManager = [[SQLManager alloc] init];
	}
	return self;
}

- (void)dealloc {
	[m_SQLManager release];
	[self.m_Projects release];
	[super dealloc];
}

- (SQLManager*)getSQLManager {
	return m_SQLManager;
}

- (NSMutableArray*)getProjects {
	return self.m_Projects;
}


- (void)parseProjects {
	
	NSString* xmlFilePath = [[NSBundle mainBundle] pathForResource:@"Project" ofType:@"xml"];
	NSData* xmlData = [NSData dataWithContentsOfFile:xmlFilePath];
	NSString* strXmlData = [[[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding] autorelease];
	
	if (strXmlData != nil) {
		strXmlData = [strXmlData stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	}
	
	NSError* error = nil;
	DDXMLElement* element = nil;
	
	if (strXmlData != nil && [strXmlData isKindOfClass:[NSString class]]) {
		element = [[DDXMLElement alloc] initWithXMLString:strXmlData error:&error];
		if (error) {
			[Project40AppDelegate showErrorAlert:[error localizedDescription] delegate:self tag:-1];
			return;
		}
		
		NSArray* projectNodeList = [element nodesForXPath:@"item" error:&error];
		
		if (projectNodeList != nil) {
			for (DDXMLNode* projectNode in projectNodeList) {
				NSString* projectID = (NSString*)[(DDXMLNode*)[[projectNode nodesForXPath:@"ProjectID" error:&error] objectAtIndex:0] stringValue];
				NSString* projectName = (NSString*)[(DDXMLNode*)[[projectNode nodesForXPath:@"ProjectName" error:&error] objectAtIndex:0] stringValue];
				NSString* projectDesc = (NSString*)[(DDXMLNode*)[[projectNode nodesForXPath:@"ProjectDesc" error:&error] objectAtIndex:0] stringValue];
				
				if (projectID == nil || [projectID length] < 1)
					continue;
				
				Project* project = [[Project alloc] initWithProjectID:projectID name:projectName desc:projectDesc];
				
				NSArray* tasksNodeList = [projectNode nodesForXPath:@"Tasks" error:&error];
				if (tasksNodeList != nil) {
					DDXMLNode* tasksNode = (DDXMLNode*)[tasksNodeList objectAtIndex:0];
					if (tasksNode != nil) {
						NSArray* taskNodeList = [tasksNode nodesForXPath:@"Task" error:&error];
						if (taskNodeList != nil) {
							NSMutableArray* taskList = [NSMutableArray arrayWithCapacity:0];
							for (DDXMLNode* taskNode in taskNodeList) {
								NSString* taskID = (NSString*)[(DDXMLNode*)[[taskNode nodesForXPath:@"TaskID" error:&error] objectAtIndex:0] stringValue];
								NSString* strTaskOrder = (NSString*)[(DDXMLNode*)[[taskNode nodesForXPath:@"TaskOrder" error:&error] objectAtIndex:0] stringValue];
								NSString* taskName = (NSString*)[(DDXMLNode*)[[taskNode nodesForXPath:@"TaskName" error:&error] objectAtIndex:0] stringValue];
								NSString* taskColor = (NSString*)[(DDXMLNode*)[[taskNode nodesForXPath:@"TaskColor" error:&error] objectAtIndex:0] stringValue];
								NSString* strTaskDuration = (NSString*)[(DDXMLNode*)[[taskNode nodesForXPath:@"TaskDuration" error:&error] objectAtIndex:0] stringValue];
								
								NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
								NSNumber* taskOrderNumber = [numberFormatter numberFromString:strTaskOrder];
								NSNumber* taskDurationNumber = [numberFormatter numberFromString:strTaskDuration];
								
								if (taskID == nil || [taskID length] < 1)
									continue;
								
								Task* task = [[Task alloc] initWithProjectID:projectID
																	  taskID:taskID
																	   order:[taskOrderNumber intValue]
																		name:taskName
																	   color:taskColor
																	duration:[taskDurationNumber intValue]];
								[taskList addObject:task];
								[task release];
							}
							[project setTasks:taskList];
						}
					}
				}
				
				NSArray* milestonesNodeList = [projectNode nodesForXPath:@"Milestones" error:&error];
				if (milestonesNodeList != nil) {
					DDXMLNode* milestonesNode = (DDXMLNode*)[milestonesNodeList objectAtIndex:0];
					if (milestonesNode != nil) {
						NSArray* milestoneNodeList = [milestonesNode nodesForXPath:@"Milestone" error:&error];
						if (milestoneNodeList != nil) {
							NSMutableArray* milestoneList = [NSMutableArray arrayWithCapacity:0];
							for (DDXMLNode* milestoneNode in milestoneNodeList) {
								
								NSString* milestoneName = (NSString*)[(DDXMLNode*)[[milestoneNode nodesForXPath:@"MilestoneName" error:&error] objectAtIndex:0] stringValue];
								NSString* strMilestoneNumber = (NSString*)[(DDXMLNode*)[[milestoneNode nodesForXPath:@"MilestoneNumber" error:&error] objectAtIndex:0] stringValue];
								
								NSNumberFormatter* numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
								NSNumber* milestoneNumber = [numberFormatter numberFromString:strMilestoneNumber];
								
								if (milestoneName == nil || [milestoneName length] < 1)
									continue;
								
								Milestone* milestone = [[Milestone alloc] initWithProjectID:projectID milestoneName:milestoneName number:[milestoneNumber intValue]];
								[milestoneList addObject:milestone];
								[milestone release];
							}
							[project setMilestones:milestoneList];
						}
					}
				}
				
				[self.m_Projects addObject:project];
				[project release];
			}
		}
	}
}

- (void)loadProjects {
	
	if (self.m_Projects != nil)
		[self.m_Projects removeAllObjects];
	if (self.m_Projects == nil)
		self.m_Projects = [NSMutableArray arrayWithCapacity:0];
	
	if (![m_SQLManager checkProjectsDB]) {
		[m_SQLManager createProjectsDB];
		
		[self parseProjects];
		[m_SQLManager saveProjects:self.m_Projects];
	}
	
	self.m_Projects = [m_SQLManager readProjectsFromDB];
}


@end
