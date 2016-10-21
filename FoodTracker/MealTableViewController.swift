import UIKit

class MealTableViewController: UITableViewController {
    
    // MARK: properties
    var meals = [Meal]()
    func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let meal1 = Meal(name: "meal1", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")
        let meal2 = Meal(name: "meal2", photo: photo2, rating: 3)!
        
        let photo3 = UIImage(named: "meal3")
        let meal3 = Meal(name: "meal3", photo: photo3, rating: 2)!
        meals += [meal1, meal2, meal3]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedMeals = loadMeals(){
            meals += savedMeals
        }else{
            loadSampleMeals()
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            // update existed
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{ // add new one
                
                let newIndexPath = NSIndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath as IndexPath], with: .bottom)
            }
            saveMeal()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let mealDetailViewController = segue.destination as! MealViewController
            if let selectedMealCell = sender as? MealTableViewCell{
                let indexPath = tableView.indexPath(for: selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem"{
            print("add new item")
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveMeal()
        }else if editingStyle == .insert{
            
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealTableViewCell
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoimageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    // MARK: NScoding
    
    
    func saveMeal(){
        print(Meal.ArchiveURL.absoluteString)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if !isSuccessfulSave{
            print("Failed to save meals ...")
        }
        
    }
    func loadMeals()->[Meal]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
}
