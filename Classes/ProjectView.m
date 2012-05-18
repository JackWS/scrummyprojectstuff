//
//  ProjectView.m
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on December 15, 2011.
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import "ProjectView.h"
#import "TaskView.h"


@implementation ProjectView

@synthesize m_TitleButton, m_WrapperView;
@synthesize m_TaskViewList, m_MilestoneViewList;

- (id)initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code.
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[self.m_TitleButton release];
	[self.m_WrapperView release];
	[self.m_TaskViewList release];
	[self.m_MilestoneViewList release];
	
	[super dealloc];
}


- (UIColor*)getButtonColor:(NSString*)strColor {
	UIColor* color = [UIColor clearColor];
	if (strColor == nil && [strColor length] < 1)
		return color;
	
	if ([strColor isEqualToString:@"Red"]) {
		color = [UIColor redColor];
	} else if ([strColor isEqualToString:@"Grey"]) {
		color = [UIColor grayColor];
	} else if ([strColor isEqualToString:@"Blue"]) {
		color = [UIColor blueColor];
	} else if ([strColor isEqualToString:@"Green"]) {
		color = [UIColor greenColor];
	} else if ([strColor isEqualToString:@"Yellow"]) {
		color = [UIColor yellowColor];
	} else if ([strColor isEqualToString:@"Magenta"]) {
		color = [UIColor magentaColor];
	} else if ([strColor isEqualToString:@"White"]) {
		color = [UIColor whiteColor];
	}
	return color;
}

- (IBAction)tapProject {
	[m_Parent setCellBackground:m_ProjectIndex];
}

- (void)setParent:(MainViewController*)parent {
	m_Parent = parent;
}

- (CGRect)getTaskRect:(int)taskIndex isVertical:(BOOL)vertical {
	
	CGRect frame = CGRectZero;
	if (vertical) {
		CGFloat height = TaskButton_Height + TaskButton_MarginTop + TaskButton_MarginBottom;
		frame = CGRectMake(TaskButton_MarginLeft, TaskButton_MarginTop + taskIndex * height, TaskButton_Width, TaskButton_Height);
	} else {
		CGFloat width = TaskButton_Width + 2 * TaskButton_MarginLeft;
		frame = CGRectMake(WrapperView_Margin + taskIndex * width, TaskButton_MarginTop, TaskButton_Width, TaskButton_Height);
	}
	
	return frame;
}

- (CGRect)getMilestoneRect:(int)milestoneNumber isVertical:(BOOL)vertical {
	
	CGRect frame = CGRectZero;
	if (vertical) {
		CGFloat height = TaskButton_Height + TaskButton_MarginTop + TaskButton_MarginBottom;
		frame = CGRectMake(TaskButton_MarginLeft,
						   milestoneNumber * height - TaskButton_MarginBottom + MilestoneButton_VerticalMarginTop,
						   MilestoneButton_VerticalWidth,
						   MilestoneButton_VerticalHeight);
	} else {
		CGFloat width = TaskButton_Width + 2 * TaskButton_MarginLeft;
		frame = CGRectMake(WrapperView_Margin + milestoneNumber * width - 2 * TaskButton_MarginLeft + MilestoneButton_MarginLeft,
						   MilestoneButton_MarginTop,
						   MilestoneButton_Width,
						   MilestoneButton_Height);
	}
	
	return frame;
}


