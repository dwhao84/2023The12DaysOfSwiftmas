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

    let speakerButton = UIButton(type: .system)
    var configuration = UIButton.Configuration.filled()

    let gradientView = UIView()

    var yearTextField: UITextField   = UITextField()
    var monthTextField: UITextField  = UITextField()
    var dateTextField:  UITextField  = UITextField()
    var secondTextField: UITextField = UITextField()

    var player: AVPlayer = AVPlayer()
    var playerItem: AVPlayerItem?
    var isPlayingMusic: Bool = false

    var countButtonCount: Int = 0

    let imageView: UIImageView = UIImageView()

    static let songOne:   String  = "joyful-jingle-173919"
    static let songTwo:   String  = "magic-christmas_medium-177545"
    static let songThree: String  = "silent-night_medium-1-177552"
    static let songFour:  String  = "enchanted-chimes-177906"
    static let songFive:  String  = "joyful-bells-180226"

    let items: [String] = [
        ChristmasViewController.songOne,
        ChristmasViewController.songTwo,
        ChristmasViewController.songThree,
        ChristmasViewController.songFour,
        ChristmasViewController.songFive
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        configureYearTextField()
        showSnowflakeWithGradientBackgroundColor()
        configureSpeakerButton()
        playBackgroundMusic()
        configureImageView()
    }

    func configureImageView () {
        let aspectRatio: CGFloat = 4 / 3

        let santaClaus = UIImage.animatedImageNamed("SantaClaus_", duration: 5.5)
        imageView.image = santaClaus
        imageView.contentMode = .scaleToFill
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: aspectRatio)
        ])

    }

    func configureSpeakerButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "speaker.wave.3.fill")
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 20)
        configuration.cornerStyle = .large
        speakerButton.configuration = configuration
        speakerButton.tintColor = UIColor(red: 38/255, green: 50/255, blue: 80/255, alpha: 0.7)
        speakerButton.addTarget(self, action: #selector(playingMusic), for: .touchUpInside)
        view.addSubview(speakerButton)

        speakerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speakerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            speakerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            speakerButton.widthAnchor.constraint(equalToConstant: 50),
            speakerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
            UIColor(red: 23/255, green: 41/255, blue: 56/255, alpha: 1).cgColor,
            UIColor(red: 3/255, green: 14/255, blue: 27/255, alpha: 1).cgColor,
            UIColor(red: 3/255, green: 14/255, blue: 27/255, alpha: 1).cgColor
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

    func playBackgroundMusic () {
        isPlayingMusic = true
        guard let fileURL = Bundle.main.url(forResource: items[0], withExtension: "mp3") else { print("Can't find the Music resource")
            return }
        playerItem = AVPlayerItem(url: fileURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

    @objc func playingMusic () {
        if countButtonCount % 2 == 0 {
            speakerButton.setImage(UIImage(systemName: "speaker.wave.3"), for: .normal)
            countButtonCount += 1
            player.pause()
            print("Stop playing")
            print(countButtonCount)
        } else {
            speakerButton.setImage(UIImage(systemName: "speaker.wave.3.fill"), for: .normal)
            countButtonCount += 1
            playBackgroundMusic()
            print("Playing Music")
            print(countButtonCount)
        }
    }
}

