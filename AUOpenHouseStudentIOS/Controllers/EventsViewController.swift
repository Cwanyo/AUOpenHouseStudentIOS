//
//  EventsViewController.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 8/6/2561 BE.
//

import UIKit

class EventsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createSegment()
        updateView(index: 0)
    }

    func createSegment(){
        let segment: UISegmentedControl = UISegmentedControl(items: ["Upcoming", "Joined"])
        segment.sizeToFit()
        // segment.tintColor = UIColor(red:0.00, green:0.00, blue:0.25, alpha:1.00)
        segment.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segment
        
        segment.addTarget( self, action: #selector(segmentSelected(sender:)), for: UIControlEvents.valueChanged )
    }
    
    @objc func segmentSelected(sender: UISegmentedControl) {
        updateView(index: sender.selectedSegmentIndex)
    }
    
    func updateView(index: Int){
        upEventsViewController.view.isHidden = !(index == 0)
        myEventsViewController.view.isHidden = (index == 0)
    }

    // upevents view
    lazy var upEventsViewController: UpEventsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "upEventsViewController") as! UpEventsViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    // myevents view
    lazy var myEventsViewController: MyEventsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "myEventsViewController") as! MyEventsViewController
        
        self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    func addViewControllerAsChildViewController(childViewController: UIViewController){
        addChildViewController(childViewController)
        
        view.addSubview(childViewController.view)
        
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        childViewController.didMove(toParentViewController: self)
    }
    
}
