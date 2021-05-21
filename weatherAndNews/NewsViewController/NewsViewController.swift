//
//  NewsViewController.swift
//  weatherAndNews
//
//  Created by jeyaram-pt4154 on 17/05/21.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet var dropDown: DropDown!
    @IBOutlet var showLabel : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.optionArray = countries
        //Its Id Values and its optional
       
        dropDown.text = "AMBi"
        dropDown.borderStyle = .none
      
        dropDown.didSelect{(selectedText , index ,id) in
        self.showLabel.text = "Selected String: \(selectedText) \n index: \(index)"
        }
        dropDown.listDidDisappear {
            self.dropDown.text = "AMBi"
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let countries = [ "Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia",  "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador", "Egypt",  "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "France Metropolitan", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Haiti", "Heard and Mc Donald Islands", "Holy See (Vatican City State)", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran ", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan", "Lao, People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand",  "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda",  "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone", "Singapore", "South Africa", "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka",  "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (U.S.)", "Wallis and Futuna Islands", "Western Sahara", "Yemen", "Yugoslavia", "Zambia", "Zimbabwe"]
    let ids = [50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,20,80,100,150,200,00,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,50,80,100,150,200,20,80,100,150,200]
}


