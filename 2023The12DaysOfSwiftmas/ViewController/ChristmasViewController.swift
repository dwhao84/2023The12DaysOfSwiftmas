//
//  ChristmasViewController.swift
//  2023The12DaysOfSwiftmas
//
//  Created by Dawei Hao on 2023/12/10.
//

import UIKit
import SpriteKit
import AVFoundation

class ChristmasViewController: UIViewController {


    let gradientView = UIView()

    var yearTextField: UITextField   = UITextField()
    var monthTextField: UITextField  = UITextField()
    var dateTextField:  UITextField  = UITextField()
    var secondTextField: UITextField = UITextField()

    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureYearTextField()
        showSnowflakeWithGradientBackgroundColor()

    }


    func configureYearTextField () {
        yearTextField.frame = CGRect(x: 50, y: 100, width: 60, height: 100)

        yearTextField.text = "2023"
        yearTextField.textColor = .lightGray
        yearTextField.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        yearTextField.textAlignment = .center

        yearTextField.layer.cornerRadius = 10
        yearTextField.clipsToBounds = true

        yearTextField.layer.borderWidth = 2
        yearTextField.layer.borderColor = UIColor.black.cgColor

        yearTextField.adjustsFontSizeToFitWidth = true
        view.addSubview(yearTextField)
    }

    func showSnowflakeWithGradientBackgroundColor() {
        // gradientBackgroundColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 1/255, green: 21/255, blue: 45/255, alpha: 1).cgColor,
            UIColor(red: 1/255, green: 35/255, blue: 72/255, alpha: 1).cgColor,
            UIColor(red: 1/255, green: 40/255, blue: 83/255, alpha: 1).cgColor,
            UIColor(red: 1/255, green: 35/255, blue: 72/255, alpha: 1).cgColor,
            UIColor(red: 1/255, green: 21/255, blue: 45/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)

        // snowFlake
        let skView = SKView(frame: view.bounds)
        skView.backgroundColor = .clear
        view.addSubview(skView)

        let scene = SKScene(size: skView.frame.size)
        scene.anchorPoint = CGPoint(x: 0.5, y: 1)
        scene.backgroundColor = .clear

        guard let emitterNode = SKEmitterNode(fileNamed: "MyParticle") else {
            print("Failed to load emitter node from file")
            return
        }
        scene.addChild(emitterNode)
        skView.presentScene(scene)
    }

}
