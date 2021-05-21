//
//  WeatherCellTableViewCell.swift
//  weatherAndNews
//
//  Created by jeyaram-pt4154 on 17/05/21.
//

import UIKit

class WeatherCellTableViewCell: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var TempLabel: UILabel!
    @IBOutlet var descriptLabel : UILabel!
    @IBOutlet var weatherImage : UIImageView!
    static let identifier = "weatherCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(with model : Daily){
        self.TempLabel.text = "\(Int(model.temp.max))° / \(Int(model.temp.min))°C"
        self.dayLabel.text =  getDayForDate(model.dt)
        self.descriptLabel.text = model.weather[0].weatherDescription.rawValue.firstUppercased
        weatherImage.setImage(urlString: model.weather[0].icon)
        self.TempLabel.contentMode = .scaleAspectFit
        self.descriptLabel.contentMode = .scaleAspectFit
        self.selectionStyle = .none
        
        
    }
    
    func getDayForDate(_ inputDate: Int) -> String{
        let date = Date(timeIntervalSince1970: Double(inputDate))
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let returnDate = formatter.string(from: date )
        return returnDate
    }
    
}


//var iconurl = "http://openweathermap.org/img/w/" + iconcode + ".png";
