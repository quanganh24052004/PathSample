//
//  Main.swift
//  PathSample
//
//  Created by iKame Elite Fresher 2025 on 7/28/25.
//

import UIKit

class Main: UIViewController {
    let circleProgress = CircleProgress()
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        button.layer.cornerRadius = 16
        
        let circleMain = CircleMain()
        circleMain.translatesAutoresizingMaskIntoConstraints = false
        circleMain.backgroundColor = .white
        view.addSubview(circleMain)

        NSLayoutConstraint.activate([
            circleMain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleMain.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleMain.widthAnchor.constraint(equalToConstant: 400),
            circleMain.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        circleProgress.translatesAutoresizingMaskIntoConstraints = false
        circleProgress.backgroundColor = .clear
        view.addSubview(circleProgress)
        
        NSLayoutConstraint.activate([
            circleProgress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleProgress.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circleProgress.widthAnchor.constraint(equalToConstant: 400),
            circleProgress.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    @IBAction func randomProgress(_ sender: Any) {
        let randomValue = CGFloat.random(in: 0...1)
        circleProgress.progress = randomValue
    }
}

import UIKit

class CircleProgress: UIView {

    var progress: CGFloat = 0.0 {
        didSet {
            setProgress(progress, animated: true)
        }
    }

    private let circleWidth: CGFloat = 30
    private let startAngle: CGFloat = .pi * 3 / 4
    private let endAngle: CGFloat = .pi * 9 / 4

    private let shapeLayer = CAShapeLayer()
    private let percentageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        setupLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
        setupLabel()
    }

    private func setupLayer() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = circleWidth
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
    }

    private func setupLabel() {
        percentageLabel.textAlignment = .center
        percentageLabel.font = .boldSystemFont(ofSize: 22)
        percentageLabel.textColor = .black
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }

    private func updatePath() {
        let rect = self.bounds
        let radius = min(rect.width, rect.height) / 2 - circleWidth * 2
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        let path = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        shapeLayer.path = path.cgPath
        shapeLayer.strokeEnd = progress
    }

    func setProgress(_ newProgress: CGFloat, animated: Bool) {
        let clamped = max(0.0, min(newProgress, 1.0))
        percentageLabel.text = "\(Int(clamped * 100)) / 100"

        if animated {
            let fromValue = shapeLayer.presentation()?.strokeEnd ?? shapeLayer.strokeEnd
            let distance = abs(clamped - fromValue)
            
            let duration = max(0.2, min(1.0, CFTimeInterval(distance) * 2.0))

            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = fromValue
            animation.toValue = clamped
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            shapeLayer.strokeEnd = clamped
            shapeLayer.add(animation, forKey: "progress")
        } else {
            shapeLayer.strokeEnd = clamped
        }
    }
}

class CircleMain: UIView {
    let circleWidth : CGFloat = 30
    let startAngle : CGFloat = .pi * 3/4
    let endAngle : CGFloat = .pi * 9/4
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = min(rect.width, rect.height) / 2 - circleWidth * 2

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.main.cgColor
        shapeLayer.lineWidth = circleWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
        
    }
}
