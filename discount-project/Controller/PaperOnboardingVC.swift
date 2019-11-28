//
//  PaperOnboardingVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 12/06/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import paper_onboarding

class PaperOnboardingVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var onboardingView: OnboardingView!
    @IBOutlet weak var getStartedButton: UIButton!

    let localized = LocalizableEnum.AppIntro.self
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    @IBAction func getStartedWasTapped(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onBoardingComplete")
        userDefaults.synchronize()
    }
    
    
}

extension PaperOnboardingVC: PaperOnboardingDataSource{
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        //Variables
        //images
        let imageLogo = #imageLiteral(resourceName: "Bm")
        let imageStore = #imageLiteral(resourceName: "grocery")
        let imageStar = #imageLiteral(resourceName: "star-1")
        
        let iconOne = #imageLiteral(resourceName: "icons8-1_circle")
        let iconTwo = #imageLiteral(resourceName: "icons8-2_circle")
        let iconThree = #imageLiteral(resourceName: "icons8-3_circle_c")
        
        //backgroundColors
        let bacgroundColorFirst = #colorLiteral(red: 0.1529197991, green: 0.1529534459, blue: 0.1529176831, alpha: 1)
        
        //fonts
        let titleFont = UIFont(name: "AvenirNext-Medium", size: 36)!
        let descriptionFont = UIFont(name: "AvenirNext-Medium", size: 18)!
        
        return [
            OnboardingItemInfo(informationImage: imageLogo,
                               title: localized.firstPageTitle.localized,
                               description: localized.firstPageDescription.localized,
                               pageIcon: iconOne,
                               color: bacgroundColorFirst,
                               titleColor: #colorLiteral(red: 0.9744377732, green: 0.385818243, blue: 0.1830317974, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.9721019864, green: 0.8691119552, blue: 0, alpha: 1),
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: imageStore,
                               title: localized.secondPageTitle.localized,
                               description: "",
                               pageIcon: iconTwo,
                               color: bacgroundColorFirst,
                               titleColor: #colorLiteral(red: 0.9419423938, green: 0.769882977, blue: 0.09681422263, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: imageStar,
                               title: localized.thirdPageTitle.localized,
                               description: localized.thirdPageDescription.localized,
                               pageIcon: iconThree,
                               color: bacgroundColorFirst,
                               titleColor: #colorLiteral(red: 0.9411764706, green: 0.768627451, blue: 0.09803921569, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                               titleFont: titleFont,
                               descriptionFont: descriptionFont)
            ][index]
        
    }
}

extension PaperOnboardingVC: PaperOnboardingDelegate{
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1{
            if self.getStartedButton.alpha == 1{
                UIView.animate(withDuration: 0.2) {
                    self.getStartedButton.alpha = 0
                }
            }
            
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2{
            UIView.animate(withDuration: 0.6) {
                self.getStartedButton.alpha = 1
                UIView.animate(withDuration: 0.5, animations: {
                    self.getStartedButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: { (done) in
                    if done {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.getStartedButton.transform = CGAffineTransform.identity
                        })
                    }
                })
            }
        }
    }
}
