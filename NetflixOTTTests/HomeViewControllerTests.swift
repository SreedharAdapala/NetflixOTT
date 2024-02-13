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
    var tableCell:HomeTabCell!

    override func setUpWithError() throws {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        
        homeViewController = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.loadViewIfNeeded()
        let indexPath = IndexPath(row: 0, section: 0)
        tableCell = homeViewController?.tableViewObj.cellForRow(at: indexPath) as?HomeTabCell
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
        XCTAssertNotNil(tableCell)
        XCTAssertTrue(tableCell != nil)
    }
    
//    func testCollectionviewInTableViewCellHasDataSource () {
//        let indexPath = IndexPath(row: 0, section: 0)
////        let tableCell = homeViewController?.tableViewObj.cellForRow(at: indexPath) as?HomeTabCell
//        let collectionViewCell = tableCell.collectionViewObj.cellForItem(at: indexPath)
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
    func testSetTableView() {
        homeViewController.setTableView()
        XCTAssertNotNil(homeViewController.tableViewObj.tableHeaderView)
    }
    
    func testConfigureHeaderView() {
        let expectation = self.expectation(description: "API call completed")
        
        APICalls.shared.getTrendingMovies { result in
            switch result {
            case .success(let titles):
                print("")
                XCTAssertNotNil(titles)
            case .failure(let erorr):
                XCTFail("Error: \(erorr.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        homeViewController.publicMethodToTestConfigureHeaderView()
        XCTAssertNotNil(homeViewController.randomTrendingMovie)
    }

}



