//
//  girisVC.swift
//  deneme1
//
//  Created by Kadir Dündar on 2.02.2023.
//

import UIKit

class girisVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    
    @IBAction func navigasyonTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "navigasyon", sender: nil)
        
    }
    
    @IBAction func haritaTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "openOther", sender: nil)
    }
}
