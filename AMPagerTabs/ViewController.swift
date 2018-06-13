//
//  ViewController.swift
//  AMPagerTabs
//
//  Created by Angeles Jelena Lopez Fernandez on 12/06/18.
//  Copyright © 2018 Angeles Jelena Lopez Fernandez. All rights reserved.
//

import UIKit

class ViewController: AMPagerTabsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settings.tabBackgroundColor = #colorLiteral(red: 0.9992294908, green: 0.1154508665, blue: 0.02974679507, alpha: 1)
        settings.tabButtonColor = #colorLiteral(red: 0.9992294908, green: 0.1154508665, blue: 0.02974679507, alpha: 1)
        
        tabFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        self.viewControllers = getTabs()
        
    }
    
// Instancia de ViewController
    func getTabs() -> [UIViewController]{
        let dramaViewController = self.storyboard?.instantiateViewController(withIdentifier: "dramaViewController")
        let videoViewController = self.storyboard?.instantiateViewController(withIdentifier: "videoViewController")
        let webtoonViewController = self.storyboard?.instantiateViewController(withIdentifier: "webtoonViewController")
        
// Titulo de cada pestañas
        dramaViewController?.title = "Drama"
        videoViewController?.title = "Video"
        webtoonViewController?.title = "WebToon"

        return
            [dramaViewController!,videoViewController!,webtoonViewController!]
    }

}

