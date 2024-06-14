//
//  ViewController.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 28.04.2024.
//

import UIKit
import CoreData


class MainVC: UIViewController {

    
    
    @IBOutlet weak var hotelNameTf: UITextField!
    @IBOutlet weak var numberOfRooms: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Hotels> = Hotels.fetchRequest()
//        do{
//            let objects = try! managedContext.fetch(fetchRequest)
//            for obj in objects {
//                managedContext.delete(obj)
//            }
//            try managedContext.save()
//        } catch {
//            print("error")
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isHotelExist() {
            performSegue(withIdentifier: "showHome", sender: nil)
        }
    }
    
    
    
    @IBAction func continueTapped(_ sender: UIButton) {
        guard let hotelName = hotelNameTf.text , let numberOfRooms = numberOfRooms.text , !hotelName.isEmpty , !numberOfRooms.isEmpty  else {
            print("missing information")
            return
        }
        let nRoom: Int? = Int(numberOfRooms)
        addHotelToCoreData(hotel_name: hotelName, hotel_numberOfRooms: nRoom!)
        performSegue(withIdentifier: "showHome", sender: nil)
    }
    
    
    
    
    
    
    
    func isHotelExist() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return false}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Hotels> = Hotels.fetchRequest()
        
        do{
            let count = try! managedContext.count(for: fetchRequest)
            if count == 1 {
                print("there is one account")
                return true
            } else {
                print("there is no hotel")
            }
        }
        return false
    }
    
    
    func addHotelToCoreData(hotel_name: String, hotel_numberOfRooms: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Hotels", in: managedContext)
        let hotel = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        hotel.setValue(hotel_name, forKey: "hotel_name")
        hotel.setValue(hotel_numberOfRooms, forKey: "hotel_numberOfRooms")
        
        do{
            try managedContext.save()
            print("hotel saved succesfully")
        } catch {
            print("error when creating hotel")
        }
    }


    
    
    
}


