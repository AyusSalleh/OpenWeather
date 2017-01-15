//
//  BaseViewController.swift
//  CodingChallenge
//
//  Created by Ayus Salleh on 08/01/2017.
//  Copyright © 2017 SubZ3r0X. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupContinueBtn() {
        
        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: 45, height: 44)
        tools.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        tools.backgroundColor = UIColor.clear
        tools.clipsToBounds = true
        tools.isTranslucent = true
        
        let tools2 = UIToolbar()
        tools2.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        tools2.backgroundColor = UIColor.clear
        tools2.clipsToBounds = true
        tools2.isTranslucent = true
        
        let image2 = UIImage(named: "backWhiteImg")!.withRenderingMode(.alwaysOriginal)
        
        let backButton = UIBarButtonItem(image: image2, style: .plain, target: self, action: #selector(BaseViewController.backButtonPressed(_:)))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: -35, bottom: 0, right: 0)

        let buttons1: [UIBarButtonItem] = [backButton]
        tools.setItems(buttons1, animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tools)
        
    }
    
    func backButtonPressed(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func baseContinueBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    
    func showHUD() {
        EZLoadingActivity.show("Loading...", disableUI: true)
    }
    
    func hideHUD() {
        EZLoadingActivity.hide(true, animated: true)
    }
    
    func errorHUD() {
        EZLoadingActivity.hide(false, animated: true)
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
