//
//  ChristmasViewController.swift
//  2023The12DaysOfSwiftmas
//
//  Created by Dawei Hao on 2023/12/10.
//

import UIKit
import SpriteKit
import AVFoundation
import Foundation

class ChristmasViewController: UIViewController {

    // MARK: - speakerButton
    let speakerButton = UIButton(type: .system)
    var configuration = UIButton.Configuration.filled()

    let gradientView = UIView()

    let imageView: UIImageView = UIImageView()

    var timerLabel: UILabel    = UILabel()
//    let timeUnitLabel: UILabel = UILabel()

    let daysLabel : UILabel = UILabel()
    let hoursLabel: UILabel = UILabel()
    let minsLabel : UILabel = UILabel()
    let secsLabel : UILabel = UILabel()

    let cardView: UIView = UIView()

    let stackView:      UIStackView = UIStackView()
    let labelStackView: UIStackView = UIStackView()

    // MARK: - Music player:
    var player: AVQueuePlayer = AVQueuePlayer()
    var looper: AVPlayerLooper?
    var playerItem: AVPlayerItem!
    var isPlayingMusic: Bool = false
    var countButtonCount: Int = 0

    static let songOne:   String = "joyful-jingle-173919"
    static let songTwo:   String = "magic-christmas_medium-177545"
    static let songThree: String = "silent-night_medium-1-177552"
    static let songFour:  String = "enchanted-chimes-177906"
    static let songFive:  String = "joyful-bells-180226"

    let items: [String] = [
        ChristmasViewController.songOne,
        ChristmasViewController.songTwo,
        ChristmasViewController.songThree,
        ChristmasViewController.songFour,
        ChristmasViewController.songFive
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        showSnowflakeWithGradientBackgroundColor()
        configureSpeakerButton()
        playBackgroundMusic()
        configureImageView()
        configureLabel()
        setupTime()
    }

    func configureLabel () {
        timerLabel.text = ""
        timerLabel.font = UIFont.boldSystemFont(ofSize: 44)
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        timerLabel.numberOfLines = 0
        timerLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(timerLabel)

        daysLabel.text = "days"
        daysLabel.font = UIFont.systemFont(ofSize: 19)
        daysLabel.textColor = .systemGray3
        daysLabel.textAlignment = .center
        daysLabel.numberOfLines = 0
        daysLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(daysLabel)

        hoursLabel.text = "hours"
        hoursLabel.font = UIFont.systemFont(ofSize: 19)
        hoursLabel.textColor = .systemGray3
        hoursLabel.textAlignment = .center
        hoursLabel.numberOfLines = 0
        hoursLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(hoursLabel)

        minsLabel.text = "mins"
        minsLabel.font = UIFont.systemFont(ofSize: 19)
        minsLabel.textColor = .systemGray3
        minsLabel.textAlignment = .center
        minsLabel.numberOfLines = 0
        minsLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(minsLabel)

        secsLabel.text = "secs"
        secsLabel.font = UIFont.systemFont(ofSize: 19)
        secsLabel.textColor = .systemGray3
        secsLabel.textAlignment = .center
        secsLabel.numberOfLines = 0
        secsLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(secsLabel)

        daysLabel.widthAnchor.constraint(equalToConstant: 55) .isActive = true
        daysLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        hoursLabel.widthAnchor.constraint(equalToConstant: 55) .isActive = true
        hoursLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        minsLabel.widthAnchor.constraint(equalToConstant: 55) .isActive = true
        minsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true   

        secsLabel.widthAnchor.constraint(equalToConstant: 55) .isActive = true
        secsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        labelStackView.axis = NSLayoutConstraint.Axis.horizontal
        labelStackView.distribution = UIStackView.Distribution.equalSpacing
        labelStackView.alignment = UIStackView.Alignment.center
        labelStackView.spacing = 10

        labelStackView.addArrangedSubview(daysLabel)
        labelStackView.addArrangedSubview(hoursLabel)
        labelStackView.addArrangedSubview(minsLabel)
        labelStackView.addArrangedSubview(secsLabel)
        view.addSubview(labelStackView)

        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalCentering
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 0

        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(labelStackView)
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupTime() {
         let start: Date = Date()
         let calendar: Calendar = Calendar.current

         var components = DateComponents()
         components.year   = 2023
         components.month  = 12
         components.day    = 25
         components.hour   = 0
         components.minute = 0

         guard let end = calendar.date(from: components) else {
             fatalError("Unable to create the end date.")
         }

         var interval = end.timeIntervalSince(start)
         timerLabel.text = formatTimeInterval(interval)

         Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
             guard let strongSelf = self else { return }
             if interval > 0 {
                 interval -= 1
                 let formattedTime = strongSelf.formatTimeInterval(interval)
                 strongSelf.timerLabel.text = formattedTime
                 print(formattedTime)
             } else {
                 timer.invalidate()
             }
         }
     }

    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let days    = Int(interval) / 86400 // There are 86400 seconds in a day
        let hours   = (Int(interval) % 86400) / 3600 // Remaining hours
        let minutes = (Int(interval) % 3600) / 60 // Remaining minutes
        let seconds = Int(interval) % 60 // Corrected seconds calculation

        return  String(format: "%02d:%02d:%02d:%02d", days, hours, minutes, seconds)
    }

    // imageView
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

    // speakerButton
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

    func showSnowflakeWithGradientBackgroundColor() {
        // gradientBackgroundColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 33/255, green: 51/255, blue: 66/255, alpha: 1).cgColor,
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
        looper = AVPlayerLooper(player: player, templateItem: playerItem)
        player.volume = 1.5
        player.play()
        print("In viewDidLoad the volume is: \(player.volume)")
    }

    @objc func playingMusic () {
        if countButtonCount % 2 == 0 {
            // slient
            speakerButton.setImage(UIImage(systemName: "speaker.wave.3"), for: .normal)
            player.volume = 0.0
            print("Now the player volum is: \(player.volume) & CountButtonCount is: \(countButtonCount)")
        } else {
            // speakLoud
            speakerButton.setImage(UIImage(systemName: "speaker.wave.3.fill"), for: .normal)
            player.volume = 1.5
            print("Now the player volum is: \(player.volume) & CountButtonCount is: \(countButtonCount)")
        }
        countButtonCount += 1
    }
}

