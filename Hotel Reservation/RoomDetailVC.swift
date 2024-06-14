//
//  RoomDetailVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 9.06.2024.
//

import UIKit
import CoreData

class RoomDetailVC: UIViewController , UITableViewDataSource, UITableViewDelegate {

    var rooms : [Rooms]?
    
    @IBOutlet weak var roomNameLbl: UILabel!
    
    var roomName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let roomname = roomName {
            roomNameLbl.text = roomname
        }
        if let room = rooms {
            print(room)
        } else {
            print("no room")
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let room = rooms {
            return room.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomDetailCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = "Room Name:"
        if let room = rooms {
            cell.detailTextLabel?.text = "\(room[indexPath.row].room_name)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "EDIT", message: "", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Change room name", style: .default, handler: { _ in
            let ac = UIAlertController(title: "Enter name", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [self] _ in
                if let newName = ac.textFields![0].text , !newName.isEmpty {
                    self.changeRoomName(room_id: self.rooms![indexPath.row].room_id, newRoomName: newName)
                    self.navigationController?.popViewController(animated: true)
                }else {
                    let alert = UIAlertController(title: "Error", message: "INVALID NAME", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alert,animated: true)
                }
                
            }))
            self.present(ac,animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete Room", style: .destructive, handler: { _ in
            print("delete room")
            if self.isRoomAvail(room_id: self.rooms![indexPath.row].room_id)  {
                 self.deleteRoom(room_id: self.rooms![indexPath.row].room_id)
            } else {
                print("Cannot be deleted if the room is not available ")
            }
            
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet,animated: true)
    }
   
    
    func changeRoomName(room_id: String, newRoomName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchReq : NSFetchRequest<Room> = Room.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "room_id == %@", room_id)
        do {
            let object = try! managedContext.fetch(fetchReq)
            for obj in object {
                obj.setValue(newRoomName, forKey: "room_name")
            }
            try managedContext.save()
        } catch {
            // error
        }
    }
    
    func deleteRoom(room_id: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room_id == %@", room_id)
        do{
            let objects = try! managedContext.fetch(fetchRequest)
            for obj in objects {
                managedContext.delete(obj)
            }
            try managedContext.save()
        } catch{
            // error
        }
    }
    
    func isRoomAvail(room_id: String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Room> = Room.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "room_id == %@", room_id)
        
        do{
            let objects = try! managedContext.fetch(fetchRequest)
            for obj in objects {
                if obj.isavailable == true {
                    return true
                }
            }
        } catch {
            //
        }
        return false
    }

}
