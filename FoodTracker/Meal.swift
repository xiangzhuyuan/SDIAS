import UIKit

class Meal: NSObject, NSCoding {
    
    // MARK: types
    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    // MARK: Archiving path
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Meals")
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photoKey) as! UIImage
        
        // here decodeCInt
        let rating =  aDecoder.decodeCInt(forKey: PropertyKey.ratingKey)
            
        self.init(name: name, photo: photo, rating: Int(rating))
        
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(photo, forKey: PropertyKey.photoKey)
        // why here no need to indicate with int?
        aCoder.encode(rating, forKey: PropertyKey.ratingKey)
    }

}
