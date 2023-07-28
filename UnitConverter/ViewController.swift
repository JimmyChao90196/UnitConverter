//
//  ViewController.swift
//  UnitConverter
//
//  Created by JimmyChao on 2023/7/28.
//


import Foundation
import UIKit
import OSLog

class ViewController: UIViewController {

    
    
    //-----------------------------------------VARIABLES---------------------------------------
    
    let logger = Logger()
    
    let convertTypes = ["Distance", "Mass", "Temperature", "Time"]

    let unitTypes = [
        [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]
    ]
    
    
    var selectedUnitTypeIndex = 0{
        didSet{
            initializeSeg(inputSeg, outputSeg)
            updateUnit()
            calculation()
            
            updateTextField()
        }
    }
    var inputUnit:Dimension = UnitLength.meters
    var outputUnit:Dimension = UnitLength.meters
    var inputValue:Double = 10.0
    
    
    

    
    //----------------------------------------IBOUTLETS-------------------------------------------
    
    @IBOutlet var calculateSectionView: UIView!
    @IBOutlet var resultSectionView: UIView!
    @IBOutlet var inputSectionView: UIView!
    @IBOutlet var textFieldView: UITextField!
    @IBOutlet var textFieldUnit: UILabel!
    @IBOutlet var result: UILabel!
    @IBOutlet var convertTypeButton: UIButton!
    @IBOutlet var inputSeg: UISegmentedControl!
    @IBOutlet var outputSeg: UISegmentedControl!
    @IBAction func segValChanged(_ sender: Any) {
        updateUnit()
        calculation()
        updateTextField()
    }
    @IBAction func inputTextField(_ sender: UITextField) {
        inputValue = Double(sender.text ?? "0") ?? 0
        logger.info("\(self.inputValue)")
        
        calculation()
    }
    
    //Set default textField text
    func updateTextField(){
        let defaulMeasurement = Measurement(value: inputValue, unit: inputUnit)
        let output = defaulMeasurement.formatted(.measurement(width: .wide))
        textFieldView.placeholder = output
        
        textFieldUnit.text = inputUnit.symbol.capitalized
        
    }
    
    //Main calculation happend here
    func calculation(){
        let inputMeasurement = Measurement(value: inputValue, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)
        
        let inputString = inputMeasurement.formatted(.measurement(width: .wide))
        let outputString = outputMeasurement.formatted(.measurement(width: .wide))


        result.text = inputString + "\n is \n" + outputString
    }
    
    
    //Initialize button
    func initializePopupButton(){
        let distanceItem = UIAction(title: "Distance", image: UIImage(systemName: "ruler")) { (action) in
            self.selectedUnitTypeIndex = 0
            
            self.convertTypeButton.setTitle(self.convertTypes[self.selectedUnitTypeIndex], for: .normal)
            
            
        }
        
        let massItem = UIAction(title: "Mass", image: UIImage(systemName: "scalemass")) { (action) in
            self.selectedUnitTypeIndex = 1
            
            self.convertTypeButton.setTitle(self.convertTypes[self.selectedUnitTypeIndex], for: .normal)
            
            
        }
        
        let temperatureItem = UIAction(title: "Temperature", image: UIImage(systemName: "thermometer.transmission")) { (action) in
            self.selectedUnitTypeIndex = 2
            
            self.convertTypeButton.setTitle(self.convertTypes[self.selectedUnitTypeIndex], for: .normal)
            
            
        }
        
        let timeItem = UIAction(title: "Time", image: UIImage(systemName: "clock")) { (action) in
            self.selectedUnitTypeIndex = 3
            
            self.convertTypeButton.setTitle(self.convertTypes[self.selectedUnitTypeIndex], for: .normal)
            
            
        }

        
        let menu = UIMenu(title: "Measurement", options: .displayInline, children: [distanceItem , massItem , temperatureItem, timeItem])
        
        
        self.convertTypeButton.setTitle(self.convertTypes[self.selectedUnitTypeIndex], for: .normal)
        

        convertTypeButton.menu = menu
        convertTypeButton.showsMenuAsPrimaryAction = true
        
        
        //Button appearence
        convertTypeButton.clipsToBounds = true
        convertTypeButton.backgroundColor = .clear
        convertTypeButton.layer.cornerRadius = 20
        convertTypeButton.layer.borderWidth = 1.5
        convertTypeButton.layer.borderColor = UIColor.darkGray.cgColor
        

    }
    
    //Initialize segmented control
    func initializeSeg(_ inputSeg:UISegmentedControl, _ outputSeg:UISegmentedControl){
        
        for i in 0...1{
            
            let seg = i==0 ? inputSeg:outputSeg
            
            seg.removeAllSegments()
            
            for unitType in unitTypes[selectedUnitTypeIndex] {
                
                let segmentTitle = unitType.symbol.capitalized
                seg.insertSegment(withTitle: segmentTitle, at: unitTypes[selectedUnitTypeIndex].count, animated: true)
            }
            
            seg.selectedSegmentIndex = i==0 ? 0:unitTypes[selectedUnitTypeIndex].count-1
        }
            updateUnit()
    }
    
    
    //Update unit when segment and textfield value is altered
    func updateUnit(){
        let unitType = unitTypes[selectedUnitTypeIndex]
        
        inputUnit = unitType[inputSeg.selectedSegmentIndex]
        outputUnit = unitType[outputSeg.selectedSegmentIndex]
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    //----------------------------------------VIEWDIDLOAD----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize all
        initializePopupButton()
        initializeSeg(inputSeg, outputSeg)
        updateUnit()
        calculation()
        
        
        updateTextField()
        
        
        inputSectionView.layer.borderColor = UIColor.black.cgColor
        inputSectionView.layer.borderWidth = 2
        inputSectionView.layer.backgroundColor = .init(red: 0.0, green: 0.5, blue: 1, alpha: 0.25)
        
        
        resultSectionView.layer.borderColor = UIColor.black.cgColor
        resultSectionView.layer.borderWidth = 2
        resultSectionView.layer.backgroundColor = .init(red: 0.0, green: 0.4, blue: 1, alpha: 0.5)
        
        
        calculateSectionView.layer.borderColor = UIColor.black.cgColor
        calculateSectionView.layer.borderWidth = 2
        calculateSectionView.layer.backgroundColor = .init(red: 0.0, green: 0.5, blue: 1, alpha: 0.75)
        

    }
}




#Preview {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: "ViewController")
}








