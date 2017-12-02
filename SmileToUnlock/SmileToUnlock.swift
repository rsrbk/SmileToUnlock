/*
 MIT License

 Copyright (c) 2017 Ruslan Serebriakov <rsrbk1@gmail.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import ARKit

public enum SmileToUnlockBackground {
    case blue
    case red
    case purple
    case other(UIColor)
}

public class SmileToUnlock: UIViewController {
    /// Tells whether the face tracking is supported on a device(currently it's only for iPhone X).
    /// Please check before creating this view controller!
    static public var isSupported: Bool {
        return ARFaceTrackingConfiguration.isSupported
    }

    /// Action to do after a user has smiled
    public var onSuccess: (() -> Void)?
    /// Sound to play after a user has smiled. Set to nil if you don't want to sound be played.
    public var successSoundPlaying: (() -> Void)? = {
        AudioServicesPlaySystemSound(1075)
    }

    /// Set how much smile do you need from a user. 0.8 is kind of hard already!
    public var successTreshold: CGFloat = 0.7

    /// Background color for this view controller.
    public var backgroundColor: SmileToUnlockBackground = .blue

    public var titleLabel: UILabel!
    public var titleText: String? = "Hello," {
        didSet {
            titleLabel.text = titleText
        }
    }

    public var subtitleLabel: UILabel!
    public var subtitleText: String? = "Begin using our app from the smile" {
        didSet {
            subtitleLabel.text = subtitleText
        }
    }

    public var smileView: SmileView!
    public var checkmarkView: CheckmarkView!

    public var skipButton: UIButton!
    public var skipButtonText: String? = "Skip this" {
        didSet {
            skipButton.setTitle(skipButtonText, for: .normal)
        }
    }

    private var unlocked = false

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        createInterface()
        layoutInterface()
        configureFaceRecognition()
    }

    private func createInterface() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.text = titleText
        view.addSubview(titleLabel)

        subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 23, weight: .light)
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = subtitleText
        subtitleLabel.numberOfLines = 0
        view.addSubview(subtitleLabel)

        smileView = SmileView()
        smileView.backgroundColor = UIColor.clear
        view.addSubview(smileView)

        checkmarkView = CheckmarkView()
        checkmarkView.backgroundColor = UIColor.clear
        checkmarkView.alpha = 0.0
        view.addSubview(checkmarkView)

        skipButton = UIButton()
        skipButton.layer.cornerRadius = 3.0
        skipButton.layer.borderColor = UIColor.white.cgColor
        skipButton.layer.borderWidth = 1.0
        skipButton.setTitle(skipButtonText, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .light)
        skipButton.addTarget(self, action: #selector(SmileToUnlock.skipAction), for: .touchUpInside)
        view.addSubview(skipButton)

        switch backgroundColor {
        case .blue:
            view.backgroundColor = UIColor(red: 67.0/255.0, green: 173.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        case .red:
            view.backgroundColor = UIColor(red: 255.0/255.0, green: 79.0/255.0, blue: 87.0/255.0, alpha: 1.0)
        case .purple:
            view.backgroundColor = UIColor(red: 185.0/255.0, green: 81.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        case .other(let color):
            view.backgroundColor = color
        }
    }

    private func layoutInterface() {
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        let safeArea = self.view.safeAreaLayoutGuide

        titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -4.0).isActive = true

        subtitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20.0).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20.0).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: smileView.topAnchor, constant: -60.0).isActive = true

        smileView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40.0).isActive = true
        smileView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40.0).isActive = true
        smileView.widthAnchor.constraint(equalTo: smileView.heightAnchor).isActive = true

        checkmarkView.topAnchor.constraint(equalTo: smileView.bottomAnchor, constant: 20.0).isActive = true
        checkmarkView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        checkmarkView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        checkmarkView.heightAnchor.constraint(equalTo: checkmarkView.widthAnchor).isActive = true

        skipButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20.0).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20.0).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20.0).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }

    private func configureFaceRecognition() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        let sceneView = ARSCNView(frame: view.bounds)
        view.addSubview(sceneView)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.isHidden = true
        sceneView.delegate = self
    }

    @objc private func skipAction() {
        self.onSuccess?()
    }
}

extension SmileToUnlock: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        let blendShapes = faceAnchor.blendShapes
        if let left = blendShapes[.mouthSmileLeft], let right = blendShapes[.mouthSmileRight] {
            let smileParameter = min(max(CGFloat(truncating: left), CGFloat(truncating: right))/successTreshold, 1.0)
            DispatchQueue.main.async {
                self.smileView.drawSmile(parameter: smileParameter)
                if smileParameter == 1 {
                    if !self.unlocked {
                        self.unlocked = true

                        self.successSoundPlaying?()
                        UIView.animate(withDuration: 0.5, animations: {
                            self.checkmarkView.alpha = 1.0
                        }, completion: { _ in
                            //self.onSuccess?()
                        })
                    }
                }
            }
        }
    }
}
