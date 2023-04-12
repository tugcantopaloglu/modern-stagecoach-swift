//
//  OnboardingCollectionViewCell.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 09.04.2023.
//

import UIKit
import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var actionButtonDidTap: (() -> Void)?
    
    func setup(slide: OnboardingPageModel){
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description
        
        let animation = LottieAnimation.named(slide.animationName)
        
        animationView.animation = animation
        animationView.loopMode = .loop
        
        if !animationView.isAnimationPlaying{ animationView.play() }
    }
}
