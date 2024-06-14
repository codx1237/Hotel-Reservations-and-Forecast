//
//  ReservationDetailVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 9.06.2024.
//

import UIKit

class ReservationDetailVC: UIViewController {

    
    @IBOutlet weak var guestNameLbl: UILabel!
    @IBOutlet weak var guestCountryLbl: UILabel!
    @IBOutlet weak var guestDateLbl: UILabel!
    @IBOutlet weak var guestNoteLbl: UILabel!
    
    var name: String?
    var country: String?
    var date: String?
    var note: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = name , let country = country , let date = date , let note = note {
            guestNameLbl.text = name
            guestCountryLbl.text = country
            guestDateLbl.text = date
            guestNoteLbl.text = note
        }
    }
    



}
