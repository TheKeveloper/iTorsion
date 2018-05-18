//
//  MainViewController.swift
//  Eyeliner
//
//  Created by Kevin Bi on 7/12/17.
//  Copyright © 2017 Kevelopment. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppDelegate.bgColor;
        // Do any additional setup after loading the view.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnStart_Click(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil);
        let controller = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController;
        self.present(controller, animated: true, completion: nil);
    }
    
    @IBAction func btnInfo_Touch(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil);
        let controller = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController;
        self.present(controller, animated: true, completion: nil);
    }
    
    
    @IBAction func btnSettings_Touch(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil);
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController;
        self.present(controller, animated: true, completion: nil);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
