//
//  HomeViewControllerTests.swift
//  NetflixOTTTests
//
//  Created by Perennials on 09/02/24.
//

import XCTest
@testable import NetflixOTT

final class HomeViewControllerTests: XCTestCase {

    var homeViewController: HomeViewController!
    
    override func setUpWithError() throws {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        
        homeViewController = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homeViewController = nil
    }
    
    func testTableViewHasDataSource () {
        XCTAssertNotNil(homeViewController?.tableViewObj.dataSource)
    }
    
    func testTableviewHasDelegate () {
        XCTAssertNotNil(homeViewController?.tableViewObj.delegate)
    }
    
    func testTableviewNumberofRowsInSection () {
        //number of rows should be one
        let expectedRowCount = 1
        XCTAssertNotNil(homeViewController?.tableViewObj.numberOfRows(inSection: expectedRowCount))
    }
    
    func testCellForRownReturnsExpectedCell () {
        // get the cell for the first row
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = homeViewController.tableView(homeViewController.tableViewObj, cellForRowAt: indexPath) as? UITableViewCell

        XCTAssertNotNil(cell)
        XCTAssertTrue(cell != nil)
    }
    
//    func testCollectionviewInTableViewCellHasDataSource () {
//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell = homeViewController?.tableViewObj.cellForRow(at: indexPath) as?HomeTabCell
//        let collectionViewCell = cell?.collectionViewObj.cellForItem(at: indexPath)
//        XCTAssertNotNil(collectionViewCell)
//        XCTAssertNotEqual(collectionViewCell?.backgroundColor, .blue)
//    }
    
    func testCollectionviewNumberofItems () {
        //number of rows should be one
        let indexPath = IndexPath(row: 0, section: 0)
        let tableCell = homeViewController?.tableViewObj.cellForRow(at: indexPath) as?HomeTabCell
        
//        let collectionViewCell = tableCell?.collectionViewObj.cellForItem(at: indexPath)
        XCTAssertEqual(tableCell?.collectionViewObj.numberOfItems(inSection: 0), tableCell?.titles.count)
    }
    
    func testViewDidLoad() {
        XCTAssertNotNil(homeViewController)
    }


}
