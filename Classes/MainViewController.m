    //
//  MainViewController.m
//  Project 40 - MIT License, Some Rights Reserved
//
//  Created by John Stack on 12/15/2011
//  Copyright 2012 Cexi Me LLC. All rights reserved.
//

#import "MainViewController.h"
#import "Project40AppDelegate.h"
#import "ProjectView.h"
#import "TaskView.h"


@implementation MainViewController

//@synthesize m_TableView;
@synthesize m_ScrollView;
@synthesize m_SearchField;
@synthesize m_TabBar;
@synthesize m_MilestoneButton;
@synthesize m_ProjectList;
@synthesize m_ProjectViewList;

@synthesize m_PickedView;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
	// Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization.
	}
	return self;
}
*/

// adds a set of gesture recognizers to one of our piece subviews
- (void)addGestureRecognizersToPiece:(UIView *)piece {
	
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    [panGesture release];
	
	/*
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [piece addGestureRecognizer:rotationGesture];
    [rotationGesture release];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    [panGesture release];
	*/
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showTaskInfo:)];
	longPressGesture.minimumPressDuration = 1.0;
    [piece addGestureRecognizer:longPressGesture];
    [longPressGesture release];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	// self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	Project40AppDelegate* appDelegate = (Project40AppDelegate*)[[UIApplication sharedApplication] delegate];
	self.m_ProjectList = [appDelegate.parser getProjects];
	
	int projectCount = [self.m_ProjectList count];
	self.m_ProjectViewList = [[NSMutableArray alloc] initWithCapacity:projectCount];
	for (int i = 0; i < projectCount; i ++)
		[self.m_ProjectViewList addObject:[NSNull null]];
	
	m_SelectedProjectIndex = -1;
	m_WillDelete = NO;
	
	m_IsVertical = NO;
	[self.m_TabBar setSelectedItem:(UITabBarItem*)[[self.m_TabBar items] objectAtIndex:0]];
	//[self reloadMainView];
	
	[self.m_SearchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu) name:UIMenuControllerWillHideMenuNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHideEditMenu:) name:UIMenuControllerDidHideMenuNotification object:nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	
	//[self reloadMainView];
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	
	[self reloadMainView];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	return self.m_ProjectList == nil ? 0 : [self.m_ProjectList count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 120.0;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	
//	NSString* sectionTitle = nil;
//	if (self.m_ProjectList != nil && section < [self.m_ProjectList count]) {
//		Project* project = (Project*)[self.m_ProjectList objectAtIndex:section];
//		if (project != nil)
//			sectionTitle = [project getProjectName];
//	}
//	return sectionTitle;
//}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Configure the cell...
	
	return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source.
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
	}   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	//self.m_TableView = nil;
	self.m_ScrollView = nil;
	self.m_SearchField = nil;
	self.m_TabBar = nil;
	self.m_MilestoneButton = nil;
	self.m_ProjectList = nil;
	self.m_ProjectViewList = nil;
	self.m_PickedView = nil;
}


- (void)dealloc {
	//[self.m_TableView release];
	[self.m_ScrollView release];
	[self.m_SearchField release];
	[self.m_TabBar release];
	[self.m_MilestoneButton release];
	[self.m_ProjectList release];
	[self.m_ProjectViewList release];
	[self.m_PickedView release];
	
	[super dealloc];
}

- (BOOL)isVertical {
	
	/*
	BOOL portrait = NO;
	
	UITabBarItem* selectedItem = [self.m_TabBar selectedItem];
	if ([selectedItem isEqual:(UITabBarItem*)[[self.m_TabBar items] objectAtIndex:0]])
		portrait = YES;
	
	return portrait;
	*/
	
	return m_IsVertical;
}

- (BOOL)isMovedTaskView {
	return m_IsMoved;
}

- (void)setMovedTaskView:(BOOL)moved {
	m_IsMoved = moved;
}

- (CGRect)getProjectViewFrame:(BOOL)vertical idx:(int)index {
	
	CGRect frame = CGRectZero;
	
	if (vertical) {
		CGFloat width = ProjectView_VerticalWidth;
		frame = CGRectMake(WrapperView_Margin + (width * index), 0.0, ProjectView_VerticalWidth, self.m_ScrollView.frame.size.height);
	} else {
		CGFloat height = ProjectView_HorizontalHieght;
		frame = CGRectMake(0.0, height * index, self.m_ScrollView.frame.size.width, ProjectView_HorizontalHieght);
	}
	
	return frame;
}

- (void)reloadMainView {
	
	BOOL vertical = [self isVertical];
	if (vertical)
		NSLog(@"=========> vertical");
	else
		NSLog(@"=========> horizontal");
	
	if (self.m_ProjectList != nil) {
		
		int projectCount = [self.m_ProjectList count];
		CGRect projectViewframe = CGRectZero;
		
		
		/*
		// JBB Test
		if (self.m_ProjectViewList != nil)
			[self.m_ProjectViewList removeAllObjects];
		if (self.m_ProjectViewList == nil)
			self.m_ProjectViewList = [[NSMutableArray alloc] initWithCapacity:projectCount];
		for (int i = 0; i < projectCount; i ++)
			[self.m_ProjectViewList addObject:[NSNull null]];
		*/
		
		
		for (int index = 0; index < projectCount; index ++) {
			
			if (index >= [self.m_ProjectViewList count])
				continue;
			
			projectViewframe = [self getProjectViewFrame:vertical idx:index];
			
			ProjectView* projectView = [self.m_ProjectViewList objectAtIndex:index];
			if (projectView == nil || (NSNull*)projectView == [NSNull null]) {
				
				NSArray* objs = [[NSBundle mainBundle] loadNibNamed:@"ProjectView" owner:self options:nil];
				for (id curObj in objs) {
					if ([curObj isKindOfClass:[ProjectView class]]) {
						projectView = (ProjectView*)curObj;
					}
				}
				projectView.frame = projectViewframe;
				[projectView setParent:self];
				
				projectView.tag = index;
				[self.m_ScrollView addSubview:projectView];
				[self.m_ProjectViewList replaceObjectAtIndex:index withObject:projectView];
				[projectView release];
			} else {
				projectView.frame = projectViewframe;
			}
			
			Project* project = [self.m_ProjectList objectAtIndex:index];
			[projectView reloadProjectView:project prjIndex:index vertical:vertical];
		}
		
		CGSize contentSize = CGSizeZero;
		if (vertical) {
			CGFloat width = ProjectView_VerticalWidth;
			contentSize = CGSizeMake(projectCount * width + 2 * WrapperView_Margin, self.m_ScrollView.frame.size.height);
		} else {
			CGFloat height = ProjectView_HorizontalHieght;
			contentSize = CGSizeMake(self.m_ScrollView.frame.size.width, projectCount * height);
		}
		
		self.m_ScrollView.contentSize = contentSize;
	}
}

