//
//  ViewController.swift
//  weatherAndNews
//
//  Created by jeyaram-pt4154 on 17/05/21.
//

import UIKit

class ViewController: UIViewController{

    
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var weatherButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        newsButton = setButton(button: newsButton, Color: Colors.shrinePink)
        weatherButton = setButton(button: weatherButton, Color: Colors.brazilGreen)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        switch(sender.tag){
        case 0: let returnVc = WeatherCastViewController()
                returnVc.title = "Weather App"
                guard let navigationVC = self.navigationController else { return }
                navigationVC.pushViewController(returnVc, animated: true)
        case 1: let returnVc = NewsViewController()
                returnVc.title = "News App"
                guard let navigationVC = self.navigationController else {return }
                navigationVC.pushViewController(returnVc, animated: true)
            
        default: return
        }
    }
    func setButton(button:UIButton,Color:UIColor)-> UIButton{
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        button.backgroundColor = Color
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 15
        return button
    }
    
  
    

}



