//
//  ResultViewController.swift
//  Eyeliner
//
//  Created by Kevin Bi on 7/12/17.
//  Copyright © 2017 Kevelopment. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var lblTop: UILabel!
    
    @IBOutlet weak var lblBottom: UILabel!
    
    //Keeps track of how many decimal places of precision the degrees should be
    var precision = 0;
    
    var rightAngle : CGFloat = 0;
    var leftAngle : CGFloat = 0;
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Sets the label text
        lblTop.text = "Right Angle: " + String(describing: abs(rightAngle)) + (rightAngle > 0 ? " In" : " Ex");
        lblBottom.text = "Left Angle: " + String(describing: abs(leftAngle)) + (leftAngle > 0 ? " Ex" : " In");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Allows passing angle info from GameScene
    func setAngles(top: CGFloat, bottom: CGFloat){
        let factor = CGFloat(powf(10, Float(precision)));
        
        //Rounds values to nearest specified
        rightAngle = round(radToDeg(top) * factor) / factor;
        leftAngle = round(radToDeg(bottom) * factor) / factor;
    }
    
    func radToDeg(_ rad: CGFloat) -> CGFloat{
        return rad * 180 / CGFloat.pi;
    }
    
    @IBAction func btnMain_Touch(_ sender: Any) {
        //Establishes an alert to double check whether user wants to move on
        let alert = UIAlertController(title: "Sure?", message: "These results are not saved. Are you sure you wish to return to the Main Menu?", preferredStyle: UIAlertControllerStyle.alert);
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController;
            self.present(controller, animated: true, completion: nil);
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil));
        self.present(alert, animated: true, completion: nil);
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
