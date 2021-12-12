//
//  StringAdditionsTests.swift
//
//
//  Created by Guillaume Bourachot on 03/12/2019.
//
import XCTest
import GBExtensions

final class StringIndexesTests: XCTestCase {

    func testIndexOfString() {
        // Given
        let studiedString = "This is my studied string"
        let searchedTermString = " is"

        // When
        guard let indexOfSearchedTerm = studiedString.index(of: searchedTermString) else {
            XCTFail("Couldn't find the term in the studiedString")
            return
        }

        // Then
        XCTAssertNotNil(indexOfSearchedTerm)
        XCTAssertEqual(studiedString.distance(from: studiedString.startIndex, to: indexOfSearchedTerm), 4)
    }

    func testEndIndexOfString() {
        // Given
        let studiedString = "This is my studied string"
        let searchedTermString = " is"

        // When
        guard let indexOfSearchedTerm = studiedString.endIndex(of: searchedTermString) else {
            XCTFail("Couldn't find the term in the studiedString")
            return
        }

        // Then
        XCTAssertNotNil(indexOfSearchedTerm)
        XCTAssertEqual(studiedString.distance(from: studiedString.startIndex, to: indexOfSearchedTerm), 7)
    }

    func testIndexesOfString() {
        // Given
        let studiedString = "This is my studied string"
        let searchedTermString = " "

        // When
        let indexesOfSearchedTerm = studiedString.indexes(of: searchedTermString)

        // Then
        XCTAssertGreaterThan(indexesOfSearchedTerm.count, 0)
        XCTAssertEqual(indexesOfSearchedTerm.count, 4)
    }

    func testRangesOfString() {
        // Given
        let studiedString = "This is my studied string"
        let searchedTermString = " "

        // When
        let rangesOfSearchTerm = studiedString.ranges(of: searchedTermString)
        guard let firstRangeLowerBound = rangesOfSearchTerm.first?.lowerBound else {
            XCTFail("Couldn't find the term in the studiedString")
            return
        }

        // Then
        XCTAssertGreaterThan(rangesOfSearchTerm.count, 0)
        XCTAssertEqual(rangesOfSearchTerm.count, 4)
        XCTAssertEqual(studiedString.distance(from: studiedString.startIndex, to: firstRangeLowerBound), 4)
    }

    func testRangeFromStart() {
        // Given
        let studiedString = "This is my studied string"
        let searchedTermString = " is"

        // When
        guard let rangeUntilSearchTerm = try? studiedString.rangeFromStart(upTo: searchedTermString) else {
            XCTFail("Couldn't find the searchedTermString \(searchedTermString)")
            return
        }

        // Then
        XCTAssertNotEqual(rangeUntilSearchTerm.length, studiedString.count)
        XCTAssertEqual(rangeUntilSearchTerm.length, 7)
    }

    func testRangeUntilEnd() {
        // Given
        let studiedString = "This is my studied string"
        let searchedTermString = " is"

        // When
        guard let rangeUntilSearchTerm = try? studiedString.rangeUntilEnd(from: searchedTermString) else {
            XCTFail("Couldn't find the searchedTermString \(searchedTermString)")
            return
        }

        // Then
        XCTAssertNotEqual(rangeUntilSearchTerm.length, studiedString.count)
        XCTAssertEqual(rangeUntilSearchTerm.location, 7)
        XCTAssertEqual(rangeUntilSearchTerm.length, 18)
    }
    
    func testSimpleHtml() {
        // Given
        let sample = "Parmi les mots (ou les groupes de mots) soulignés, certains comportent une erreur. S\'il n\'y a aucune erreur dans la phrase, cliquez sur la réponse D.<br/>Aborder un dénivelé positif</b> de deux milles</i> mètres sans équipement, ce n\'était pas très sensé."
        
        // When
        let htmlAttributedString = sample.simpleHTMLInterpreted()
        
    }

    static var allTests = [
        ("testIndexOfString", testIndexOfString),
        ("testEndIndexOfString", testEndIndexOfString),
        ("testIndexesOfString", testIndexesOfString),
        ("testRangesOfString", testRangesOfString),
        ("testRangeFromStart", testRangeFromStart),
        ("testRangeUntilEnd", testRangeUntilEnd),
    ]
}



