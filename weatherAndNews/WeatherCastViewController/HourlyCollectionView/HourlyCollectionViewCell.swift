//
//  HourlyCollectionViewCell.swift
//  weatherAndNews
//
//  Created by jeyaram-pt4154 on 19/05/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var iconImage : UIImageView!
    @IBOutlet var hourLabel : UILabel!
    @IBOutlet var tempLabel : UILabel!
    @IBOutlet var cardView : CardView!
    static let identifier = "hourlyCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with hourData:Current){
        self.iconImage.setImage(urlString: hourData.weather[0].icon)
        self.hourLabel.text = getTimeForDate(hourData.dt)
        self.tempLabel.text = "\(Int(hourData.temp))°C"
    }
    func getTimeForDate(_ inputDate: Int) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm:a"
        let currenDate = Date()
        let currentHour = formatter.string(from: currenDate)
        let date = Date(timeIntervalSince1970: Double(inputDate))
        let returnDate = formatter.string(from: date )
        let currentHourSplit = currentHour.components(separatedBy: ":")
        let returnDateSplit = returnDate.components(separatedBy: ":")
        if(currentHourSplit[0] == returnDateSplit[0] && (currentHourSplit[2] == returnDateSplit[2])){
            cardView.backgroundColor = Colors.yellowColor
            return "Now"
        }
        return returnDate
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        cardView.backgroundColor = UIColor.systemBackground
    }
}
