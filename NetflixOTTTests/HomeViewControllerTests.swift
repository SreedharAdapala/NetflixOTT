//
//  HomeViewControllerTests.swift
//  NetflixOTTTests
//
//  Created by Perennials on 09/02/24.
//

import XCTest
@testable import NetflixOTT

final class HomeViewControllerTests: XCTestCase {

    var homeViewController: HomeViewController?
    
    override func setUpWithError() throws {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        
        homeViewController = story.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homeViewController = nil
    }
    
    func testTableViewHasDataSource () {
        XCTAssertNotNil(homeViewController?.tableViewObj.dataSource)
    }
    
//    func testTableviewHasDelegate () {
//        XCTAssertNotNil(homeViewController?.tableViewObj.delegate)
//    }
    func testTableViewCellContent () {
        
    }
    
    func testTableviewNumberofRowsInSection () {
        let expectedRowCount = 1
        XCTAssertNotNil(homeViewController?.tableViewObj.numberOfRows(inSection: expectedRowCount))
    }
    
    func testViewDidLoad() {
        XCTAssertNotNil(homeViewController)
    }


}