- (void)setCellBackground:(int)projectIndex {
	
	if (projectIndex < 0)
		return;
	
	m_SelectedProjectIndex = projectIndex;
	int projectViewCount = [self.m_ProjectViewList count];
	for (int index = 0; index < projectViewCount; index ++) {
		ProjectView* prjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:index];
		if (prjView == nil || (NSNull*)prjView == [NSNull null])
			continue;
		
		if (m_SelectedProjectIndex == index) {
			prjView.backgroundColor = [UIColor lightGrayColor];
		} else {
			prjView.backgroundColor = [UIColor clearColor];
		}
	}
	[self hideMilestoneButton];
}

- (NSString*)buildTasksData:(NSMutableArray*)taskList {
	
	NSString* xmlData = @"";
	if (taskList == nil || [taskList count] < 1)
		return xmlData;
	
	xmlData = @"<Tasks>";
	for (Task* task in taskList) {
		xmlData = [xmlData stringByAppendingString:@"\n<Task>"];
		xmlData = [xmlData stringByAppendingFormat:@"\n<TaskID>%@</TaskID>", [task getTaskID]];
		xmlData = [xmlData stringByAppendingFormat:@"\n<TaskOrder>%d</TaskOrder>", [task getTaskOrder]];
		xmlData = [xmlData stringByAppendingFormat:@"\n<TaskName>%@</TaskName>", [task getTaskName]];
		xmlData = [xmlData stringByAppendingFormat:@"\n<TaskColor>%@</TaskColor>", [task getTaskColor]];
		xmlData = [xmlData stringByAppendingFormat:@"\n<TaskDuration>%d</TaskDuration>", [task getTaskDuration]];
		xmlData = [xmlData stringByAppendingString:@"\n</Task>"];
	}
	xmlData = [xmlData stringByAppendingString:@"\n</Tasks>"];
	
	return xmlData;
}

- (NSString*)buildMilestonesData:(NSMutableArray*)milestoneList {
	
	NSString* xmlData = @"";
	if (milestoneList == nil || [milestoneList count] < 1)
		return xmlData;
	
	xmlData = @"<Milestones>";
	for (Milestone* milestone in milestoneList) {
		xmlData = [xmlData stringByAppendingString:@"\n<Milestone>"];
		xmlData = [xmlData stringByAppendingFormat:@"\n<MilestoneName>%@</MilestoneName>", [milestone getMilestoneName]];
		xmlData = [xmlData stringByAppendingFormat:@"\n<MilestoneNumber>%d</MilestoneNumber>", [milestone getMilestoneNumber]];
		xmlData = [xmlData stringByAppendingString:@"\n</Milestone>"];
	}
	xmlData = [xmlData stringByAppendingString:@"\n</Milestones>"];
	
	return xmlData;
}

- (NSString*)buildProjectData:(Project*)project {
	
	NSString* xmlData = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<item>";
	if (project != nil) {
		xmlData = [xmlData stringByAppendingFormat:@"\n<ProjectID>%@</ProjectID>", [project getProjectID]];
		xmlData = [xmlData stringByAppendingFormat:@"\n<ProjectName>%@</ProjectName>", [project getProjectName]];
		xmlData = [xmlData stringByAppendingFormat:@"\n<ProjectDesc>%@</ProjectDesc>", [project getProjectDesc]];
		xmlData = [xmlData stringByAppendingFormat:@"\n%@", [self buildTasksData:[project getTasks]]];
		xmlData = [xmlData stringByAppendingFormat:@"\n%@", [self buildMilestonesData:[project getMilestones]]];
	}
	xmlData = [xmlData stringByAppendingString:@"\n</item>"];
	
	NSError* error = nil;
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSString* exportFilePath = [DOCS_FOLDER stringByAppendingPathComponent:@"export.xml"];
	if ([fileManager fileExistsAtPath:exportFilePath])
		[fileManager removeItemAtPath:exportFilePath error:&error];
	[xmlData writeToFile:exportFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
	[fileManager release];
	
	return xmlData;
}

- (void) showMailView
{
       
    UIImage* imageScreenShot = nil;
    
    UIGraphicsBeginImageContext(m_ScrollView.contentSize);
    {
        CGPoint savedContentOffset = m_ScrollView.contentOffset;
        CGRect savedFrame = m_ScrollView.frame;
        
        m_ScrollView.contentOffset = CGPointZero;
        m_ScrollView.frame = CGRectMake(0, 0, m_ScrollView.frame.size.width, m_ScrollView.frame.size.height);
        NSLog(@"content width %f",m_ScrollView.frame.size.width );
        NSLog(@"content height %f",m_ScrollView.frame.size.height);
        NSLog(@"content width %f",m_ScrollView.bounds.size.width );
        NSLog(@"content height %f",m_ScrollView.bounds.size.height);
        [m_ScrollView.layer renderInContext: UIGraphicsGetCurrentContext()];     
        imageScreenShot = UIGraphicsGetImageFromCurrentImageContext();
        
        m_ScrollView.contentOffset = savedContentOffset;
        m_ScrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (imageScreenShot != nil) {
        NSLog(@"=========> started saving image");
        UIImageWriteToSavedPhotosAlbum(imageScreenShot, self, @selector(imagex:didFinishSavingWithError:contextInfo:), nil);
    }
}                                       

   
- (void)imagex:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
        {
            UIAlertView *alert;
            
            // Unable to save the image  
            if (error)
                alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                   message:@"Unable to save Project Snapshot to Photo Album." 
                                                  delegate:self cancelButtonTitle:@"Ok" 
                                         otherButtonTitles:nil];
            else // All is well
                alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                                   message:@"Project Snapshot saved to Photo Album." 
                                                  delegate:self cancelButtonTitle:@"Ok" 
                                         otherButtonTitles:nil];
            [alert show];
            [alert release];
        }


