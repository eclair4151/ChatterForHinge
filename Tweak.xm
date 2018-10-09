@interface SendMessageView: UIView
@property (nonatomic,copy) UITextView *textView; 
@property (nonatomic,copy) UILabel *placeholderLabel; 
@property (nonatomic,copy) UIButton *sendButton;

@end

@interface ChatViewController: UIViewController
@property (nonatomic,copy) UINavigationItem *navigationItem; 
@property (nonatomic,copy) SendMessageView *inputAccessoryView; 
@end


NSMutableDictionary *messageDict;

%hook ChatViewController
	- (void)viewWillAppear:(BOOL)animated {
		%orig;
		if (messageDict == nil) {
			messageDict = [[NSMutableDictionary alloc] init];
		}

		ChatViewController *controller = (ChatViewController *)self;

		NSString *name = ((UILabel *)controller.navigationItem.titleView).text;
		if([messageDict objectForKey:name] && [messageDict[name] length] > 0) {
			controller.inputAccessoryView.textView.text = messageDict[name];
			controller.inputAccessoryView.placeholderLabel.alpha = 0;
			controller.inputAccessoryView.sendButton.enabled = YES;
		}
	}


	- (void)viewWillDisappear:(BOOL)animated {
		ChatViewController *controller = (ChatViewController *)self;

		NSString *currentMessage = controller.inputAccessoryView.textView.text;
		NSString *name = ((UILabel *)controller.navigationItem.titleView).text;
		messageDict[name] = currentMessage;
		
		%orig;
	}

%end

%hook SendMessageView
%end

%ctor {
    %init(SendMessageView = objc_getClass("Hinge.SendMessageView"),
    	ChatViewController = objc_getClass("Hinge.ChatViewController"));
}