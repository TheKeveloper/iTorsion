//
//  InfoViewController.swift
//  Eyeliner
//
//  Created by Kevin Bi on 7/14/17.
//  Copyright © 2017 Kevelopment. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var btnMain: UIButton!
    @IBOutlet weak var txtInstructions: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Programmatic repositioning and establishing scroll functionality. 
        txtInstructions.frame.size.height = AppDelegate.screenSize.height * 0.6;
        txtInstructions.isUserInteractionEnabled = true;
        txtInstructions.contentSize.height = txtInstructions.frame.size.height;
        txtInstructions.isScrollEnabled = false;
        txtInstructions.isScrollEnabled = true;

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
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

    @IBAction func btnMain_Click(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil);
        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController;
        self.present(controller, animated: true, completion: nil);
    }
}
