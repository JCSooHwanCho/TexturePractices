//
//  ViewController.swift
//  Videos
//
//  Created by Joshua on 2021/02/16.
//

import AsyncDisplayKit

class ViewController: UIViewController {
    lazy var rootNode: ASDisplayNode = {
        let rootNode = ASDisplayNode()
        rootNode.frame = self.view.bounds
        rootNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return rootNode
    }()

    lazy var guitarVideoNode: ASVideoNode = {
        let guitarVideoNode = ASVideoNode()

        guitarVideoNode.asset = AVAsset(url: URL(string: "https://files.parsetfss.com/8a8a3b0c-619e-4e4d-b1d5-1b5ba9bf2b42/tfss-3045b261-7e93-4492-b7e5-5d6358376c9f-editedLiveAndDie.mov")!)
        guitarVideoNode.gravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        guitarVideoNode.backgroundColor = .lightGray
        guitarVideoNode.periodicTimeObserverTimescale = 1

        return guitarVideoNode
    }()

    lazy var nicCageVideoNode: ASVideoNode = {
        let nicCageVideoNode = ASVideoNode()
        nicCageVideoNode.delegate = self
        nicCageVideoNode.asset = AVAsset(url: URL(string:
                                            "https://files.parsetfss.com/8a8a3b0c-619e-4e4d-b1d5-1b5ba9bf2b42/tfss-753fe655-86bb-46da-89b7-aa59c60e49c0-niccage.mp4")!)
        nicCageVideoNode.gravity = AVLayerVideoGravity.resize.rawValue
        nicCageVideoNode.backgroundColor = .lightGray
        nicCageVideoNode.shouldAutorepeat = true
        nicCageVideoNode.shouldAutoplay = true
        nicCageVideoNode.muted = true

        return nicCageVideoNode
    }()

    lazy var simonVideoNode: ASVideoNode = {
        let simonVideoNode = ASVideoNode()
        simonVideoNode.asset = AVAsset(url: URL(string: "https://files.parsetfss.com/8a8a3b0c-619e-4e4d-b1d5-1b5ba9bf2b42/tfss-753fe655-86bb-46da-89b7-aa59c60e49c0-niccage.mp4")!)
        simonVideoNode.gravity = AVLayerVideoGravity.resizeAspect.rawValue
        simonVideoNode.shouldAutorepeat = true
        simonVideoNode.shouldAutoplay = true
        simonVideoNode.muted = true

        return simonVideoNode
    }()

    lazy var hlsVideoNode: ASVideoNode = {
        let hlsVideoNode = ASVideoNode()

        hlsVideoNode.delegate = self
        hlsVideoNode.gravity = AVLayerVideoGravity.resize.rawValue
        hlsVideoNode.backgroundColor = .red
        hlsVideoNode.shouldAutorepeat = true
        hlsVideoNode.shouldAutoplay = true
        hlsVideoNode.muted = true

        hlsVideoNode.url = URL(string: "https://upload.wikimedia.org/wikipedia/en/5/52/Testcard_F.jpg")!

        return hlsVideoNode
    }()

    lazy var playButton: ASButtonNode = {
        let button = ASButtonNode()

        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.setImage(UIImage(named: "playButtonSelected"), for: .highlighted)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rootNode.frame = self.view.bounds

        self.rootNode.addSubnode(self.guitarVideoNode)
        self.rootNode.addSubnode(self.nicCageVideoNode)
        self.rootNode.addSubnode(self.simonVideoNode)
        self.rootNode.addSubnode(self.hlsVideoNode)

        let mainScreenSize = UIScreen.main.bounds.size

        self.rootNode.layoutSpecBlock = { [weak self] node, costrainedSize in
            guard let self = self else { return ASLayoutSpec() }

            self.guitarVideoNode.style.preferredSize = CGSize(width: mainScreenSize.width / 2, height: mainScreenSize.height / 3.0)
            self.guitarVideoNode.style.layoutPosition = .zero

            self.nicCageVideoNode.style.preferredSize = CGSize(width: mainScreenSize.width/2, height: mainScreenSize.height / 3.0)
            self.nicCageVideoNode.style.layoutPosition = CGPoint(x: mainScreenSize.width / 2.0, y: 0)

            self.simonVideoNode.style.preferredSize = CGSize(width: mainScreenSize.width / 2, height: mainScreenSize.height / 3.0)
            self.simonVideoNode.style.layoutPosition = CGPoint(x: 0, y: mainScreenSize.height / 3.0)

            self.hlsVideoNode.style.preferredSize = CGSize(width: mainScreenSize.width / 2.0, height: mainScreenSize.height / 3.0)
            self.hlsVideoNode.style.layoutPosition = CGPoint(x: mainScreenSize.width / 2.0, y: mainScreenSize.height / 3.0)

            return ASAbsoluteLayoutSpec(children: [self.guitarVideoNode, self.nicCageVideoNode, self.simonVideoNode, self.hlsVideoNode])
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(3)) { [weak self] in
            self?.hlsVideoNode.asset = AVAsset(url: URL(string: "http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8")!)
            self?.hlsVideoNode.play()
        }

        self.view.addSubnode(self.rootNode)
    }

    @objc func didTabVideoNode(videoNode: ASVideoNode) {
        if videoNode == self.guitarVideoNode {
            switch videoNode.playerState {
            case .playing, .loading:
                videoNode.pause()
            default:
                videoNode.play()
            }
        } else {
            videoNode.player?.isMuted.toggle()
        }
    }
}

extension ViewController: ASVideoNodeDelegate {
    func videoNode(_ videoNode: ASVideoNode, willChange state: ASVideoNodePlayerState, to toState: ASVideoNodePlayerState) {

        switch toState {
        case .playing:
            print("guitarVideoNode is playing")
        case .finished:
            print("guitarVideoName")
        case .loading:
            print("guitarVideoNode is buffering")
        default:
            break
        }
    }

    func videoNode(_ videoNode: ASVideoNode, didPlayToTimeInterval timeInterval: TimeInterval) {
        print("guitarVideoNode playback time is: \(timeInterval)")
    }
}

