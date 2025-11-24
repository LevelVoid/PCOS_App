//
//  Model.swift
//  PCOS_App
//
//  Created by SDC-USER on 22/11/25.
//
import Foundation

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
    var symptoms: [Symptoms]
    var diet: [Food]
    var medicines: [String]
    
}

struct Symptoms{
    var spotting: Spotting
    var discharge: Discharge
    var pain: Pain
    var skinAndHair: SkinAndHair
    var lifestyle: Lifestyle
    var gutHealth: GutHealth
    var breastHealth: BreastHealth
    var timeStamp: Date
}

struct Food{
    var name: String
    var image: String?
    var timeStamp: Date
    var quantity: Double
    var proteinContent: Double
    var carbsContent: Double
    var fatsContent: Double
    var fibreContent: Double
}



