//
//  EditGuestVC.swift
//  Hotel Reservation
//
//  Created by Fırat Ören on 12.06.2024.
//

import UIKit
import CoreData

class EditGuestVC: UIViewController {

    
    
    @IBOutlet weak var editGuestNameTf: UITextField!
    @IBOutlet weak var editGuestCountryTf: UITextField!
    @IBOutlet weak var editPriceTf: UITextField!
    @IBOutlet weak var editCurrencyBtn: UIButton!
    @IBOutlet weak var editGuestNoteTf: UITextField!
    
    var newSelectedCurrency = ""
    var guest: Stay?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let guest = guest {
            editGuestNameTf.text = "\(guest.stay_fullName)"
            editGuestCountryTf.text = "\(guest.stay_country)"
            editPriceTf.text = "\(guest.stay_price)"
            editGuestNoteTf.text = "\(guest.stay_note)"
            newSelectedCurrency = "\(guest.stay_currency)"
            
            
            editCurrencyBtn.menu = UIMenu(children: [
                UIAction(title: "TL" , state: guest.stay_currency == "TL" ? .on : .off  , handler: { action in
                    self.newSelectedCurrency = action.title
                    
                }),
                UIAction(title: "USD", state: guest.stay_currency == "USD" ? .on : .off  , handler: { action in
                    self.newSelectedCurrency = action.title
                }),
                UIAction(title: "EURO", state: guest.stay_currency == "EURO" ? .on : .off  , handler: { action in
                    self.newSelectedCurrency = action.title
                })
            ])
            editCurrencyBtn.showsMenuAsPrimaryAction = true
            editCurrencyBtn.changesSelectionAsPrimaryAction = true
        }
        

       
    }
    

    @IBAction func saveEditGuest(_ sender: UIButton) {
        guard let guestName = editGuestNameTf.text , let guestCountry = editGuestCountryTf.text , let guestPrice = editPriceTf.text , let guestNote = editGuestNoteTf.text, let guestId = guest?.stay_Id, !guestName.isEmpty , !guestCountry.isEmpty , !guestPrice.isEmpty , !newSelectedCurrency.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Missing information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert,animated: true)
            return
        }
        
        EditGuest(guestName: guestName, guestCountry: guestCountry, guestPrice: guestPrice, guestCurrency: newSelectedCurrency, guestNote: guestNote , guestId: guestId)
        self.navigationController?.popViewController(animated: true)
                
    }
    
    func EditGuest(guestName: String, guestCountry: String, guestPrice: String, guestCurrency: String, guestNote: String, guestId: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<Stays> = Stays.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "stay_id == %@", guestId)
        
        do {
            let objects = try! managedContext.fetch(fetchReq)
            for obj in objects {
                obj.setValue(guestName,forKey:"stay_fullName")
                obj.setValue(guestCountry,forKey:"stay_country")
                obj.setValue(guestPrice,forKey:"stay_price")
                obj.setValue(guestCurrency,forKey:"stay_currency")
                obj.setValue(guestNote,forKey:"stay_note")
            }
            try! managedContext.save()
        }
        catch {
            // error
        }
        
    }
    

}
