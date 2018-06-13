//
//  AMTabViewController.swift
//  AMPagerTabs
//
//  Created by Angeles Jelena Lopez Fernandez on 12/06/18.
//  Copyright © 2018 Angeles Jelena Lopez Fernandez. All rights reserved.
//

import UIKit

class AMPagerTabsViewController: UIViewController {

    
    
    
    private var tabScrollView: UIScrollView!
    private var containerScrollView: UIScrollView!
    
    private var tabButtons: [AMTabButton] = []
    private var line = AMLineView()
    private var lastSelectedViewIndex = 0

    
// Objeto que actua como delegado de AMPagerTabsViewControllerDelegate
    var delegate: AMPagerTabsViewControllerDelegate?
    
// Contiene la configuración y estilo de AMPagerTabsViewController
    let settings = AMSettings()

// La vista del Controlador que se mostratara en la pestaña
    var viewControllers: [UIViewController] = [] {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You can't set the viewControllers twice")
            
        }
        
        didSet {
            addTabButtons()
            moveToViewContollerAt(index: firstSelectedTabIndex)
            
        }
        
    }
    
    var firstSelectedTabIndex = 0 {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "Debe establecer el primer índice de pestañas seleccionado antes de configurar los controladores de vista")

        }
        
    }
    
// Tamaño del titulo de la pestaña
    var tabFont: UIFont = UIFont.systemFont(ofSize: 17) {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the font before set the viewcontrollers")
            
        }
        
    }
    
// Valor bolleano que indica si la pestaña deberia caber en la pantalla o deveria de alir de la misma

    var isTabButtonShouldFit = false {
        willSet {
            checkIfCanChangeValue(withErrorMessage: "You must set the isTabButtonShouldFit before set the viewcontrollers")
        }
        
    }
    
// Un valor booleano que determina si el desplazamiento está habilitado
    var isPagerScrollEnabled: Bool = true{
        didSet{
            containerScrollView.isScrollEnabled = isPagerScrollEnabled
        }
        
    }
    
// El color de la línea en la pestaña.
    var lineColor: UIColor? {
        get {
            return line.backgroundColor
        }
        set {
            line.backgroundColor = newValue
        }
    }
    
    
// MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initScrollView()
        
        updateScrollViewsFrames()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        childViewControllers.forEach { $0.beginAppearanceTransition(true, animated: animated) }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateScrollViewsFrames()
        childViewControllers.forEach { $0.endAppearanceTransition() }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        childViewControllers.forEach { $0.beginAppearanceTransition(false, animated: animated) }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        childViewControllers.forEach { $0.endAppearanceTransition() }
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let controller = self else{ return }
            controller.updateSizes()
            
        })
        
    }

    private func initScrollView() {
        
        tabScrollView = UIScrollView(frame: CGRect.zero)
        tabScrollView.backgroundColor = settings.tabBackgroundColor
        tabScrollView.bounces = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false

        containerScrollView = UIScrollView(frame: view.frame)
        containerScrollView.backgroundColor = settings.pagerBackgroundColor
        containerScrollView.delegate = self
        containerScrollView.bounces = false
        containerScrollView.scrollsToTop = false
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.isPagingEnabled = true
        containerScrollView.isScrollEnabled = isPagerScrollEnabled
        
        self.view.addSubview(containerScrollView)
        self.view.addSubview(tabScrollView)
        
    }
    
    private func addTabButtons() {
        
        let viewWidth = self.view.frame.size.width
        let viewControllerCount = CGFloat(viewControllers.count)
        // Devide the width of the view between the tabs
        var width = viewWidth / viewControllerCount
        let widthOfAllTabs = (viewControllerCount * settings.initialTabWidth)
        if !isTabButtonShouldFit && viewWidth < widthOfAllTabs {
            width = settings.initialTabWidth
            
        }
        
        for i in 0..<viewControllers.count {
            let tabButton = AMTabButton(frame: CGRect(x: width*CGFloat(i), y: 0, width: width, height: settings.tabHeight))
            let title = viewControllers[i].title
            if title == nil {
                assertionFailure("You need to set a title for the view contoller \(String(describing: viewControllers[i])) , index: \(i)")
                
            }
            
            tabButton.setTitle(title , for: .normal)
            tabButton.backgroundColor = settings.tabButtonColor
            tabButton.setTitleColor(settings.tabButtonTitleColor, for: .normal)
            tabButton.titleLabel?.font = tabFont
            tabButton.index = i
            tabButton.addTarget(self, action: #selector(tabClicked(sender:)), for: .touchUpInside)
            tabScrollView.addSubview(tabButton)
            tabButtons.append(tabButton)
            
        }
        
        line.frame = tabButtons.first!.frame
        line.backgroundColor = lineColor ?? UIColor.white
        tabScrollView.addSubview(line)
    }
    
// MARK: Control de pestañas

    @objc private func tabClicked(sender: AMTabButton){
        
        moveToViewContollerAt(index: sender.index!)
        
    }
    
    //Mueve el controlador de vusta al indice pasado
    func moveToViewContollerAt(index: Int) {
        
        lastSelectedViewIndex = index
        
        let barButton = tabButtons[index]
        animateLineTo(frame: barButton.frame)
        
        let contoller = viewControllers[index]
        if contoller.view?.superview == nil {
            addChildViewController(contoller)
            containerScrollView.addSubview(contoller.view)
            contoller.didMove(toParentViewController: self)
            updateSizes()
            
        }
        
        changeShowingControllerTo(index: index)
        
        delegate?.tabDidChangeTo(index)
        
    }
    
    private func changeShowingControllerTo(index: Int) {
        containerScrollView.setContentOffset(CGPoint(x: self.view.frame.size.width*(CGFloat(index)), y: 0), animated: true)
        
    }
    
// MARK: Animación
    private func animateLineTo(frame: CGRect) {
        
        UIView.animate(withDuration: 0.5) {
            self.line.frame = frame
            self.line.draw(frame)
            
        }
        
    }
    
// MARK: onfiguración del tamaño

    private func updateScrollViewsFrames() {

        tabScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: settings.tabHeight)
        containerScrollView.frame = CGRect(x: 0, y: settings.tabHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - settings.tabHeight)
        
    }
    
    private func updateSizes() {
        
        updateScrollViewsFrames()
        
        let width = self.view.frame.size.width
        let viewWidth = self.view.frame.size.width
        let viewControllerCount = CGFloat(viewControllers.count)
        var tabWidth = viewWidth / viewControllerCount
        if !isTabButtonShouldFit && viewWidth < (viewControllerCount * settings.initialTabWidth) {
            tabWidth = settings.initialTabWidth
            
        }
        
        for i in 0..<viewControllers.count {
            let view = viewControllers[i].view
            let tabButton = tabButtons[i]
            view?.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: containerScrollView.frame.size.height)
            tabButton.frame = CGRect(x: tabWidth*CGFloat(i), y: 0, width: tabWidth, height: settings.tabHeight)
            
        }
        
        containerScrollView.contentSize = CGSize(width: width*viewControllerCount, height: containerScrollView.frame.size.height)
        tabScrollView.contentSize = CGSize(width: tabWidth*viewControllerCount, height: settings.tabHeight)
        
        changeShowingControllerTo(index: lastSelectedViewIndex)
        
        animateLineTo(frame: tabButtons[lastSelectedViewIndex].frame)
        
    }
    
    private func checkIfCanChangeValue(withErrorMessage message:String) {
        
        if viewControllers.count != 0 {
            assertionFailure(message)
            
        }
        
    }
    
}

// MARK: UIScrollViewDelegate
extension AMPagerTabsViewController:UIScrollViewDelegate {
    
    var currentPage: Int {
        
        return Int((containerScrollView.contentOffset.x + (0.5*containerScrollView.frame.size.width))/containerScrollView.frame.width)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate == false {
            moveToViewContollerAt(index: currentPage)
            
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        moveToViewContollerAt(index: currentPage)
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
    
}

class AMSettings{
    
    var tabBackgroundColor = #colorLiteral(red: 0.9996430838, green: 0.1718967221, blue: 0.1465948802, alpha: 1)
    var tabButtonColor = #colorLiteral(red: 0.9996430838, green: 0.1718967221, blue: 0.1465948802, alpha: 1)
    var tabButtonTitleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var pagerBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var initialTabWidth:CGFloat = 100
    var tabHeight:CGFloat = 60
    
}

// MARK: AMTabViewControllerDelegate
// El delegate del controlador deve adoptar el protocolo
protocol AMPagerTabsViewControllerDelegate {
    func tabDidChangeTo(_ index:Int);
    
}