/*- (void)showMailView {
- (void)doMailThing {
	NSString* messageBody = nil;
    
    //jws change to try out PDF attachment.
	if (m_SelectedProjectIndex > -1 && m_SelectedProjectIndex < [self.m_ProjectList count]) {
		Project* project = (Project*)[self.m_ProjectList objectAtIndex:m_SelectedProjectIndex];
		messageBody = [self buildProjectData:project];
	}
	MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	mailController.mailComposeDelegate = self;
	mailController.title = @"Project40";
	mailController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	if ([MFMailComposeViewController canSendMail]) {
		[mailController setSubject:@""];
		[mailController setToRecipients:[NSArray arrayWithObjects:@"", nil]];
		//[mailController setMessageBody:messageBody isHTML:NO];
 //picks up the xml file
 
		[mailController addAttachmentData:[messageBody dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"xml" fileName:@"export.xml"];
 
 //trying the pdf

 [mailController addAttachmentData:[messageBody dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"pdf" fileName:@"test.pdf"];

 [mailController setCcRecipients:nil];
		[mailController setBccRecipients:nil];
		[self presentModalViewController:mailController animated:YES];
	}
} 
  
*/



- (void)showMilestoneButton {
	
	NSString* strTitle = @"";
	if (self.m_PickedView == nil)
		return;
	
	Task* task = [self.m_PickedView getTask];
	Milestone* milestone = [self.m_PickedView getMilestone];

	if ([self.m_PickedView isTaskViewType]) {
		strTitle = [NSString stringWithFormat:@"%@\n%d Minutes", [task getTaskName], [task getTaskDuration]];
	} else {
		
		Project* project = [self.m_ProjectList objectAtIndex:m_SelectedProjectIndex];
		NSMutableArray* taskList = [project getTasks];
		NSMutableArray* milestoneList = [project getMilestones];
		
		int milestoneDuration = 0;
		
		if (taskList != nil) {
			
			int milestoneNumber = [milestone getMilestoneNumber];
			int nextMilestoneNumber = [taskList count];
			if (milestoneList != nil) {
				for (Milestone* milestone in milestoneList) {
					if (milestone == nil)
						continue;
					
					int mNumber = [milestone getMilestoneNumber];
					if (mNumber < milestoneNumber)
						continue;
					
					if (mNumber > milestoneNumber) {
						nextMilestoneNumber = mNumber;
						break;
					}
				}
			}
			
			for (Task* task in taskList) {
				if (task == nil)
					continue;
				
				int taskOrder = [task getTaskOrder];
				if (taskOrder <= milestoneNumber)
					continue;
				if (taskOrder > nextMilestoneNumber)
					continue;
				
				milestoneDuration += [task getTaskDuration];
			}
		}
		
		strTitle = [NSString stringWithFormat:@"%@\n%d Minutes", [milestone getMilestoneName], milestoneDuration];
	}
	
	CGRect dstFrame = self.m_MilestoneButton.frame;
	CGRect srcFrame = self.m_PickedView.frame;
	dstFrame.origin.x = srcFrame.origin.x + srcFrame.size.width;
	dstFrame.origin.y = srcFrame.origin.y - dstFrame.size.height / 2;
	
	if (dstFrame.origin.x + dstFrame.size.width > self.m_ScrollView.frame.origin.x + self.m_ScrollView.frame.size.width)
		dstFrame.origin.x = self.m_ScrollView.frame.origin.x + self.m_ScrollView.frame.size.width - dstFrame.size.width;
	
	
	self.m_MilestoneButton.frame = dstFrame;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	
	[self.m_MilestoneButton setTitle:strTitle forState:UIControlStateNormal];
	self.m_MilestoneButton.alpha = 1.0;
	
	[UIView commitAnimations];
}

- (void)hideMilestoneButton {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	
	self.m_MilestoneButton.alpha = 0.0;
	
	[UIView commitAnimations];
}

- (void)setPickedView:(TaskView*)pickedView {
	
	if (m_SelectedProjectIndex < 0)
		return;
	
	[self setCellBackground:pickedView.tag];
	
	ProjectView* prjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:m_SelectedProjectIndex];
	UIScrollView* wrapperView = prjView.m_WrapperView;
	
	CGRect dstFrame = pickedView.frame;
	CGRect prjViewRect = prjView.frame;
	CGPoint wrapperViewOffset = [wrapperView contentOffset];
	CGPoint offset = [self.m_ScrollView contentOffset];
	
	if ([self isVertical]) {
		dstFrame.origin.x = prjViewRect.origin.x + dstFrame.origin.x - offset.x;
		dstFrame.origin.y = self.m_ScrollView.frame.origin.y + wrapperView.frame.origin.y + dstFrame.origin.y - wrapperViewOffset.y;
	} else {
		dstFrame.origin.x = dstFrame.origin.x - wrapperViewOffset.x;
		dstFrame.origin.y = dstFrame.origin.y + self.m_ScrollView.frame.origin.y + m_SelectedProjectIndex * prjViewRect.size.height + wrapperView.frame.origin.y - offset.y - wrapperViewOffset.y;
	}
	
	[self.m_PickedView setTaskViewType:[pickedView isTaskViewType]];
	//[self.m_PickedView setParent:self prjView:[pickedView getProjectView]];
	[self.m_PickedView setParentForPickedView:self prjView:[pickedView getProjectView]];
	[self.m_PickedView setTask:[pickedView getTask]];
	self.m_PickedView.tag = pickedView.tag;
	
	[self.m_PickedView setTaskViewFrame:dstFrame];
	
	self.m_PickedView.backgroundColor = pickedView.backgroundColor;
	[self.m_PickedView setMilestone:[pickedView getMilestone]];
	
	self.m_PickedView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
	self.m_PickedView.layer.shadowOpacity = 1.0;
	self.m_PickedView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
	
}

- (void)hidePickedView {
	
	//[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	//theView.center = CGPointMake(thePosition.x - m_XOffset, thePosition.y - m_YOffset);
	self.m_PickedView.transform = CGAffineTransformIdentity;
	self.m_PickedView.frame = CGRectMake(0, 0, 0, 0);
	self.m_PickedView.hidden = YES;
	//[UIView commitAnimations];
}

