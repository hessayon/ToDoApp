
import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = category.name
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        }catch {
            print("Error saving categoty \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            categories = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            self.saveCategories()
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create a new category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            saveCategories()
            tableView.reloadData()
        }
    }
    
}
