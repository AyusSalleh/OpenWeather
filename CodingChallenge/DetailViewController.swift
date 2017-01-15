//
//  DetailViewController.swift
//  CodingChallenge
//
//  Created by Ayus Salleh on 08/01/2017.
//  Copyright © 2017 SubZ3r0X. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var weatherPressure: UILabel!
    @IBOutlet weak var weatherHumidity: UILabel!
    
    var detailArr = Dictionary<String, Any>()
    var iconData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.image = UIImage(data: iconData)
        
        if let getDateTime = detailArr["dt_txt"] as? String {
            let f = DateFormatter()
            f.locale = Locale(identifier: "en_GB")
            f.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let hookDateTime = f.date(from: getDateTime)!
            let stringDateTime = f.string(from: hookDateTime)
            let separateDate = stringDateTime.components(separatedBy: " ")[0].components(separatedBy: "-")
            let separateTime = stringDateTime.components(separatedBy: " ")[1].components(separatedBy: ":")
            
            let ampm = "\(stringDateTime)".components(separatedBy: " ")[1].components(separatedBy: ":")[0]
            
            if Int(ampm)! > 12 {
                let getMonthFullName = Utility.sharedInstance.getMonthFullName(separateDate[1])
                dateTime.text = "\(separateDate[2].replacingOccurrences(of: "0", with: "")) \(getMonthFullName) \(separateDate[0]) \(Int(separateTime[0])!-12):\(separateTime[1]):\(separateTime[2]) PM"
            } else {
                let getMonthFullName = Utility.sharedInstance.getMonthFullName(separateDate[1])
                dateTime.text = "\(separateDate[2].replacingOccurrences(of: "0", with: "")) \(getMonthFullName) \(separateDate[0]) \(separateTime[0]):\(separateTime[1]):\(separateTime[2]) AM"
            }

        }
        
        if let weatherDetail = detailArr["weather"] as? [[String : Any]] {
            if let weatherTypeOptional = weatherDetail[0]["main"] as? String {
                weatherType.text = weatherTypeOptional.capitalized
            }
            
            if let weatherDescOptional = weatherDetail[0]["description"] as? String {
                weatherDesc.text = weatherDescOptional.capitalized
            }
        }

        if let mainDetail = detailArr["main"] as? [String : Any] {
            if let pressureOptional = mainDetail["pressure"] {
                weatherPressure.text = "\(pressureOptional) hpa"
            }
            
            if let humidityOptional = mainDetail["humidity"] {
                weatherPressure.text = "\(humidityOptional) %"
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.orange
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

}
