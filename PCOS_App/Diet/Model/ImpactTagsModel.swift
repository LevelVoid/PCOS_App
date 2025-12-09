//
//  ImpactTagsDataSource.swift
//  PCOS_App
//
//  Created by SDC-USER on 09/12/25.
//

import Foundation

enum ImpactTags: String, Codable, CaseIterable {

    // Cycle / Symptom
    case bloatingTrigger
    case bloatingReducer
    case crampTrigger
    case crampReducer
    case periodPainTrigger
    case periodPainReducer

    // Hormonal
    case estrogenBoosting
    case estrogenLowering
    case progesteroneSupporting
    case pcosFriendly
    case pcosTrigger
    case androgenBoosting
    case androgenLowering
    case dairySensitive
    case glutenSensitive
    case soySensitive

    // Insulin & Metabolism
    case insulinSpiking
    case insulinBalancing
    case highInsulinLoad
    case lowInsulinLoad
    case highGlycemic
    case mediumGlycemic
    case lowGlycemic

    // Macros
    case highProtein
    case lowProtein
    case highFibre
    case lowFibre
    case healthyFats
    case unhealthyFats
    case highCarb
    case lowCarb

    // Inflammation
    case antiInflammatory
    case proInflammatory

    // Mood / Energy
    case moodBoost
    case energyBoost

    // Processing
    case processed
    case ultraProcessed
    case wholeFood

    // Sugar
    case sugary
    case artificialSweetener
    case noAddedSugar

    // Stimulants
    case caffeine
    case chocolate

    // Digestive
    case gasForming
    case gutFriendly
}