- (void)processTaskMove:(CGPoint)position {
	
	int projectViewCount = [self.m_ProjectViewList count];
	int destProjectViewIndex = -1;
	int destTaskOrder = 1;
	int destMilestoneNumber = 1;
	
	ProjectView* destPrjView = nil;
	for (int index = 0; index < projectViewCount; index ++) {
		destPrjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:index];
		
		if (position.y < self.m_ScrollView.frame.origin.y + destPrjView.m_WrapperView.frame.origin.y)
			break;
			
		CGPoint offset = self.m_ScrollView.contentOffset;
		CGRect prjViewFrameInMainView = destPrjView.frame;
		prjViewFrameInMainView.origin.x = prjViewFrameInMainView.origin.x - offset.x;
		prjViewFrameInMainView.origin.y = prjViewFrameInMainView.origin.y + self.m_ScrollView.frame.origin.y + destPrjView.m_WrapperView.frame.origin.y - offset.y;
		
		if (CGRectContainsPoint(prjViewFrameInMainView, position)) {
			destProjectViewIndex = index;
			
			Project* destProject = (Project*)[self.m_ProjectList objectAtIndex:destProjectViewIndex];
			
			if (destProject.m_Tasks == nil || [destProject.m_Tasks count] < 1)
				break;
			
			int taskCount = [destProject.m_Tasks count];
			if ([self isVertical]) {
				CGFloat height = TaskButton_Height + TaskButton_MarginTop + TaskButton_MarginBottom;
				CGFloat topOfSubView = (taskCount - 1) * height + (self.m_ScrollView.frame.origin.y - offset.y) + 
											(destPrjView.m_WrapperView.frame.origin.y - destPrjView.m_WrapperView.contentOffset.y);
				CGFloat bottomOfSubView = topOfSubView + TaskButton_Height;
				if (position.y >= bottomOfSubView) {
					destTaskOrder = taskCount + 1;
					destMilestoneNumber = destTaskOrder;
					break;
				}
			} else {
				CGFloat width = TaskButton_Width + 2 * TaskButton_MarginLeft;
				CGFloat leftOfSubView = WrapperView_Margin + (taskCount - 1) * width - destPrjView.m_WrapperView.contentOffset.x;
				CGFloat rightOfSubView = leftOfSubView + TaskButton_Width;
				if (position.x >= rightOfSubView) {
					destTaskOrder = taskCount + 1;
					destMilestoneNumber = destTaskOrder;
					break;
				}
			}
			
			for (int idx = 0; idx < [destPrjView.m_TaskViewList count]; idx ++) {
				
				TaskView* subView = (TaskView*)[destPrjView.m_TaskViewList objectAtIndex:idx];
				if (subView == nil || (NSNull*)subView == [NSNull null] || ![subView isKindOfClass:[TaskView class]])
					continue;
				
				if ([self isVertical]) {
					CGFloat topOfSubView = subView.frame.origin.y + (self.m_ScrollView.frame.origin.y - offset.y) + 
												(destPrjView.m_WrapperView.frame.origin.y - destPrjView.m_WrapperView.contentOffset.y);
					CGFloat bottomOfSubView = topOfSubView + TaskButton_Height;
					if (position.y < topOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						if (position.y < topOfSubView - MilestoneButton_VerticalMarginTop)
							destMilestoneNumber = destTaskOrder - 1;
						break;
					} else if (position.y < bottomOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						destMilestoneNumber = destTaskOrder;
						break;
					}
				} else {
					CGFloat leftOfSubView = subView.frame.origin.x - destPrjView.m_WrapperView.contentOffset.x;
					CGFloat rightOfSubView = leftOfSubView + TaskButton_Width;
					if (position.x < leftOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						if (position.x < leftOfSubView - MilestoneButton_MarginLeft)
							destMilestoneNumber = destTaskOrder - 1;
						break;
					} else if (position.x < rightOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						destMilestoneNumber = destTaskOrder;
						break;
					}
				}
			}

			break;
		}
	}
	
	if (destProjectViewIndex == NSNotFound || destProjectViewIndex < 0) {
		NSLog(@"Invalid position");
		return;
	}
	
	
	Project40AppDelegate* appDelegate = (Project40AppDelegate*)[[UIApplication sharedApplication] delegate];
	Project* project = project = (Project*)[self.m_ProjectList objectAtIndex:m_SelectedProjectIndex];
	
	int srcTaskOrder = -1;
	if ([self.m_PickedView isTaskViewType]) {
		srcTaskOrder = [[self.m_PickedView getTask] getTaskOrder];
		if (m_SelectedProjectIndex == destProjectViewIndex && srcTaskOrder == destTaskOrder) {
			NSLog(@"EQUAL TASK");
			return;
		}
		
		//Task* task = [[self.m_PickedView getTask] retain];
		Task* task = [self.m_PickedView getTask];
		NSLog(@"DELETE : index of dest project view = %d, taskOrder : %d, milestoneOrder", m_SelectedProjectIndex, srcTaskOrder, destMilestoneNumber);
		
		ProjectView* srcPrjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:m_SelectedProjectIndex];
		TaskView* delMilestoneView = [srcPrjView deleteTaskWith:self.m_PickedView addTaskOrder:srcTaskOrder];
		if (delMilestoneView != nil) {
			Milestone* delMilestone = [delMilestoneView getMilestone];
			if (delMilestone != nil) {
				[delMilestoneView removeFromSuperview];
				[srcPrjView.m_MilestoneViewList removeObject:delMilestoneView];
				[[project getMilestones] removeObject:delMilestone];
			}
		}
		
		//[project updateTaskWith:task taskOrder:srcTaskOrder isAdd:NO];
		[project updateTaskWith:task taskOrder:srcTaskOrder milestoneNumber:0 isAdd:NO];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
		
		
		if (destProjectViewIndex < [self.m_ProjectList count])
			project = (Project*)[self.m_ProjectList objectAtIndex:destProjectViewIndex];
		
		if (project.m_Tasks == nil || [project.m_Tasks count] < 1) {
			project.m_Tasks = [[NSMutableArray alloc] initWithCapacity:0];
		}
		
		NSLog(@"INSERT : index of dest project view = %d, taskOrder : %d, milestoneOrder : %d", destProjectViewIndex, destTaskOrder, destMilestoneNumber);
		//[project updateTaskWith:task taskOrder:destTaskOrder isAdd:YES];
		[project updateTaskWith:task taskOrder:destTaskOrder milestoneNumber:destMilestoneNumber isAdd:YES];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
		[destPrjView addTaskWith:self.m_PickedView addTaskOrder:destTaskOrder];
		
	} else {
		
		if (![self.m_PickedView isTaskViewType]) {
			Project* project = [self.m_ProjectList objectAtIndex:m_SelectedProjectIndex];
			if (m_SelectedProjectIndex != destProjectViewIndex && [project.m_Milestones count] < 2) {
				[Project40AppDelegate showErrorAlert:@"Can't move milestone." delegate:self tag:-1];
				return;
			}
		}
		
		
		destTaskOrder --;
		srcTaskOrder = [[self.m_PickedView getMilestone] getMilestoneNumber];
		if (m_SelectedProjectIndex == destProjectViewIndex && srcTaskOrder == destTaskOrder) {
			NSLog(@"EQUAL Milestone");
			return;
		}
		
		Milestone* milestone = [[self.m_PickedView getMilestone] retain];
		NSLog(@"DELETE : index of dest project view = %d, milestone view : %d", m_SelectedProjectIndex, srcTaskOrder);
		
		ProjectView* srcPrjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:m_SelectedProjectIndex];
		[srcPrjView deleteTaskWith:self.m_PickedView addTaskOrder:srcTaskOrder];
		
		[project updateMilestoneWith:milestone milestoneNumber:srcTaskOrder isAdd:NO];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
		
		
		if (destProjectViewIndex < [self.m_ProjectList count])
			project = (Project*)[self.m_ProjectList objectAtIndex:destProjectViewIndex];
		
		if (project.m_Milestones == nil || [project.m_Milestones count] < 1) {
			project.m_Milestones = [[NSMutableArray alloc] initWithCapacity:0];
		}
		
		NSLog(@"INSERT : index of dest project view = %d, milestone view : %d", destProjectViewIndex, destTaskOrder);
		//[project.m_Tasks insertObject:task atIndex:destTaskIndex];
		[project updateMilestoneWith:milestone milestoneNumber:destTaskOrder isAdd:YES];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
		[destPrjView addTaskWith:self.m_PickedView addTaskOrder:destTaskOrder];
	}
}

