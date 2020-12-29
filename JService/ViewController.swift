//
//  ViewController.swift
//  JService
//
//  Created by Christian Shirichena on 12/28/20.
//

import UIKit
import CoreData

struct Clue: Decodable {
    let question: String
    let answer: String
    
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var JeopardyCluesTableView: UITableView!
    
    var clues:[Clue]  = []
    var Clues:[NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.JeopardyCluesTableView.dataSource = self
        self.JeopardyCluesTableView.delegate = self
        self.fetchRandomClues()
//        self.loadPersistentStores
    }
    
    //MARK: - Get data from Network API
    func fetchRandomClues() {
        //https://jservice.io/api/random?count=5
        URLSession.shared.dataTask(with: URL(string: "https://jservice.io/api/random?count=5")!) {
            [weak self] (data, _ , error) in
            guard let data = data else { return }
            guard let clues = try?
                    JSONDecoder().decode([Clue].self, from: data) else { print("No data! error is \(error?.localizedDescription)")
                return
            }
            print(clues)
            self?.clues = clues
            DispatchQueue.main.async {
                self?.JeopardyCluesTableView.reloadData()
            }
        }.resume()
    }
    //MARK: - Saving to Core Data
        @IBAction func addClues(_ sender: Any) {
        
        
    func save(name: String){
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
              return
          }
          let managedContext = appDelegate.persistentContainer.viewContext
          guard let entity = NSEntityDescription.entity(forEntityName: "JeopardyClues", in: managedContext) else { return }
          let jeopardyclues = NSManagedObject(entity: entity, insertInto: managedContext)
          
        jeopardyclues.setValue(question, forKeyPath: "clues")
    
          
          do {
              try managedContext.save()
              clues.append(jeopardyclues)
          } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
          }
      }
      let alert = UIAlertController(title: "New Clue", message: "Add a new clue", preferredStyle: .alert)
      let saveAction = UIAlertAction(title: "Save", style: .default) {
          [unowned self] action in
          guard let textfield = alert.textFields?.first, let clueToSave = textfield.text else {
              return
          }
          
        save(name: clueToSave)
        self.tableView.reloadData
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      alert.addTextField()
      alert.addAction(saveAction)
      alert.addAction(cancelAction)
      present(alert, animated: true)
      
  }

}


// MARK:- Table View cells population
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clues.count
        return self.Clues.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let clue = self.clues[indexPath.row]
        let Clue = self.Clues[indexPath.row]
        cell.textLabel?.text = clue.question
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
//MARK:- Delegate call to answers storyboard
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let answerVC = storyboard.instantiateViewController(withIdentifier: "JeopardyAnswersViewController") as! JeopardyAnswersViewController
        answerVC.question = self.clues[indexPath.row]
        self.navigationController?.pushViewController(answerVC, animated: true)
        
    }
}


