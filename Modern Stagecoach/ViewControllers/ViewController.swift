//
//  ViewController.swift
//  Modern Stagecoach
//
//  Created by Tuğcan on 11.04.2023.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var goToStartBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var slides = [OnboardingPageModel]()
    
    var currentPage = 0 {
        didSet{
            pageController.currentPage = currentPage
            
            if (currentPage == 0){
                goToStartBtn.isHidden = false
                goToStartBtn.setTitle("Skip", for: .normal)
                
                nextBtn.isHidden = true
                nextBtn.setTitleColor(UIColor(red: 0/255, green: 31/255, blue: 91/255, alpha: 1), for: .normal)
                nextBtn.backgroundColor = UIColor(red: 219/255, green: 248/255, blue: 255/255, alpha: 1)
                
            } else if (currentPage == slides.count-1){
                nextBtn.isHidden = false
                nextBtn.setTitle("Get Started", for: .normal)
                nextBtn.backgroundColor  = UIColor(red: 0/255, green: 31/255, blue: 91/255, alpha: 1)
                nextBtn.setTitleColor(UIColor(red: 219/255, green: 248/255, blue: 255/255, alpha: 1), for: .normal)
                
                goToStartBtn.isHidden = false
                goToStartBtn.setTitle("⏎", for: .normal)
                
            } else {
                nextBtn.isHidden = true
                nextBtn.setTitle("Next", for: .normal)
                nextBtn.backgroundColor = UIColor(red: 219/255, green: 248/255, blue: 255/255, alpha: 0)
                nextBtn.setTitleColor(UIColor(red: 0/255, green: 31/255, blue: 91/255, alpha: 1), for: .normal)
                
                goToStartBtn.isHidden = true
                goToStartBtn.setTitle("none", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let page1 = OnboardingPageModel(title: "To Modernized Stagecoach App!", description: "We are happy to see you.", animationName: "welcome")
        let page2 = OnboardingPageModel(title: "Better than horses!", description: "Everything you wanted \n & \n Incredible horse power!", animationName: "secure")
        let page3 = OnboardingPageModel(title: "Extra Spacing!", description: "Seat spacing up to 2 meter \n \n Enjoy your wild west travel", animationName: "seats")
        let page4 = OnboardingPageModel(title: "We Go Everywhere!", description: "65000+ Routes \n & \n Over Millions Operators Worldwide", animationName: "bus_road")
        slides = [page1, page2, page3, page4]
        
        nextBtn.layer.cornerRadius = 15
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.currentPage += 1
            let indexPath = IndexPath(item: self.currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

            if self.currentPage == self.slides.count-1 {
                timer.invalidate()
            }
        }
    }
    
    
    @IBAction func nextBtnAction(_ sender: Any) {
        if(currentPage == slides.count-1){
            dismiss(animated: true, completion: nil)
        } else if(currentPage != slides.count-1){
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func goToStartBtnAction(_ sender: Any) {
        if(currentPage == 0){
            dismiss(animated: true, completion: nil)
        } else if(currentPage == slides.count-1){
            nextBtn.setTitle("Next", for: .normal)
            currentPage = 0
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCellIdentifier", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slide: slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}