- (void)processTaskCopy:(CGPoint)position {
	
	int projectViewCount = [self.m_ProjectViewList count];
	int destProjectViewIndex = -1;
	int destTaskOrder = 1;
	int destMilestoneNumber = 1;
	
	ProjectView* destPrjView = nil;
	for (int index = 0; index < projectViewCount; index ++) {
		destPrjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:index];
		
		if (position.y < self.m_ScrollView.frame.origin.y + destPrjView.m_WrapperView.frame.origin.y)
			break;
		
		CGPoint offset = self.m_ScrollView.contentOffset;
		CGRect prjViewFrameInMainView = destPrjView.frame;
		prjViewFrameInMainView.origin.x = prjViewFrameInMainView.origin.x - offset.x;
		prjViewFrameInMainView.origin.y = prjViewFrameInMainView.origin.y + self.m_ScrollView.frame.origin.y + destPrjView.m_WrapperView.frame.origin.y - offset.y;
		
		if (CGRectContainsPoint(prjViewFrameInMainView, position)) {
			destProjectViewIndex = index;
			
			Project* destProject = (Project*)[self.m_ProjectList objectAtIndex:destProjectViewIndex];
			
			if (destProject.m_Tasks == nil || [destProject.m_Tasks count] < 1)
				break;
			
			int taskCount = [destProject.m_Tasks count];
			if ([self isVertical]) {
				CGFloat height = TaskButton_Height + TaskButton_MarginTop + TaskButton_MarginBottom;
				CGFloat topOfSubView = (taskCount - 1) * height + (self.m_ScrollView.frame.origin.y - offset.y) + 
				(destPrjView.m_WrapperView.frame.origin.y - destPrjView.m_WrapperView.contentOffset.y);
				CGFloat bottomOfSubView = topOfSubView + TaskButton_Height;
				if (position.y >= bottomOfSubView) {
					destTaskOrder = taskCount + 1;
					destMilestoneNumber = destTaskOrder;
					break;
				}
			} else {
				CGFloat width = TaskButton_Width + 2 * TaskButton_MarginLeft;
				CGFloat leftOfSubView = WrapperView_Margin + (taskCount - 1) * width - destPrjView.m_WrapperView.contentOffset.x;
				CGFloat rightOfSubView = leftOfSubView + TaskButton_Width;
				if (position.x >= rightOfSubView) {
					destTaskOrder = taskCount + 1;
					destMilestoneNumber = destTaskOrder;
					break;
				}
			}
			
			for (int idx = 0; idx < [destPrjView.m_TaskViewList count]; idx ++) {
				
				TaskView* subView = (TaskView*)[destPrjView.m_TaskViewList objectAtIndex:idx];
				if (subView == nil || (NSNull*)subView == [NSNull null] || ![subView isKindOfClass:[TaskView class]])
					continue;
				
				if ([self isVertical]) {
					CGFloat topOfSubView = subView.frame.origin.y + (self.m_ScrollView.frame.origin.y - offset.y) + 
					(destPrjView.m_WrapperView.frame.origin.y - destPrjView.m_WrapperView.contentOffset.y);
					CGFloat bottomOfSubView = topOfSubView + TaskButton_Height;
					if (position.y < topOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						if (position.y < topOfSubView - MilestoneButton_VerticalMarginTop)
							destMilestoneNumber = destTaskOrder - 1;
						break;
					} else if (position.y < bottomOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						destMilestoneNumber = destTaskOrder;
						break;
					}
				} else {
					CGFloat leftOfSubView = subView.frame.origin.x - destPrjView.m_WrapperView.contentOffset.x;
					CGFloat rightOfSubView = leftOfSubView + TaskButton_Width;
					if (position.x < leftOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						if (position.x < leftOfSubView - MilestoneButton_MarginLeft)
							destMilestoneNumber = destTaskOrder - 1;
						break;
					} else if (position.x < rightOfSubView) {
						destTaskOrder = [[subView getTask] getTaskOrder];
						destMilestoneNumber = destTaskOrder;
						break;
					}
				}
			}
			
			break;
		}
	}
	
	
	if (destProjectViewIndex == NSNotFound || destProjectViewIndex < 0) {
		NSLog(@"Invalid position");
		return;
	}
	
	Project40AppDelegate* appDelegate = (Project40AppDelegate*)[[UIApplication sharedApplication] delegate];
	Project* project = project = (Project*)[self.m_ProjectList objectAtIndex:m_SelectedProjectIndex];
	
	int srcTaskOrder = -1;
	if ([self.m_PickedView isTaskViewType]) {
		srcTaskOrder = [[self.m_PickedView getTask] getTaskOrder];
		if (m_SelectedProjectIndex == destProjectViewIndex && srcTaskOrder == destTaskOrder) {
			NSLog(@"EQUAL TASK");
			return;
		}
		
		//Task* task = [[self.m_PickedView getTask] retain];
		Task* task = [self.m_PickedView getTask];
		
		Task* newTask = [[Task alloc] initWithProjectID:[task getProjectID] taskID:[task getTaskID] order:[task getTaskOrder]
												   name:[task getTaskName] color:[task getTaskColor] duration:[task getTaskDuration]];
		[self.m_PickedView setTask:newTask];
		
		if (destProjectViewIndex < [self.m_ProjectList count])
			project = (Project*)[self.m_ProjectList objectAtIndex:destProjectViewIndex];
		
		if (project.m_Tasks == nil || [project.m_Tasks count] < 1) {
			project.m_Tasks = [[NSMutableArray alloc] initWithCapacity:0];
		}
		
		NSLog(@"INSERT : index of dest project view = %d, taskOrder : %d, milestoneOrder : %d", destProjectViewIndex, destTaskOrder, destMilestoneNumber);
		//[project updateTaskWith:newTask taskOrder:destTaskOrder isAdd:YES];
		[project updateTaskWith:newTask taskOrder:destTaskOrder milestoneNumber:destMilestoneNumber isAdd:YES];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
		[destPrjView addTaskWith:self.m_PickedView addTaskOrder:destTaskOrder];
	} else {
		destTaskOrder --;
		srcTaskOrder = [[self.m_PickedView getMilestone] getMilestoneNumber];
		if (m_SelectedProjectIndex == destProjectViewIndex && srcTaskOrder == destTaskOrder) {
			NSLog(@"EQUAL Milestone");
			return;
		}
		
		//Milestone* milestone = [[self.m_PickedView getMilestone] retain];
		Milestone* milestone = [self.m_PickedView getMilestone];
		
		Milestone* newMilestone = [[Milestone alloc] initWithProjectID:[milestone getProjectID] milestoneName:[milestone getMilestoneName] number:[milestone getMilestoneNumber]];
		[self.m_PickedView setMilestone:newMilestone];
		
		if (destProjectViewIndex < [self.m_ProjectList count])
			project = (Project*)[self.m_ProjectList objectAtIndex:destProjectViewIndex];
		
		if (project.m_Milestones == nil || [project.m_Milestones count] < 1) {
			project.m_Milestones = [[NSMutableArray alloc] initWithCapacity:0];
		}
		
		NSLog(@"INSERT : index of dest project view = %d, milestone view : %d", destProjectViewIndex, destTaskOrder);
		//[project.m_Tasks insertObject:task atIndex:destTaskIndex];
		[project updateMilestoneWith:newMilestone milestoneNumber:destTaskOrder isAdd:YES];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
		[destPrjView addTaskWith:self.m_PickedView addTaskOrder:destTaskOrder];
	}
}

