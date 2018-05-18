//
//  SettingsViewController.swift
//  Eyeliner
//
//  Created by Kevin Bi on 7/14/17.
//  Copyright © 2017 Kevelopment. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var lblRedEye: UILabel!
    @IBOutlet weak var lblGreenEye: UILabel!

    @IBOutlet weak var scrollRightR: UISlider!
    @IBOutlet weak var scrollRightG: UISlider!
    @IBOutlet weak var scrollRightB: UISlider!
    
    @IBOutlet weak var scrollLeftR: UISlider!
    @IBOutlet weak var scrollLeftG: UISlider!
    @IBOutlet weak var scrollLeftB: UISlider!
    
    @IBOutlet weak var txtRightR: UITextField!
    @IBOutlet weak var txtRightG: UITextField!
    @IBOutlet weak var txtRightB: UITextField!
    
    @IBOutlet weak var txtLeftR: UITextField!
    @IBOutlet weak var txtLeftG: UITextField!
    @IBOutlet weak var txtLeftB: UITextField!
    
    @IBOutlet weak var lblRightR: UILabel!
    @IBOutlet weak var lblRightG: UILabel!
    @IBOutlet weak var lblRightB: UILabel!
    
    @IBOutlet weak var lblLeftR: UILabel!
    @IBOutlet weak var lblLeftG: UILabel!
    @IBOutlet weak var lblLeftB: UILabel!
    
    
    @IBOutlet weak var sliderBG: UISlider!
    @IBOutlet weak var txtBG: UITextField!
    @IBOutlet weak var lblBG: UILabel!

    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var txtActive : UITextField? = nil;
    
    var toolBar : UIToolbar?;
    
    let RIGHT = 0;
    let LEFT = 1;
    
    var rightScrolls : Array<UISlider?> = []; //Tracks sliders for the right eye color
    var leftScrolls : Array<UISlider?> = [] //Tracks sliders for the left eye color
    
    var leftTexts : Array<UITextField?> = []; //Tracks the TextFields for the left eye color
    var rightTexts : Array<UITextField?> = []; //Tracks the TextFields for the right eye color
    
    var leftLabels : Array<UILabel> = [] //Tracks the labels for the left eye color
    var rightLabels : Array<UILabel> = []; //Tracks the labels for the right eye color
    
    var rightValues : Array<CGFloat> = [255.0, 0, 0]; //Tracks the RGB values for the right eye
    var leftValues : Array<CGFloat> = [0, 255.0, 0]; //Tracks the RGB values for the left eye
    
    var bgValue : CGFloat = 0; //Tracks the greyscale value of the background
    
    var edited = false; //Checks whether the settings have been edited
    
    @IBOutlet weak var headerBG: UILabel! //Gets the header for the background
    
    
    @IBOutlet weak var scrollView: UIScrollView! //The ScrollView that includes everything
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Sets up arrays to store the view elements.
        rightScrolls = [scrollRightR, scrollRightG, scrollRightB];
        leftScrolls = [scrollLeftR, scrollLeftG, scrollLeftB];
        
        leftTexts = [txtLeftR, txtLeftG, txtLeftB];
        rightTexts = [txtRightR, txtRightG, txtRightB];
        
        leftLabels = [lblLeftR, lblLeftG, lblLeftB];
        rightLabels = [lblRightR, lblRightG, lblRightB];
        
        
        //Sets up toolbar to click "Done" on keyboard.
        toolBar = UIToolbar();
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        let done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.done_Press));
        
        toolBar!.barStyle = UIBarStyle.blackTranslucent;
        toolBar!.items = [space, done, space];
        
        toolBar!.sizeToFit();
        
        //React to keyboard come up
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard_show), name: Notification.Name.UIKeyboardDidShow, object: nil);
        
        //Remaining setup
        repositionViews();
        loadData();
        updateColors();
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        //Sets ScrollView content size to ensure scrollability
        scrollView.contentSize = CGSize(width: bgView.bounds.width + 10, height: bgView.bounds.height + rightView.bounds.height + leftView.bounds.height + 300);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnMain_Touch(_ sender: Any) {
        
        //Checks if edited. If not, go directly to the main menu.
        if(!edited){
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController;
            self.present(controller, animated: true, completion: nil);
            return;
        }
        
        //Sets up alert to double check whether user wants to save edits.
        let alert = UIAlertController(title: "Save?", message: "Would you like to save the changes you've made?", preferredStyle: UIAlertControllerStyle.alert);
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.saveData();
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController;
            self.present(controller, animated: true, completion: nil);
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController;
            self.present(controller, animated: true, completion: nil);
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    //Loads previous data.
    func loadData(){
        let defaults = UserDefaults.standard;
        
        //Gets all RGB values and sets the values to the TextEdits and Sliders.
        for i in 0 ..< rightValues.count{
            rightValues[i] = CGFloat(defaults.float(forKey: "RIGHT" + String(describing: i)));
            leftValues[i] = CGFloat(defaults.float(forKey: "LEFT" + String(describing: i)));
            rightTexts[i]!.text = String.init(describing: Int(rightValues[i]));
            leftTexts[i]!.text = String.init(describing: Int(leftValues[i]));
            leftScrolls[i]!.value = Float(leftValues[i]);
            rightScrolls[i]!.value = Float(rightValues[i]);
            
            rightTexts[i]!.inputAccessoryView = toolBar;
            leftTexts[i]!.inputAccessoryView = toolBar;
        }
        
        //Gets background values
        bgValue = CGFloat(defaults.float(forKey: AppDelegate.KEY_BG));
        self.view.backgroundColor = UIColor(red: bgValue / 255, green: bgValue / 255, blue: bgValue / 255, alpha: 1);
        sliderBG.setValue(Float(bgValue), animated: false);
        txtBG.text! = String.init(describing: Int(Float(bgValue)));
        txtBG!.inputAccessoryView = toolBar;
    }
    
    //Saves the data
    func saveData(){
        let defaults = UserDefaults.standard;
        for i in 0 ..< rightValues.count{
            defaults.set(Float(rightValues[i]), forKey: "RIGHT" + String.init(describing: i));
            defaults.set(Float(leftValues[i]), forKey: "LEFT" + String.init(describing: i));
        }
        defaults.set(Float(bgValue), forKey: AppDelegate.KEY_BG);
    }
    
    //Updates the colors of the red and left eye labels
    func updateColors(){
        lblRedEye.backgroundColor = UIColor(red: rightValues[0] / 255, green: rightValues[1] / 255, blue: rightValues[2] / 255, alpha: 1);
        lblGreenEye.backgroundColor = UIColor(red: leftValues[0] / 255, green: leftValues[1] / 255, blue: leftValues[2] / 255, alpha: 1);
    }
    
    //Progromatically repositions views to adjust for screen size
    func repositionViews(){
        let slideScale = CGFloat(0.6);
        
        //Combines arrays to address everything
        let slides = rightScrolls + leftScrolls + [sliderBG];
        let labels = rightLabels + leftLabels + [lblBG];
        let texts = rightTexts + leftTexts + [txtBG];
        
        scrollView.frame.size.width = AppDelegate.screenSize.width * 0.98;
        lblRedEye.frame.size.width = scrollView.frame.size.width;
        lblGreenEye.frame.size.width = scrollView.frame.size.width;
        headerBG.frame.size.width = scrollView.frame.size.width;
        sliderBG.superview?.frame.size.width = scrollView.frame.size.width;
        
        //Handles the repetitive resizing
        for i in 0 ..< slides.count {
            slides[i]?.frame.size.width = AppDelegate.screenSize.width * slideScale;
            slides[i]?.center.x = AppDelegate.screenSize.width * 0.40;
            
            labels[i].frame.origin.x = 0;
            
            texts[i]?.frame.size.width = AppDelegate.screenSize.width * 0.13;
            texts[i]?.center.x = AppDelegate.screenSize.width * 0.8;
        }
    }
    
    
    @IBAction func textRight_Changed(_ sender: UITextField){
        onTextEdit(sender, eye: 0);
    }
    
    @IBAction func textLeft_Changed(_ sender: UITextField){
        onTextEdit(sender, eye: 1);
    }
    
    @IBAction func textField_Clicked(_ sender: UITextField){
        txtActive = sender;
    }
    
    
    @IBAction func scrollRight_Changed(_ sender: UISlider) {
        onSlide(sender, eye: 0);
    }
    
    @IBAction func scrollLeft_Changed(_ sender: UISlider){
        onSlide(sender, eye: 1);
    }
    
    @IBAction func slideBG_Changed(_ sender: UISlider) {
        sender.value = sender.value.rounded();
        bgValue = CGFloat(sender.value);
        txtBG.text = String.init(describing: Int(sender.value));
        
        self.view.backgroundColor = UIColor(red: bgValue / 255, green: bgValue / 255, blue: bgValue / 255, alpha: 1);
        edited = true;
        
    }
    
    @IBAction func txtBG_Changed(_ sender: UITextField) {
        if(Float(txtBG.text!)! > 255){
            txtBG.text! = "255";
        }
        if(Float(txtBG.text!)! < 0){
            txtBG.text! = "0"
        }
        bgValue = CGFloat(Float(txtBG.text!)!);
        txtBG.text! = String(describing: Int(Float(bgValue).rounded()));
        sliderBG.setValue(Float(bgValue), animated: false);
        self.view.backgroundColor = UIColor(red: bgValue / 255, green: bgValue / 255, blue: bgValue / 255, alpha: 1);
        edited = true;
    }
    
    
    //Called in each of the onTextEdit functions
    //textField: Edited text field
    //eye: pass in 0 for RIGHT, 1 for LEFT
    func onTextEdit(_ textField : UITextField, eye : Int){
        let scrolls : Array<UISlider?> = (eye == 0) ? rightScrolls : leftScrolls;
        
        if(Float(textField.text!)! > Float(255.0)){
            textField.text! = "255";
        }
        if(Float(textField.text!)! < Float(0.0)){
            textField.text! = "0";
        }
        textField.text! = String(describing: Int((Float(textField.text!)!.rounded())));
        for i in  0 ..< scrolls.count {
            if(scrolls[i]!.accessibilityIdentifier == textField.accessibilityIdentifier){
                scrolls[i]!.setValue(Float(textField.text!)!, animated: false);
                if(eye == 0){
                    rightValues[i] = CGFloat(Float(textField.text!)!);
                }
                else
                {
                    leftValues[i] = CGFloat(Float(textField.text!)!);
                }
                updateColors();
            }
        }
        edited = true;
    }
    
    //Called in each of the onSlide functions
    //slider: Edited slider
    //eye: pass in 0 for RIGHT, 1 for LEFT
    func onSlide(_ slider : UISlider, eye : Int){
        slider.setValue(slider.value.rounded(), animated: false);
        let texts : Array<UITextField?> = (eye == 0) ? rightTexts : leftTexts;
        for i in 0 ..< texts.count {
            if(texts[i]!.accessibilityIdentifier == slider.accessibilityIdentifier){
                texts[i]!.text = String(describing: Int(slider.value));
                if(eye == 0){
                    rightValues[i] = CGFloat(slider.value);
                }
                else{
                    leftValues[i] = CGFloat(slider.value);
                }
                updateColors();
            }
        }
        edited = true;
    }
    
    @objc func done_Press(){
        self.view.endEditing(true);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    @objc func keyboard_show(){
        if(txtActive != nil && txtActive! != txtBG)
        {
            //Makes sure clicked TextField is visible
            var rect = txtActive!.superview!.superview!.frame;
            rect.origin.y += 100;
            scrollView.scrollRectToVisible(rect, animated: false);
            txtActive = nil;
        }
    }
    
}
