//
//  ForeCastVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 28.04.2024.
//

import UIKit
import CoreData
import UserNotifications

class HomeVC: UIViewController {

    
    @IBOutlet weak var foreCastTV: UITableView!
    var single_Rooms = [Rooms]()
    var double_Rooms = [Rooms]()
    var twin_Rooms   = [Rooms]()
    var triple_Rooms = [Rooms]()
    var all_Rooms    = [Rooms]()
    var reservatios  = [Reservations]()
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var addBtn: UIButton!
    
    // room_type if 0 : single or if 1 : double or if 2 : twin or if 3 : triple room
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let res1 = Reservations(res_id: UUID().uuidString, res_name: "Kenan Bey", res_checkin: "2024-05-27", res_note: "3000 TL odendi. Toplam 9 gece konaklama. Gecelik 700 TL", res_country: "Turkey")
//        let res2 = Reservations(res_id: UUID().uuidString, res_name: "Natalia Markelova", res_checkin: "2024-06-06", res_note: "Gecelik 25 EURO", res_country: "RUSSIA")
//        let res3 = Reservations(res_id: UUID().uuidString, res_name: "Vadim Mitino", res_checkin: "2024-06-06", res_note: "Gecelik 25 EURO", res_country: "RUSSIA")
//        reservatios.append(res1)
//        reservatios.append(res2)
//        reservatios.append(res3)
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
//        do{
//            let objects = try! managedContext.fetch(fetchRequest)
//            for obj in objects {
//                managedContext.delete(obj)
//            }
//            try managedContext.save()
//        } catch {
//            //
//        }

//        Room Stay objects delete
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Stays> = Stays.fetchRequest()
//    
//        do {
//            let objects = try! managedContext.fetch(fetchRequest)
//            print(objects.count)
//            for obj in objects {
//                managedContext.delete(obj)
//               // print(obj.stay_fullName)
//            }
//            try managedContext.save()
//        } catch {
//            print("error deleting data")
//        }
        
        
        
//        Room Available change
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest : NSFetchRequest<Room> = Room.fetchRequest()
//        do{
//            let details = try managedContext.fetch(fetchRequest)
//            for m in details {
//                m.setValue(true, forKey: "isavailable")
//            }
//            
//            try managedContext.save()
//        }catch{
//            // error
//        }
        
       
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddGuest" {
            if let indexPath = self.foreCastTV.indexPathForSelectedRow {
                let guestVC = segue.destination as! AddGuestVC
                switch indexPath.section {
                case 0:
                    guestVC.room_name = single_Rooms[indexPath.row].room_name
                    guestVC.room_id   = single_Rooms[indexPath.row].room_id
                case 1:
                    guestVC.room_name = double_Rooms[indexPath.row].room_name
                    guestVC.room_id   = double_Rooms[indexPath.row].room_id
                case 2:
                    guestVC.room_name = twin_Rooms[indexPath.row].room_name
                    guestVC.room_id   = twin_Rooms[indexPath.row].room_id
                case 3:
                    guestVC.room_name = triple_Rooms[indexPath.row].room_name
                    guestVC.room_id =   triple_Rooms[indexPath.row].room_id
                default:
                    break;
                }
            }
        }
        if segue.identifier == "showGuestDetail" {
            if let indexPath = self.foreCastTV.indexPathForSelectedRow {
                let guestDetail = segue.destination as! GuestDetailVC
                switch indexPath.section {
                case 0:
                    guestDetail.roomName = single_Rooms[indexPath.row].room_name
                    guestDetail.roomId   = single_Rooms[indexPath.row].room_id
                    guestDetail.guest    = getGuest(roomId: single_Rooms[indexPath.row].room_id)
                case 1:
                    guestDetail.roomName = double_Rooms[indexPath.row].room_name
                    guestDetail.roomId   = double_Rooms[indexPath.row].room_id
                    guestDetail.guest    = getGuest(roomId: double_Rooms[indexPath.row].room_id)
                case 2:
                    guestDetail.roomName = twin_Rooms[indexPath.row].room_name
                    guestDetail.roomId   = twin_Rooms[indexPath.row].room_id
                    guestDetail.guest    = getGuest(roomId: twin_Rooms[indexPath.row].room_id)
                case 3:
                    guestDetail.roomName = triple_Rooms[indexPath.row].room_name
                    guestDetail.roomId =   triple_Rooms[indexPath.row].room_id
                    guestDetail.guest    = getGuest(roomId: triple_Rooms[indexPath.row].room_id)
                default:
                    break;
                }
            }
        }
        if segue.identifier == "showResDetail" {
            if let indexPath = self.foreCastTV.indexPathForSelectedRow {
                let ResDetailVC = segue.destination as! ReservationDetailVC
                let resDetail = Reservations.getResDetail(res_id: reservatios[indexPath.row].res_id)
                ResDetailVC.name = "\(resDetail.res_name)"
                ResDetailVC.country = "\(resDetail.res_country)"
                ResDetailVC.date = "\(resDetail.res_checkin)"
                ResDetailVC.note = "\(resDetail.res_note)"
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let notifyContent = UNMutableNotificationContent()
         notifyContent.title = "OREN HOTEL"
        // notifyContent.subtitle = "SUBTITLE"
         notifyContent.body = "You Have \(getNumberOfAvailRoom()) Available Room"
        notifyContent.sound = .defaultCritical
        
         let criteria = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
         
         let notify = UNNotificationRequest(identifier: "hotelNotify", content: notifyContent, trigger: criteria)
         UNUserNotificationCenter.current().add(notify,withCompletionHandler: nil)
        
        single_Rooms.removeAll()
        double_Rooms.removeAll()
        twin_Rooms.removeAll()
        triple_Rooms.removeAll()
        all_Rooms.removeAll()
        reservatios.removeAll()
        getRooms()
        getReservations()
    }
    
    

    @IBAction func segmentedControllerTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
           // foreCastTV.isHidden = false
            foreCastTV.reloadData()
            addBtn.isHidden = true
        case 1:
           // foreCastTV.isHidden = true
            foreCastTV.reloadData()
            addBtn.isHidden = false
        default:
          //  foreCastTV.isHidden = false
            foreCastTV.reloadData()
            addBtn.isHidden = true
           
        }
    }
    
    
    @IBAction func getinfoBtn(_ sender: UIButton) {
        let infoAlert = UIAlertController(title: "Oren Hotel", message: "\(getNumberOfAvailRoom()) Room is available", preferredStyle: .alert)
        infoAlert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(infoAlert,animated: true)
        
    }
    
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        print("add res")
    }
    
    func getNumberOfAvailRoom() -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<Room> = Room.fetchRequest()
        var c = 0
        do {
            let objects = try managedContext.fetch(fetchReq)
            for obj in objects {
                if obj.isavailable {
                    c += 1
                }
            }
            return c
        } catch {
            
        }
        return 0
    }
    
    func getReservations() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Reservation> = Reservation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "res_checkin", ascending: true)]
        do{
            let allres = try managedContext.fetch(fetchRequest)
            for res in allres {
                let ress = Reservations(res_id: res.res_id!, res_name: res.res_name!, res_checkin: res.res_checkin!, res_note: res.res_note!, res_country: res.res_country!)
                reservatios.append(ress)

            }
            foreCastTV.reloadData()
        } catch {
            // error
        }
    }
    
    func getRooms() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "room_name", ascending: true)]
        do{
            let rooms = try managedContext.fetch(fetchRequest)
            for rr in rooms {
                let r = Rooms(room_id: rr.room_id!, room_name: rr.room_name!, room_type: rr.room_type!,room_isavailable: rr.isavailable)
                all_Rooms.append(r)
            }
            for k in all_Rooms {
                switch k.room_type {
                case "Standard Single":
                    single_Rooms.append(Rooms(room_id: k.room_id, room_name: k.room_name, room_type: k.room_type,room_isavailable: k.room_isavailable))
                case "Standard Double":
                    double_Rooms.append(Rooms(room_id: k.room_id, room_name: k.room_name, room_type: k.room_type,room_isavailable: k.room_isavailable))
                case "Standard Twin":
                    twin_Rooms.append(Rooms(room_id: k.room_id, room_name: k.room_name, room_type: k.room_type,room_isavailable: k.room_isavailable))
                case "Standard Triple":
                    triple_Rooms.append(Rooms(room_id: k.room_id, room_name: k.room_name, room_type: k.room_type,room_isavailable: k.room_isavailable))
                default:
                    break;
                }
            }
            foreCastTV.reloadData()
        } catch{
            print("error getting rooms")
        }
    }
    
    func getGuest(roomId: String) -> Stay {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return Stay(stay_roomId: "no id", stay_roomName: "", stay_fullName: "", stay_country: "", stay_price: "", stay_currency: "", stay_checkin: Date(), stay_note: "", stay_Id: "") }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Stays> = Stays.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stay_roomId == %@", roomId)
        
        do{
            let stay = try managedContext.fetch(fetchRequest)
            for s in stay {
                let n = Stay(stay_roomId: s.stay_roomId!, stay_roomName: s.stay_roomName!, stay_fullName: s.stay_fullName!, stay_country: s.stay_country!, stay_price: s.stay_price!, stay_currency: s.stay_currency!, stay_checkin: s.stay_date!, stay_note: s.stay_note!,stay_Id: s.stay_id!)
                return n
            }
            
        } catch {
            //
        }
        return Stay(stay_roomId: "no guest", stay_roomName: "", stay_fullName: "", stay_country: "", stay_price: "", stay_currency: "", stay_checkin: Date(), stay_note: "", stay_Id: "")
    }

}


extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentedController.selectedSegmentIndex == 1 {
            return 1
        } else {
            return 4 // there are 4 room types
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedController.selectedSegmentIndex == 0 {
            if section == 0 {
                if single_Rooms.count == 0 {
                    return 1
                } else {
                    return single_Rooms.count
                }
                
            } else if section == 1 {
                if double_Rooms.count == 0 {
                    return 1
                } else {
                    return double_Rooms.count
                }
                
            } else if section == 2 {
                if twin_Rooms.count == 0 {
                    return 1
                } else {
                    return twin_Rooms.count
                }
                
            } else {
                if triple_Rooms.count == 0 {
                    return 1
                } else {
                    return triple_Rooms.count
                }
                
            }
        } else {
            return reservatios.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentedController.selectedSegmentIndex == 0 {
            if section == 0 {
                return "Single Rooms"
            } else if section == 1 {
                return "Double Rooms"
            } else if section == 2 {
                return "Twin Rooms"
            } else {
                return "Triple Rooms"
            }
        } else {
            return "Reservations"
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedController.selectedSegmentIndex == 0 {
            switch indexPath.section {
            case 0:
                print(single_Rooms[indexPath.row])
                performSegue(withIdentifier: single_Rooms[indexPath.row].room_isavailable ? "showAddGuest" : "showGuestDetail" , sender: nil)
            case 1:
                print(double_Rooms[indexPath.row])
                performSegue(withIdentifier: double_Rooms[indexPath.row].room_isavailable ? "showAddGuest" : "showGuestDetail" , sender: nil)
            case 2:
                print(twin_Rooms[indexPath.row])
                performSegue(withIdentifier: twin_Rooms[indexPath.row].room_isavailable ? "showAddGuest" : "showGuestDetail" , sender: nil)
            case 3:
                print(triple_Rooms[indexPath.row])
                performSegue(withIdentifier: triple_Rooms[indexPath.row].room_isavailable ? "showAddGuest" : "showGuestDetail" , sender: nil)
            default:
                break;
            }
        } else {
            print("selected reservation \(reservatios[indexPath.row])")
            let actionSheet = UIAlertController(title: "Actions", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            actionSheet.addAction(UIAlertAction(title: "Show Reservation", style: .default, handler: { _ in
                print("show res")
                self.performSegue(withIdentifier: "showResDetail", sender: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                print("deleting")
                Reservations.deleteRes(res_id: self.reservatios[indexPath.row].res_id)
                self.reservatios.remove(at: indexPath.row)
                self.foreCastTV.reloadData()
            }))
            self.present(actionSheet,animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        if segmentedController.selectedSegmentIndex == 0 {
            switch indexPath.section {
            case 0:
                if single_Rooms.count == 0 {
                    cell.textLabel?.text = "No Room"
                    cell.detailTextLabel?.text = ""
                    cell.backgroundColor = .clear
                } else {
                    cell.textLabel?.text = single_Rooms[indexPath.row].room_name
                    if single_Rooms[indexPath.row].room_isavailable {
                        cell.detailTextLabel?.text = "available"
                        cell.backgroundColor = .red
                    } else {
                        cell.detailTextLabel?.text = "full"
                        cell.backgroundColor = .green
                    }
                }
            case 1:
                if double_Rooms.count == 0 {
                    cell.textLabel?.text = "No Room"
                    cell.detailTextLabel?.text = ""
                    cell.backgroundColor = .clear
                } else {
                    cell.textLabel?.text = double_Rooms[indexPath.row].room_name
                    if double_Rooms[indexPath.row].room_isavailable {
                        cell.detailTextLabel?.text = "available"
                        cell.backgroundColor = .red
                    } else {
                        cell.detailTextLabel?.text = "full"
                        cell.backgroundColor = .green
                    }
                    
                }
            case 2:
                if twin_Rooms.count == 0 {
                    cell.textLabel?.text = "No Room"
                    cell.detailTextLabel?.text = ""
                    cell.backgroundColor = .clear
                } else {
                    cell.textLabel?.text = twin_Rooms[indexPath.row].room_name
                    if twin_Rooms[indexPath.row].room_isavailable {
                        cell.detailTextLabel?.text = "available"
                        cell.backgroundColor = .red
                    } else {
                        cell.detailTextLabel?.text = "full"
                        cell.backgroundColor = .green
                    }
                }
            case 3:
                if triple_Rooms.count == 0 {
                    cell.textLabel?.text = "No Room"
                    cell.detailTextLabel?.text = ""
                    cell.backgroundColor = .clear
                }else {
                    cell.textLabel?.text = triple_Rooms[indexPath.row].room_name
                    if triple_Rooms[indexPath.row].room_isavailable {
                        cell.detailTextLabel?.text = "available"
                        cell.backgroundColor = .red
                    } else {
                        cell.detailTextLabel?.text = "full"
                        cell.backgroundColor = .green
                    }
                }
            default: break
                
            }
        } else {
            cell.textLabel?.text = "\(reservatios[indexPath.row].res_name)"
            cell.detailTextLabel?.text = "\(reservatios[indexPath.row].res_checkin)"
            cell.backgroundColor = .clear
        }

            cell.textLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            cell.detailTextLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
            
            return cell
        
    }
    
}


struct Rooms {
    var room_id: String
    var room_name: String
    var room_type: String
    var room_isavailable: Bool
}

struct Stay {
    var stay_roomId: String
    var stay_roomName: String
    var stay_fullName: String
    var stay_country: String
    var stay_price: String
    var stay_currency: String
    var stay_checkin: Date
    var stay_note: String
    var stay_Id: String
}

struct Reservations {
    var res_id: String
    var res_name: String
    var res_checkin: String
    var res_note: String
    var res_country: String
    
    
    static func deleteRes(res_id: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Reservation> = Reservation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "res_id == %@", res_id)
        
        do{
            let objects = try! managedContext.fetch(fetchRequest)
            for obj in objects {
                managedContext.delete(obj)
            }
            try managedContext.save()
        }catch{
            print("error when deleting reservation")
        }
    }
    
    static func getResDetail(res_id: String) -> Reservations {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Reservation> = Reservation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "res_id == %@", res_id)
        
        do {
            let objects = try! managedContext.fetch(fetchRequest)
            for obj in objects {
                let resDetail = Reservations(res_id: obj.res_id!, res_name: obj.res_name!, res_checkin: obj.res_checkin!, res_note: obj.res_note!, res_country: obj.res_country!)
                return resDetail
            }
        } catch {
            //
        }
        return Reservations(res_id: "no id", res_name: "no name", res_checkin: "no date", res_note: "no note", res_country: "no country")
    }
}


extension Notification.Name {
    static let notify1 = Notification.Name("availRooms")
}