- (void)processTaskDelete:(CGPoint)position {
	
	Project40AppDelegate* appDelegate = (Project40AppDelegate*)[[UIApplication sharedApplication] delegate];
	Project* project = project = (Project*)[self.m_ProjectList objectAtIndex:m_SelectedProjectIndex];
	
	int srcTaskOrder = -1;
	if ([self.m_PickedView isTaskViewType]) {
		srcTaskOrder = [[self.m_PickedView getTask] getTaskOrder];
		Task* task = [[self.m_PickedView getTask] retain];
		NSLog(@"DELETE : index of dest project view = %d, task view : %d", m_SelectedProjectIndex, srcTaskOrder);
		
		ProjectView* srcPrjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:m_SelectedProjectIndex];
		[srcPrjView deleteTaskWith:self.m_PickedView addTaskOrder:srcTaskOrder];
		
		//[project updateTaskWith:task taskOrder:srcTaskOrder isAdd:NO];
		[project updateTaskWith:task taskOrder:srcTaskOrder milestoneNumber:0 isAdd:NO];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
	} else {
		srcTaskOrder = [[self.m_PickedView getMilestone] getMilestoneNumber];
		Milestone* milestone = [[self.m_PickedView getMilestone] retain];
		NSLog(@"DELETE : index of dest project view = %d, milestone view : %d", m_SelectedProjectIndex, srcTaskOrder);
		
		ProjectView* srcPrjView = (ProjectView*)[self.m_ProjectViewList objectAtIndex:m_SelectedProjectIndex];
		[srcPrjView deleteTaskWith:self.m_PickedView addTaskOrder:srcTaskOrder];
		
		[project updateMilestoneWith:milestone milestoneNumber:srcTaskOrder isAdd:NO];
		[[appDelegate.parser getSQLManager] saveProject:project];
		
	}
}

- (void)processTaskCancel:(CGPoint)position {
}


#pragma mark -
#pragma mark UITabBarDelegate method

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	
	[self hideMilestoneButton];
	
	NSArray* tabBarItems = [tabBar items];
	int index = [tabBarItems indexOfObject:item];
	switch (index) {
		case 0:
			m_IsVertical = !m_IsVertical;
			[self reloadMainView];
			break;
		case 1:
			//[self reloadMainView];
			break;
		case 2:
			[self showMailView];
			break;
		default:
			break;
	}
}

#pragma mark UIScrollViewDelegate method 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	[self hideMilestoneButton];
}

#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate method

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	NSString* errMessage = nil;
	if (error != nil)
		errMessage = [error localizedDescription];
	
	switch (result) {
		case MFMailComposeResultCancelled:
			[self dismissModalViewControllerAnimated:YES];
			break;
		case MFMailComposeResultFailed:
			[Project40AppDelegate showErrorAlert:[NSString stringWithFormat:@"Error Sending Mail.\n\n ERROR : %@", errMessage] delegate:self tag:-1];
			break;
		case MFMailComposeResultSaved:
			[Project40AppDelegate showErrorAlert:@"Mail Sent." delegate:self tag:-1];
			break;
		case MFMailComposeResultSent:
			[Project40AppDelegate showErrorAlert:@"Mail Sent." delegate:self tag:-1];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark methods related alert

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	m_WillDelete = NO;
	[self animateView:self.m_PickedView toPosition:m_Position];
	switch (buttonIndex) {
		case 0:
			break;
		case 1:
			[self processTaskDelete:m_Position];
			break;
		default:
			break;
	}
}

- (BOOL)validTouchPoint:(CGPoint)point {
	
	BOOL valid = CGRectContainsPoint(self.m_ScrollView.frame, point);
	
	return valid;
}


#pragma mark -
#pragma mark methods related touches
/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSUInteger tapCount = [[touches anyObject] tapCount];
	// Enumerate through all the touch objects.
	NSUInteger touchCount = 0;
	for (UITouch *touch in touches) {
		[self dispatchFirstTouchAtPoint:[touch locationInView:self.view] forEvent:nil tapCount:tapCount];
		touchCount++;
	}
}
*/


