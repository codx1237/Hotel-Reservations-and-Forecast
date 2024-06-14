//
//  RoomDetailVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 3.05.2024.
//

import UIKit
import CoreData

class AddGuestVC: UIViewController {
    
    
    @IBOutlet weak var vw: UIView!
    
    @IBOutlet weak var guestFullNameTf: UITextField!
    @IBOutlet weak var guestCountryTf: UITextField!
    @IBOutlet weak var PriceTf: UITextField!
    @IBOutlet weak var noteTf: UITextField!
    
    @IBOutlet weak var currencyBtn: UIButton!
    
    @IBOutlet weak var roomLbl: UILabel!
    var selectedCurrency = "TL"
    var room_name: String?
    var room_id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let roomName = room_name , let roomId = room_id {
            roomLbl.text = roomName

            
        }
        
        currencyBtn.menu = UIMenu(children: [
            UIAction(title: "TL", state: .on , handler: { action in
                self.selectedCurrency = action.title
            }),
            UIAction(title: "USD", handler: { action in
                self.selectedCurrency = action.title
            }),
            UIAction(title: "EURO", handler: { action in
                self.selectedCurrency = action.title
            })
        ])
        currencyBtn.showsMenuAsPrimaryAction = true
        currencyBtn.changesSelectionAsPrimaryAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {


    }
    
    @IBAction func SaveGuestBtnTapped(_ sender: UIButton) {
        guard let fullName = guestFullNameTf.text , let country = guestCountryTf.text , let price = PriceTf.text , !selectedCurrency.isEmpty, !fullName.isEmpty , !country.isEmpty , !price.isEmpty , let roomId = room_id , let roomName = room_name else {
            return
        }
        saveGuest(roomId: roomId, roomName: roomName, guestFullName: fullName, guestCountry: country, price: price, currency: selectedCurrency, note: noteTf.text!, date: Date())
        
//        guestFullNameTf.text = ""
//        guestCountryTf.text  = ""
//        PriceTf.text         = ""
//        noteTf.text          = ""
        changeIsAvail(roomId: roomId,isAvail: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func getRoomDetail(roomId:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room_id == %@", roomId)
        
        do{
            let details = try managedContext.fetch(fetchRequest)
            for de in details {
                print(de)
            }
        }catch{
            // error
        }
    }
    
    func isRoomAvail(roomId: String, isAvail: Bool) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room_id == %@", roomId)
        
        do{
            let details = try managedContext.fetch(fetchRequest)
            for de in details {
                if de.isavailable {
                    return true
                }
            }
        }catch{
            // error
        }
        return false
    }
    
    func changeIsAvail(roomId: String, isAvail: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room_id == %@", roomId)
        
        do{
            let details = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            let m = details?.first
            m?.setValue(isAvail, forKey: "isavailable")
            try managedContext.save()
        }catch{
            // error
        }
    }

    func saveGuest(roomId: String, roomName: String, guestFullName: String, guestCountry: String, price: String, currency: String, note: String, date: Date){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Stays", in: managedContext)
        let stay = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        stay.setValue(roomId, forKey: "stay_roomId")
        stay.setValue(roomName, forKey: "stay_roomName")
        stay.setValue(guestFullName, forKey: "stay_fullName")
        stay.setValue(guestCountry, forKey: "stay_country")
        stay.setValue(price, forKey: "stay_price")
        stay.setValue(currency, forKey: "stay_currency")
        stay.setValue(note, forKey: "stay_note")
        stay.setValue(date, forKey: "stay_date")
        stay.setValue(UUID().uuidString, forKey: "stay_id")
        
        do{
            try managedContext.save()
            print("guest saved")
        }catch {
            // error
        }
        
    }


}
