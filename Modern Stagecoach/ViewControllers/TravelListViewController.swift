//
//  TravelListViewController.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 11.04.2023.
//

import UIKit

class TravelListViewController: UIViewController {
    @IBOutlet weak var travelListTableView: UITableView!
    @IBOutlet var goBackButton: UIButton!
    
    var destinations = [DestinationModel]()
    var destination1: String = ""
    var destination2: String = ""
    var date: String = ""
    var travels = [TravelModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goBackButton.layer.cornerRadius = 10
        self.travelListTableView.rowHeight = 160
        
        let urlStr = "https://api.jsonbin.io/b/620fa8864bf50f4b2d01e7be/1"
        guard let travelURL = URL(string: urlStr) else { return }
        //let data = try? Data(contentsOf: userURL)
        let travelList = try? JSONDecoder().decode([TravelModel].self, from: Data(contentsOf: travelURL))
        travels = travelList!
        for i in 0...travels.count-1{
            destinations.append(DestinationModel(startDestination: destination1, endDestination: destination2, date: date, travelModel: travels[i]))
        }
        travelListTableView.register(UINib(nibName: "TravelTableViewCell", bundle: nil), forCellReuseIdentifier: "travelCellTest")
    }
    
    @IBAction func goBackButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HomeScreenViewController.newTicket.travelHour.time = destinations[indexPath.row].travelModel?.time! ?? "-"
        HomeScreenViewController.newTicket.endTime = destinations[indexPath.row].travelModel?.endTime! ?? "-"
        HomeScreenViewController.newTicket.length = destinations[indexPath.row].travelModel?.travelTime! ?? "-"
        HomeScreenViewController.newTicket.price = destinations[indexPath.row].travelModel?.price! ?? "-"
        
        let busScreenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "busScreenIdentity") as! BusScreenViewController
        busScreenVC.modalPresentationStyle = .fullScreen
        busScreenVC.modalTransitionStyle = .flipHorizontal
        present(busScreenVC, animated: true, completion: nil)
    }
}

extension TravelListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelCellTest") as! Ticket
        cell.configure(model: destinations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
}

