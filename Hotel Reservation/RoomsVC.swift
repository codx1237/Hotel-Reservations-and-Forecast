//
//  RoomsVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 28.04.2024.
//

import UIKit
import CoreData

class RoomsVC: UIViewController {

    
    
    @IBOutlet weak var roomTypePW: UIPickerView!
    @IBOutlet weak var roomNameTf: UITextField!
    @IBOutlet weak var hotelName: UILabel!
    
    @IBOutlet weak var singleRoomNumLbl: UILabel!
    @IBOutlet weak var doubleRoomNumLbl: UILabel!
    @IBOutlet weak var twinRoomNumLbl: UILabel!
    @IBOutlet weak var tripleRoomNumLbl: UILabel!
    
    var singleRoomViewTapped = false
    var doubleRoomViewTapped = false
    var twinRoomViewTapped   = false
    var tripleroomViewTapped = false
    
    @IBOutlet weak var singleRoomView: UIView!
    @IBOutlet weak var doubleRoomView: UIView!
    @IBOutlet weak var twinRoomView: UIView!
    @IBOutlet weak var tripleRoomView: UIView!
    
    
    var roomTypes = ["Standard Double","Standard Single","Standard Twin","Standard Triple"]
    var selectedRoomType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomTypePW.delegate = self
        roomTypePW.dataSource = self
    
        let gestureSingleRoom = UITapGestureRecognizer(target: self, action: #selector(singleRoom))
        let gestureDoubleRoom = UITapGestureRecognizer(target: self, action: #selector(doubleRoom))
        let gestureTwinRoom = UITapGestureRecognizer(target: self, action: #selector(twinRoom))
        let gestureTripleRoom = UITapGestureRecognizer(target: self, action: #selector(tripleRoom))
        singleRoomView.addGestureRecognizer(gestureSingleRoom)
        doubleRoomView.addGestureRecognizer(gestureDoubleRoom)
        twinRoomView.addGestureRecognizer(gestureTwinRoom)
        tripleRoomView.addGestureRecognizer(gestureTripleRoom)
        
        singleRoomView.layer.cornerRadius = 18
        doubleRoomView.layer.cornerRadius = 18
        twinRoomView.layer.cornerRadius   = 18
        tripleRoomView.layer.cornerRadius = 18
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hotelName.text = getHotelName()
        getNumOfRooms()
    }
    
    func getRoomsAccordingtoType(roomType: String) -> [Rooms] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<Room> = Room.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "room_type == %@", roomType)
        var newRooms = [Rooms]()
        do {
            let object = try! managedContext.fetch(fetchReq)
            for obj in object {
                newRooms.append(Rooms(room_id: obj.room_id!, room_name: obj.room_name!, room_type: obj.room_type!, room_isavailable: obj.isavailable))
                
            }
            return newRooms
        }
        
        
    }
    
    @objc func singleRoom(){
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "roomsDetailSt") as? RoomDetailVC {
            destVC.roomName = "Single Rooms"
            destVC.rooms = getRoomsAccordingtoType(roomType: "Standard Single")
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    @objc func doubleRoom(){
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "roomsDetailSt") as? RoomDetailVC {
            destVC.roomName = "Double Rooms"
            destVC.rooms = getRoomsAccordingtoType(roomType: "Standard Double")
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    @objc func twinRoom(){
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "roomsDetailSt") as? RoomDetailVC {
            destVC.roomName = "Twin Rooms"
            destVC.rooms = getRoomsAccordingtoType(roomType: "Standard Twin")
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    @objc func tripleRoom(){
        if let destVC = storyboard?.instantiateViewController(withIdentifier: "roomsDetailSt") as? RoomDetailVC {
            destVC.roomName = "Triple Rooms"
            destVC.rooms = getRoomsAccordingtoType(roomType: "Standard Triple")
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    

    @IBAction func contiueTapped(_ sender: UIButton) {
        guard let roomName = roomNameTf.text , !roomName.isEmpty , !selectedRoomType.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Missing information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive,handler: { _ in
                self.view.endEditing(true)
            }))
            present(alert,animated: true)
            return
        }
        let addRoomAlert = UIAlertController(title: "ADD ROOM", message: "Do you want to add room?", preferredStyle: .alert)
        addRoomAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { _ in
            self.view.endEditing(true)
        }))
        addRoomAlert.addAction(UIAlertAction(title: "Add Room", style: .default, handler: { _ in
            self.addRoomToCoreData(room_name: roomName, room_Type: self.selectedRoomType)
            self.view.endEditing(true)
            
        }))
        present(addRoomAlert,animated: true)
        
    }
    
    func getHotelName() -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return "no appdelegate"}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Hotels> = Hotels.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let object = try! managedContext.fetch(fetchRequest)
            for obj in object {
                return obj.hotel_name!
            }
        }catch{
            
        }
        return "no hotel name"
    }
    
    func getNumOfRooms() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchSingle: NSFetchRequest<Room> = Room.fetchRequest()
        let fetchDouble: NSFetchRequest<Room> = Room.fetchRequest()
        let fetchTwin: NSFetchRequest<Room> = Room.fetchRequest()
        let fetchTriple: NSFetchRequest<Room> = Room.fetchRequest()
        fetchSingle.predicate = NSPredicate(format: "room_type == %@", "Standard Single")
        fetchDouble.predicate = NSPredicate(format: "room_type == %@", "Standard Double")
        fetchTwin.predicate   = NSPredicate(format: "room_type == %@", "Standard Twin")
        fetchTriple.predicate = NSPredicate(format: "room_type == %@", "Standard Triple")
        
        
        
        let numSingle = try! managedContext.count(for: fetchSingle)
        let numDouble = try! managedContext.count(for: fetchDouble)
        let numTwin   = try! managedContext.count(for: fetchTwin)
        let numTriple = try! managedContext.count(for: fetchTriple)
        
        self.singleRoomNumLbl.text = "\(numSingle)"
        self.doubleRoomNumLbl.text = "\(numDouble)"
        self.twinRoomNumLbl.text   = "\(numTwin)"
        self.tripleRoomNumLbl.text = "\(numTriple)"
    }
    
    
    func addRoomToCoreData(room_name: String, room_Type: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Room", in: managedContext)
        let room = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        room.setValue(room_name, forKey: "room_name")
        room.setValue(room_Type, forKey: "room_type")
        room.setValue(UUID().uuidString, forKey: "room_id")
        room.setValue(true, forKey: "isavailable")
        do{
            try managedContext.save()
            print("room saved succesfully")
        } catch {
            print("error when creating room")
        }
    }


}




extension RoomsVC: UIPickerViewDelegate,UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomTypes.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRoomType = roomTypes[row]
    }
    
}




