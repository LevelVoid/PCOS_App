import Foundation

//Symptoms enums
enum Spotting{
    case red, brown
}

enum Discharge{
    case dry, sticky, creamy, watery, eggWhite, unusual, positionCervix, textureChange, other
}

enum Pain{
    case abdominalCramp, tenderBreasts, lowerBackPain, headache, vulvarPain, other
}

enum SkinAndHair{
    case acne, hairLoss, skinDarkening, hirsutism
}

enum Lifestyle{
    case fatigue, insomnia, depressed, anxiety
}

enum GutHealth{
    case bloating, constipation, diarrhoea, gas, heartburn
}

enum BreastHealth{
    case fine, engorgement, lump, dimple, redness, cracks, pain, nippleDischarge
}




struct Users{
    let id: UUID
    let name: String
    let password: String
    let dob: Date
    var height: Double
    var weight: Double
    var symptoms: [Symptoms]?
    var diet: [Food]?
    var medicines: [String]?
    

    init(id: UUID, name: String, password: String, dob: Date, height: Double, weight: Double, symptoms: [Symptoms]? = nil, diet: [Food]? = nil, medicines: [String]? = nil) {
        self.id = id
        self.name = name
        self.password = password
        self.dob = dob
        self.height = height
        self.weight = weight
        self.symptoms = symptoms
        self.diet = diet
        self.medicines = medicines
    }
    
    
}

struct Symptoms{
    var spotting: Spotting
    var discharge: Discharge
    var pain: [Pain]
    var skinAndHair: [SkinAndHair]
    var lifestyle: [Lifestyle]
    var gutHealth: [GutHealth]
    var breastHealth: BreastHealth
    var timeStamp: Date
}

    
    