- (void)reloadProjectView:(Project*)project prjIndex:(int)projectIndex vertical:(BOOL)vertical {
	
	self.m_WrapperView.showsHorizontalScrollIndicator = NO;
	self.m_WrapperView.showsVerticalScrollIndicator = NO;
	if (project == nil)
		return;
	
	m_ProjectIndex = projectIndex;
	[m_TitleButton setTitle:[project getProjectName] forState:UIControlStateNormal];
    //jws changed color    
    [m_TitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

	NSMutableArray* tasks = [project getTasks];
	int taskCount = [tasks count];
	
	/*
	NSArray* subViews = [self.m_WrapperView subviews];
	if (subViews != nil) {
		for (UIView* subView in subViews) {
			if (subView != nil && [(TaskView*)subView isKindOfClass:[TaskView class]]) {
				[subView removeFromSuperview];
			}
		}
	}
	*/
	
	if (self.m_TaskViewList == nil) {
		self.m_TaskViewList = [[NSMutableArray alloc] initWithCapacity:taskCount];
		for (int i = 0; i < taskCount; i ++)
			[self.m_TaskViewList addObject:[NSNull null]];
	}
	
	if (tasks != nil) {
		for (int taskIndex = 0; taskIndex < taskCount; taskIndex ++) {
			Task* task = (Task*)[tasks objectAtIndex:taskIndex];
			if (task == nil)
				continue;
			
			if (taskIndex >= [self.m_TaskViewList count])
				continue;
			
			TaskView* taskView = (TaskView*)[self.m_TaskViewList objectAtIndex:taskIndex];
			if (taskView == nil || (NSNull*)taskView == [NSNull null]) {
				taskView = [[TaskView alloc] initWithType:YES];
				[taskView setParent:m_Parent prjView:self];
				[taskView setTask:task];
				taskView.tag = m_ProjectIndex;
				
				[taskView setTaskViewFrame:[self getTaskRect:taskIndex isVertical:vertical]];
				taskView.backgroundColor = [self getButtonColor:[task getTaskColor]];
				//taskView.backgroundColor = [UIColor whiteColor];
				
				[self.m_WrapperView addSubview:taskView];
				[self.m_TaskViewList replaceObjectAtIndex:taskIndex withObject:taskView];
				[taskView release];
				
			} else {
				[taskView setTaskViewFrame:[self getTaskRect:taskIndex isVertical:vertical]];
				taskView.backgroundColor = [self getButtonColor:[task getTaskColor]];
			}
		}
		
		CGSize contentSize = CGSizeZero;
		if (vertical) {
			CGFloat height = TaskButton_Height + TaskButton_MarginTop + TaskButton_MarginBottom;
			contentSize = CGSizeMake(ProjectView_VerticalWidth, taskCount * height);
		} else {
			CGFloat width = TaskButton_Width + 2 * TaskButton_MarginLeft;
			contentSize = CGSizeMake(taskCount * width + 2 * WrapperView_Margin, TaskButton_Height);
		}
		self.m_WrapperView.contentSize = contentSize;
	}
	
	NSMutableArray* milestones = [project getMilestones];
	int milestoneCount = [milestones count];
	
	if (self.m_MilestoneViewList == nil) {
		self.m_MilestoneViewList = [[NSMutableArray alloc] initWithCapacity:milestoneCount];
		for (int i = 0; i < milestoneCount; i ++)
			[self.m_MilestoneViewList addObject:[NSNull null]];
	}
	
	if (milestones != nil) {
		for (int milestoneIndex = 0; milestoneIndex < milestoneCount; milestoneIndex ++) {
			Milestone* milestone = (Milestone*)[milestones objectAtIndex:milestoneIndex];
			if (milestone == nil)
				continue;
			
			if (milestoneIndex >= [self.m_MilestoneViewList count])
				continue;
			
			int milestoneNumber = [milestone getMilestoneNumber];
			TaskView* milestoneView = (TaskView*)[self.m_MilestoneViewList objectAtIndex:milestoneIndex];
			if (milestoneView == nil || (NSNull*)milestoneView == [NSNull null]) {
				milestoneView = [[TaskView alloc] initWithType:NO];
				[milestoneView setParent:m_Parent prjView:self];
				[milestoneView setMilestone:milestone];
				milestoneView.tag = m_ProjectIndex;
				
				[milestoneView setTaskViewFrame:[self getMilestoneRect:milestoneNumber isVertical:vertical]];
				milestoneView.backgroundColor = [UIColor yellowColor];
				
				[self.m_WrapperView addSubview:milestoneView];
				[self.m_MilestoneViewList replaceObjectAtIndex:milestoneIndex withObject:milestoneView];
				[milestoneView release];
			} else {
				[milestoneView setTaskViewFrame:[self getMilestoneRect:milestoneNumber isVertical:vertical]];
				milestoneView.backgroundColor = [UIColor yellowColor];
			}
		}
	}
}

- (void)addTaskWith:(TaskView*)taskView addTaskOrder:(int)taskOrder {
	
	BOOL isTaskView = [taskView isTaskViewType];
	Task* task = nil;
	Milestone* milestone = nil;
	if (isTaskView) {
		task = [[taskView getTask] retain];
		if (task == nil)
			return;
	} else {
		milestone = [[taskView getMilestone] retain];
		if (milestone == nil)
			return;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	
	int tOrder = 0;
	int tIndex = -1;
	CGFloat height = TaskButton_Height + TaskButton_MarginTop + TaskButton_MarginBottom;
	CGFloat width = TaskButton_Width + 2 * TaskButton_MarginLeft;
	
	for (TaskView* tView in self.m_WrapperView.subviews) {
		if (tView == nil || ![tView isKindOfClass:[TaskView class]])
			continue;
		
		if ([tView isTaskViewType])
			tOrder = [[tView getTask] getTaskOrder];
		else {
			tOrder = [[tView getMilestone] getMilestoneNumber];
			tIndex ++;
		}
			
		if (tOrder < taskOrder)
			continue;
		
		if (isTaskView) {
			CGRect frame = tView.frame;
			if ([m_Parent isVertical])
				frame.origin.y += height;
			else
				frame.origin.x += width;
			tView.frame = frame;
		}
	}
	
	if (isTaskView) {
		CGSize contentSize =  self.m_WrapperView.contentSize;
		if ([m_Parent isVertical])
			contentSize.height += height;
		else
			contentSize.width += width;
		self.m_WrapperView.contentSize = contentSize;
	}
	
	[UIView commitAnimations];
	
	if (isTaskView) {
		TaskView* newTaskView = [[TaskView alloc] initWithType:isTaskView];
		[newTaskView setParent:m_Parent prjView:self];
		[newTaskView setTask:task];
		[newTaskView setMilestone:milestone];
		newTaskView.tag = m_ProjectIndex;
		
		[newTaskView setTaskViewFrame:[self getTaskRect:(taskOrder - 1) isVertical:[m_Parent isVertical]]];
		newTaskView.backgroundColor = [self getButtonColor:[task getTaskColor]];
		
		[self.m_WrapperView addSubview:newTaskView];
		if (self.m_TaskViewList == nil || [self.m_TaskViewList count] < 0)
			[self.m_TaskViewList addObject:newTaskView];
		else {
			[self.m_TaskViewList insertObject:newTaskView atIndex:(taskOrder - 1)];
		}
		[newTaskView release];
	} else {
		
		TaskView* newMilestoneView = [[TaskView alloc] initWithType:isTaskView];
		[newMilestoneView setParent:m_Parent prjView:self];
		[newMilestoneView setTask:task];
		[newMilestoneView setMilestone:milestone];
		newMilestoneView.tag = m_ProjectIndex;
		
		[newMilestoneView setTaskViewFrame:[self getMilestoneRect:taskOrder isVertical:[m_Parent isVertical]]];
		newMilestoneView.backgroundColor = [UIColor yellowColor];
		
		[self.m_WrapperView addSubview:newMilestoneView];
		if (self.m_MilestoneViewList == nil || [self.m_MilestoneViewList count] < 0 || tIndex < 0 || tIndex >= [self.m_MilestoneViewList count])
			[self.m_MilestoneViewList addObject:newMilestoneView];
		else {
			[self.m_MilestoneViewList insertObject:newMilestoneView atIndex:tIndex];
		}
		[newMilestoneView release];
	}
	
	/*
	TaskView* taskView = [[TaskView alloc] initWithType:YES];
	[taskView setParent:m_Parent prjView:self];
	[taskView setTask:task];
	taskView.tag = m_ProjectIndex;
	
	[taskView setTaskViewFrame:[self getTaskRect:(taskOrder - 1) isVertical:[m_Parent isVertical]]];
	taskView.backgroundColor = [self getButtonColor:[task getTaskColor]];
	//taskView.backgroundColor = [UIColor whiteColor];
	
	[self.m_WrapperView addSubview:taskView];
	if (self.m_TaskViewList == nil || [self.m_TaskViewList count] < 0)
		[self.m_TaskViewList addObject:taskView];
	else {
		[self.m_TaskViewList insertObject:taskView atIndex:(taskOrder - 1)];
	}
	[taskView release];
	*/
}

- (TaskView*)deleteTaskWith:(TaskView*)taskView addTaskOrder:(int)taskOrder {
	
	TaskView* delMilestoneView = nil;
	
	BOOL isTaskView = [taskView isTaskViewType];
	if (isTaskView) {
		Task* task = [[taskView getTask] retain];
		if (task == nil)
			return nil;
	} else {
		Milestone* milestone = [[taskView getMilestone] retain];
		if (milestone == nil)
			return nil;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	
	int tOrder = 0;
	CGFloat height = TaskButton_Height + TaskButton_MarginTop + TaskButton_MarginBottom;
	CGFloat width = TaskButton_Width + 2 * TaskButton_MarginLeft;
	
	for (TaskView* tView in self.m_WrapperView.subviews) {
		if (tView == nil || ![tView isKindOfClass:[TaskView class]])
			continue;
		
		if ([tView isTaskViewType])
			tOrder = [[tView getTask] getTaskOrder];
		else
			tOrder = [[tView getMilestone] getMilestoneNumber];
		
		if (![tView isTaskViewType] && tOrder == (taskOrder - 1))
			delMilestoneView = tView;
			
		if (tOrder < taskOrder)
			continue;
		
		if (tOrder == taskOrder && isTaskView == [tView isTaskViewType]) {
			tView.frame = CGRectZero;
			[tView removeFromSuperview];
			if (isTaskView)
				[self.m_TaskViewList removeObject:tView];
			else
				[self.m_MilestoneViewList removeObject:tView];
			continue;
		}
		
		if (isTaskView) {
			CGRect frame = tView.frame;
			if ([m_Parent isVertical])
				frame.origin.y -= height;
			else
				frame.origin.x -= width;
			tView.frame = frame;
		}
	}
	
	if (isTaskView) {
		CGSize contentSize =  self.m_WrapperView.contentSize;
		if ([m_Parent isVertical])
			contentSize.height -= height;
		else
			contentSize.width -= width;
		self.m_WrapperView.contentSize = contentSize;
	}
	
	[UIView commitAnimations];
	
	return delMilestoneView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	//[m_Parent setCellBackground:m_ProjectIndex];
	[m_Parent hideMilestoneButton];
}

/*
#pragma mark -
#pragma mark methods related touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[m_Parent touchesBegan:touches withEvent:event];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[m_Parent touchesMoved:touches withEvent:event];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[m_Parent touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[m_Parent touchesCancelled:touches withEvent:event];
}
*/


@end
