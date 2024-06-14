//
//  GuestDetailVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 4.05.2024.
//

import UIKit
import CoreData

class GuestDetailVC: UIViewController {

    // Room change dogu calismiyor. bu yuzden dolayi tum stay veritabani datalarini sil
    // Tum hotels room musaitliginu true yap
    // Kodu duzelt
    
    
    @IBOutlet weak var roomNameLbl: UILabel!
    @IBOutlet weak var guestNameLbl: UILabel!
    @IBOutlet weak var guestCountryLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var guestCheckinLbl: UILabel!
    @IBOutlet weak var guestNoteLbl: UILabel!
    
    @IBOutlet weak var changeRoomNoTf: UITextField!
    
    
    var roomName: String?
    var roomId: String?
    var guest: Stay?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        if let guest = guest {
            roomNameLbl.text = guest.stay_roomName
            guestNameLbl.text = guest.stay_fullName
            guestCountryLbl.text = guest.stay_country
            priceLbl.text = guest.stay_price + guest.stay_currency
            guestCheckinLbl.text = guest.stay_checkin.toString()
            guestNoteLbl.text = guest.stay_note
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditGuest" {
            let vc = segue.destination as! EditGuestVC
            if let guest = guest {
                vc.guest = guest
            }
            
        }
    }

    
    
    @IBAction func checkOutTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "CHECK-OUT", message: "Guest will check-out ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Check-Out", style: .default, handler: { [self] _ in
    
            self.deleteGuest(stay_id: guest!.stay_Id,roomID: guest!.stay_roomId)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert,animated: true)
    }
    

    @IBAction func EditGuest(_ sender: UIButton) {
        performSegue(withIdentifier: "showEditGuest", sender: nil)
    }
    
    
    
    func deleteGuest(stay_id: String,roomID: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Stays> = Stays.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stay_id == %@", stay_id)
    
        do {
            let objects = try! managedContext.fetch(fetchRequest)
            for obj in objects {
                managedContext.delete(obj)
            }
            try managedContext.save()
            changeIsAvail(roomId: roomID, isAvail: true)
        } catch {
            print("error deleting data")
        }
    }
    
    func changeGuestRoom(roomID: String, RoomName: String){
        guard let stay = guest else {return}
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Stays", in: managedContext)
        let stay_stay = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        stay_stay.setValue(roomID, forKey: "stay_roomId")
        stay_stay.setValue(RoomName, forKey: "stay_roomName")
        stay_stay.setValue(stay.stay_fullName, forKey: "stay_fullName")
        stay_stay.setValue(stay.stay_country, forKey: "stay_country")
        stay_stay.setValue(stay.stay_price, forKey: "stay_price")
        stay_stay.setValue(stay.stay_note, forKey: "stay_note")
        stay_stay.setValue(stay.stay_checkin, forKey: "stay_date")
        stay_stay.setValue(stay.stay_Id, forKey: "stay_id")
        
        do{
            try managedContext.save()
            print("guest room change saved")
        }catch {
            // error
        }
    }
    
    func getRoomID(roomName: String) -> String{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return "No appdelegate"}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room_name == %@", roomName)
        do{
            let rooms = try managedContext.fetch(fetchRequest)
            return (rooms.first?.room_id)!
        }catch{
            //
        }
        return ""
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
    
    func isRoomAvailForChange(roomID: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room_id == %@", roomID)
        do {
            let roomsAvail = try managedContext.fetch(fetchRequest)
            for avail in roomsAvail {
                if avail.isavailable {
                    return true
                }
            }
        }catch {
            // error
        }
        return false
    }


}


extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
    let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = format
    return formatter.string(from: self)
    }
}
