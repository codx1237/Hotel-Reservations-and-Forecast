//
//  MakeReservationVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 29.05.2024.
//

import UIKit
import CoreData

class MakeReservationVC: UIViewController {

    
    @IBOutlet weak var res_name: UITextField!
    @IBOutlet weak var res_country: UITextField!
    @IBOutlet weak var res_checkin: UITextField!
    @IBOutlet weak var res_note: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    
    @IBAction func saveResTapped(_ sender: UIButton) {
        guard let name = res_name.text , let country = res_country.text , let checkin = res_checkin.text , let note = res_note.text , !name.isEmpty , !country.isEmpty , !checkin.isEmpty , !note.isEmpty else {
            let alert = UIAlertController(title: "Missing Fields", message: "Information required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert,animated: true)
            return
        }
        saveRes(res_name: name, res_country: country, res_checkin: checkin, res_note: note)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func saveRes(res_name: String , res_country: String , res_checkin: String, res_note: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Reservation", in: managedContext)
        let reservation = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        reservation.setValue(UUID().uuidString, forKey: "res_id")
        reservation.setValue(res_name, forKey: "res_name")
        reservation.setValue(res_country, forKey: "res_country")
        reservation.setValue(res_checkin, forKey: "res_checkin")
        reservation.setValue(res_note, forKey: "res_note")
        
        do{
            try managedContext.save()
            print("reservation saved")
        }catch {
            // error
        }
        
        
    }
    


}