-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event tapCount:(int)tCount {
	
	if (tCount != 2) {
		
		self.m_SearchField.text = @"";
		if ([self validTouchPoint:touchPoint]) {
			if (self.m_PickedView.hidden)
				self.m_PickedView.hidden = NO;
			[self.m_ScrollView setScrollEnabled:NO];
			
			m_XOffset = touchPoint.x - self.m_PickedView.center.x;
			m_YOffset = touchPoint.y - self.m_PickedView.center.y;
			[self animateFirstTouchAtPoint:touchPoint forView:self.m_PickedView];
		}
	}
}

/*
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
//	if (self.m_TabBar.selectedItem != [self.m_TabBar.items objectAtIndex:1])
//		return;
	
	NSUInteger touchCount = 0;
	[self setMovedTaskView:YES];
	
	// Enumerates through all touch objects
	for (UITouch *touch in touches) {
		[self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:self.view]];
		touchCount++;
	}
}
*/


-(void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position {
	
	self.m_PickedView.center = CGPointMake(position.x - m_XOffset, position.y - m_YOffset);
}

/*
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
//	if (self.m_TabBar.selectedItem != [self.m_TabBar.items objectAtIndex:1])
//		return;
	
	[self.m_ScrollView setScrollEnabled:YES];
	
	// Enumerates through all touch object
	for (UITouch *touch in touches) {
		[self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self.view]];
	}
	
	//if (!self.m_PickedView.hidden)
	//	self.m_PickedView.hidden = YES;
}
*/

- (void)showConfirm:(NSString*)message {
    //FIXME - get the right title bar
#pragma mark - get the right title going
    
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
													message:message
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (void)showResetMenuWithLocation:(CGPoint)position {
	
	NSLog(@"position : (%f, %f)", position.x, position.y);
	m_Position = position;
	
	CGRect tabBarRect = self.m_TabBar.frame;
	if (CGRectContainsPoint(tabBarRect, position)) {
		m_WillDelete = YES;
		NSString* message = @"Are you sure you wish to delete task?";
		if (![self.m_PickedView isTaskViewType]) {
			Project* project = [self.m_ProjectList objectAtIndex:m_SelectedProjectIndex];
			if ([project.m_Milestones count] > 1)
				message = @"Are you sure you wish to delete this milestone?";
			else {
				[Project40AppDelegate showErrorAlert:@"Can't delete milestone." delegate:self tag:-1];
				return;
			}
		}
		[self showConfirm:message];
		return;
	}
	
	if (!CGRectContainsPoint(self.m_ScrollView.frame, position)) {
		[self animateView:self.m_PickedView toPosition: position];
		return;
	}
	
	m_WillDelete = NO;
	UIMenuController* menuController = [UIMenuController sharedMenuController];
	UIMenuItem* copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyPiece:)];
	UIMenuItem* moveMenuItem = [[UIMenuItem alloc] initWithTitle:@"Move" action:@selector(movePiece:)];
	UIMenuItem* cancelMenuItem = [[UIMenuItem alloc] initWithTitle:@"Cancel" action:@selector(cancelPiece:)];
	//CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
	
	[self becomeFirstResponder];
	[menuController setMenuItems:[NSArray arrayWithObjects:copyMenuItem, moveMenuItem, cancelMenuItem, nil]];
	[menuController setTargetRect:CGRectMake(position.x, position.y, 0, 0) inView:self.view];
	[menuController setMenuVisible:YES animated:YES];
	
	[copyMenuItem release];
	[moveMenuItem release];
	[cancelMenuItem release];
}

-(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position {
	
	/*
	int touchedViewXPos = self.m_PickedView.frame.origin.x + self.m_PickedView.frame.size.width / 2;
	int touchedViewYPos = self.m_PickedView.frame.origin.y + self.m_PickedView.frame.size.height / 2;
	if (!(touchedViewXPos < self.m_ScrollView.frame.origin.x || touchedViewXPos > self.m_ScrollView.frame.origin.x + self.m_ScrollView.frame.size.width ||
		  touchedViewYPos < self.m_ScrollView.frame.origin.y || touchedViewYPos > self.m_ScrollView.frame.origin.y + self.m_ScrollView.frame.size.height)) {
		
	} else {
	}
	*/
	
	
	NSLog(@"dispatchTouchEndEvent (%f, %f)", position.x, position.y);
	if ([self isMovedTaskView]) {
		[self setMovedTaskView:NO];
		[self showResetMenuWithLocation:position];
	} else {
		[self setMovedTaskView:NO];
		[self animateView:self.m_PickedView toPosition: position];
	}

	/*
	[self processTaskMove:position];
	//if (CGRectContainsPoint([m_TouchedView frame], position)) {
	[self animateView:self.m_PickedView toPosition: position];
	//}
	*/
}

/*
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	
//	if (self.m_TabBar.selectedItem != [self.m_TabBar.items objectAtIndex:1])
//		return;
	
	[self setMovedTaskView:NO];
	[self.m_ScrollView setScrollEnabled:YES];
	
	// Enumerates through all touch object
	for (UITouch *touch in touches) {
		[self dispatchTouchCancelEvent:[touch view] toPosition:[touch locationInView:self.view]];
	}
	
	if (!m_WillDelete) {
		if (!self.m_PickedView.hidden) {
			self.m_PickedView.hidden = YES;
		}
	}
}
*/

-(void)dispatchTouchCancelEvent:(UIView *)theView toPosition:(CGPoint)position {
	
	[self animateView:self.m_PickedView toPosition: position];
}


#pragma mark Animating subviews 


-(void)animateFirstTouchAtPoint:(CGPoint)touchPoint forView:(UIView *)theView  {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	theView.transform = CGAffineTransformMakeScale(1.1, 1.1);
	[UIView commitAnimations];
}


-(void)animateView:(UIView *)theView toPosition:(CGPoint)thePosition {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	theView.center = CGPointMake(thePosition.x - m_XOffset, thePosition.y - m_YOffset);
	theView.transform = CGAffineTransformIdentity;
	theView.frame = CGRectMake(0, 0, 0, 0);
	theView.hidden = YES;
	[UIView commitAnimations];
	
}


-(void)animateHideView:(UIView *)theView toPosition:(CGPoint)thePosition {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:SHRINK_ANIMATION_DURATION_SECONDS];
	theView.center = CGPointMake(thePosition.x - m_XOffset, thePosition.y - m_YOffset);
	theView.transform = CGAffineTransformIdentity;
	theView.frame = CGRectMake(0, 0, 0, 0);
	theView.hidden = YES;
	[UIView commitAnimations];
}


// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
	
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
		
		// JBB Test
		if (piece != nil && [(TaskView*)piece isKindOfClass:[TaskView class]]) {
			m_SelectedProjectIndex = ((TaskView*)piece).tag;
			[self setPickedView:((TaskView*)piece)];
			if (self.m_PickedView.hidden)
				self.m_PickedView.hidden = NO;
			[self.m_ScrollView bringSubviewToFront:self.m_PickedView];
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
		self.m_PickedView.transform = CGAffineTransformMakeScale(1.1, 1.1);
		[UIView commitAnimations];
		
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
		//CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        CGPoint locationInMainView = [gestureRecognizer locationInView:self.view];
		CGPoint point = locationInView;
		if (point.x < 0) {
			locationInMainView.x -= point.x;
			point.x = 0.0;
		}
		if (point.y < 0) {
			locationInMainView.y -= point.y;
			point.y = 0.0;
		}
		NSLog(@"%f, %f", locationInMainView.x, locationInMainView.y);
        
		//piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
		//piece.center = locationInSuperview;
		
        self.m_PickedView.layer.anchorPoint = CGPointMake(point.x / piece.bounds.size.width, point.y / piece.bounds.size.height);
        self.m_PickedView.center = locationInMainView;
    }
}

// display a menu with a single item to allow the piece's transform to be reset
- (void)showTaskInfo:(UILongPressGestureRecognizer *)gestureRecognizer {
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
        pieceForReset = [gestureRecognizer view];
		
		UIView *piece = gestureRecognizer.view;
		// JBB Test
		if (piece != nil && [(TaskView*)piece isKindOfClass:[TaskView class]]) {
			m_SelectedProjectIndex = ((TaskView*)piece).tag;
			[self setPickedView:((TaskView*)piece)];
		}
		[self showMilestoneButton];
    }
}

// display a menu with a single item to allow the piece's transform to be reset
- (void)showResetMenu:(UILongPressGestureRecognizer *)gestureRecognizer {
	
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
		
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
		[self showResetMenuWithLocation:location];
    }
}

// animate back to the default anchor point and transform
- (void)copyPiece:(UIMenuController *)controller {
	
	[self processTaskCopy:m_Position];
	[self animateView:self.m_PickedView toPosition:m_Position];
}

// animate back to the default anchor point and transform
- (void)movePiece:(UIMenuController *)controller {
	
	[self processTaskMove:m_Position];
	
	//if (CGRectContainsPoint([m_TouchedView frame], position)) {
	[self animateView:self.m_PickedView toPosition:m_Position];
	//}
}

// animate back to the default anchor point and transform
- (void)cancelPiece:(UIMenuController *)controller {
	
	/*
	[self hidePickedView];
	
    CGPoint locationInSuperview = [pieceForReset convertPoint:CGPointMake(CGRectGetMidX(pieceForReset.bounds), CGRectGetMidY(pieceForReset.bounds)) toView:[pieceForReset superview]];
    
    [[pieceForReset layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [pieceForReset setCenter:locationInSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [pieceForReset setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
	*/
	
	[self processTaskCancel:m_Position];
	[self animateView:self.m_PickedView toPosition:m_Position];
}

// UIMenuController requires that we can become first responder or it won't display
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *piece = [gestureRecognizer view];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
	CGPoint locationInMainView = [gestureRecognizer locationInView:self.view];
	
	//if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
		NSLog(@"UIGestureRecognizerStateBegan");
		
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        //[piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
		
        translation = [gestureRecognizer translationInView:self.m_ScrollView];
        [self.m_PickedView setCenter:locationInMainView];
        //[gestureRecognizer setTranslation:CGPointZero inView:self.m_ScrollView];
	} else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		//NSLog(@"UIGestureRecognizerStateChanged");
		[self setMovedTaskView:YES];
		
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        //[piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
		
        translation = [gestureRecognizer translationInView:self.m_ScrollView];
        [self.m_PickedView setCenter:locationInMainView];
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
		NSLog(@"UIGestureRecognizerStateEnded");
		
		if ([self isMovedTaskView]) {
			[self setMovedTaskView:NO];
			[self showResetMenuWithLocation:locationInMainView];
		} else {
			[self setMovedTaskView:NO];
			[self animateView:self.m_PickedView toPosition:locationInMainView];
		}
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateCancelled) {
		NSLog(@"UIGestureRecognizerStateCancelled");
	}

}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
    }
}

// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
	NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer");
//    if (gestureRecognizer.view != self.m_PickedView)
//        return NO;
    
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	NSLog(@"shouldReceiveTouch");
	
	UIView* piece = gestureRecognizer.view;
	
	// JBB Test
	if (piece != nil && [(TaskView*)piece isKindOfClass:[TaskView class]]) {
		m_SelectedProjectIndex = ((TaskView*)piece).tag;
		[self setPickedView:((TaskView*)piece)];
		if (self.m_PickedView.hidden)
			self.m_PickedView.hidden = NO;
		[self.m_ScrollView bringSubviewToFront:self.m_PickedView];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:GROW_ANIMATION_DURATION_SECONDS];
	self.m_PickedView.transform = CGAffineTransformMakeScale(1.1, 1.1);
	[UIView commitAnimations];
	
	return NO;
}
*/

- (void)textFieldDidChange:(UITextField*)sender {
	
	NSString* searchKey = ((UITextField*)sender).text;
	
	for (ProjectView* prjView in self.m_ProjectViewList) {
		if (prjView != nil) {
			for (TaskView* taskView in prjView.m_WrapperView.subviews) {
				if (taskView != nil && [taskView isKindOfClass:[TaskView class]]) {
					Task* task = [taskView getTask];
					if (task != nil) {
						[taskView setHighlighted:NO];
						
						if (searchKey == nil || searchKey.length < 1)
							continue;
						
						NSString* taskName = [task getTaskName];
						if (taskName != nil && [[taskName lowercaseString] rangeOfString:[searchKey lowercaseString]].length > 0)
							[taskView setHighlighted:YES];
					}
				}
			}
		}
	}
}


- (void)willHideEditMenu {
	
	if (!self.m_PickedView.hidden)
		[self hidePickedView];
}


@end

