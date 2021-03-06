//
//  LoginViewControl.m
//  Marry
//
//  Created by EagleDu on 12/2/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestManager.h"
#import <QuartzCore/QuartzCore.h>
#import "EmailHelper.h"
#import "UILoadingBox.h"

@implementation LoginViewController

@synthesize imgUnCheck;
@synthesize imgCheck;
@synthesize txtEmail;
@synthesize txtPwd;
@synthesize imgLoading;
@synthesize btnLogin;
@synthesize btnReg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)viewDidLoad {
    isRunning=NO;
    isRemem=YES;
    if(!isRemem){
        imgCheck.hidden=YES;
        imgUnCheck.hidden=NO;
    }
    else{
        imgCheck.hidden=NO;
        imgUnCheck.hidden=YES;
    }
    [super viewDidLoad];
    if([Settings instance].globalInstance.registeredEmail!=nil){
        txtEmail.text=[Settings instance].globalInstance.registeredEmail;
        [Settings instance].globalInstance.registeredEmail=nil;
        [txtPwd becomeFirstResponder];
    }
    //[loading dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


//Login
- (IBAction)loginButtonPressed:(id)sender {    
    if(isRunning){
        [self CancelLogin:sender];
    }
    else{
        [self Login:sender];
    }
}

-(void)Login:(id)sender{
    [txtEmail resignFirstResponder];
    [txtPwd resignFirstResponder];
    BOOL success=[UIHelper validateTextFieldErrorCss:txtEmail];
    success=success &&[UIHelper validateTextFieldErrorCss:txtPwd];
    if(!success)
    {
        return;
    }
    if(![EmailHelper isValidEmail:txtEmail.text])
    {
        [UIHelper showAlert:@"提示" message:@"无效的邮箱格式。" delegate:nil];
        [UIHelper setTextFieldErrorCss:txtEmail isError:YES];
        return;
    }
    else
    {
        [UIHelper setTextFieldErrorCss:txtEmail isError:NO];
    }
    for(UIView *view in self.view.subviews)
    {        
        view.hidden=view.tag!=2;
    }
    isRunning=YES;
    btnLogin.title=@"取消";
    btnLogin.tintColor=[UIColor lightGrayColor];
    [imgLoading startAnimating];
    btnReg.enabled=NO;
    request = [RequestManager loginWithAccount:txtEmail.text password:txtPwd.text funCompleted:^(RequestResult *result) {
        isRunning=NO;
        for(UIView *view in self.view.subviews)
        {
            view.hidden=view.tag==2;
        }
        
        imgCheck.hidden=!isRemem;
        imgUnCheck.hidden=isRemem;
        
        btnLogin.title=@"登陆";
        btnReg.enabled=YES;
        btnLogin.tintColor=[UIColor colorWithRed:0.6 green:0.8 blue:0.5 alpha:0.5];
        [imgLoading stopAnimating];
        if(result.success){
            [self performSegueWithIdentifier:@"LoginToMenu" sender:self];
        }
        else
        {
            [UIHelper showAlert:@"提示" message:result.errorMsg delegate:nil];
        }
    }];    
}
-(void)CancelLogin:(id)sender{
    if(request!=nil){
        [request cancel];
        isRunning=NO;
        for(UIView *view in self.view.subviews)
        {
            view.hidden=view.tag==2;
        }
        imgCheck.hidden=!isRemem;
        imgUnCheck.hidden=isRemem;
        btnReg.enabled=YES;
        btnLogin.title=@"登陆";
        btnLogin.tintColor=[UIColor colorWithRed:0.6 green:0.8 blue:0.5 alpha:0.5];
        [imgLoading stopAnimating];
    }
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (void)viewDidUnload
{
    [self setTxtEmail:nil];
    [self setTxtPwd:nil];
    [self setImgUnCheck:nil];
    [self setImgCheck:nil];
    [self setBtnLogin:nil];
    [self setBtnLogin:nil];
    [self setImgLoading:nil];
    [self setBtnLogin:nil];
    [self setBtnReg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)didTextEditEnd:(UITextField*)sender {
    [sender resignFirstResponder];
    if(txtPwd.text.length>0&&txtEmail.text.length>0){
        [self loginButtonPressed:self];
    }
    else if(sender==txtEmail&&(txtPwd.text ==nil||txtPwd.text.length==0)){
        [txtPwd becomeFirstResponder];
    } 
    else if(sender==txtPwd&&(txtEmail.text==nil||txtEmail.text.length==0)){
        [txtEmail becomeFirstResponder];
    }    
}
- (IBAction)didTextChanged:(id)sender {
    if(txtEmail.text.length!=0&&txtPwd.text.length!=0)
    {
        btnLogin.tintColor=[UIColor colorWithRed:0.6 green:0.8 blue:0.5 alpha:0.5];
    }
    else
    {
        btnLogin.tintColor=nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch = [[event allTouches] anyObject];
    if([touch view]==imgCheck){
        imgCheck.hidden=YES;
        imgUnCheck.hidden=NO;
        isRemem=NO;
    }
    else if([touch view]==imgUnCheck){
        imgCheck.hidden=NO;
        imgUnCheck.hidden=YES;
        isRemem=YES;
    }
    else{
        [txtEmail resignFirstResponder];
        [txtPwd resignFirstResponder];
    }
    if(txtEmail.text.length>0)
        [UIHelper validateTextFieldErrorCss:txtEmail];
    if(txtPwd.text.length>0)
        [UIHelper validateTextFieldErrorCss:txtPwd];
}
#pragma Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
