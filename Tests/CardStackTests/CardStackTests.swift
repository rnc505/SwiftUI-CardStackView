import SnapshotTesting
import SwiftUI
import XCTest

@testable import CardStack

final class CardStackTests: XCTestCase {

  private func assertCardStack(
    with data: [Int],
    configuration: CardStackConfiguration? = nil,
    testName: String = #function
  ) {
    guard
      !ProcessInfo.processInfo.environment.keys
        .contains("GITHUB_WORKFLOW")
    else { return }

    let view = CardStack(
      direction: LeftRight.direction,
      data: data,
      onSwipe: { _, _ in }
    ) { index, _, _ in
      Text(String(index))
        .frame(width: 300, height: 300, alignment: .center)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [Color.red, Color.blue, Color.red]),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .foregroundColor(Color.white)
    }
    .frame(width: 500, height: 500, alignment: .center)

    if let configuration = configuration {
      assertSnapshot(
        matching: view.environment(\.cardStackConfiguration, configuration),
        as: .image(size: CGSize(width: 500, height: 500)),
        testName: "\(Self.namePrefix).\(testName)"
      )
    } else {
      assertSnapshot(
        matching: view,
        as: .image(size: CGSize(width: 500, height: 500)),
        testName: "\(Self.namePrefix).\(testName)"
      )
    }
  }

  func testOneCard() {
    assertCardStack(with: [1])
  }

  func testTwoCards() {
    assertCardStack(with: [1, 2])
  }

  func testThousandCards() {
    assertCardStack(with: Array(1...1000))
  }

  func testCustomConfiguration() {
    assertCardStack(
      with: Array(1...7),
      configuration: CardStackConfiguration(
        maxVisibleCards: 7,
        cardOffset: 20,
        cardScale: 0.05
      )
    )
  }

  func testNext() {
    let viewModel = CardStackViewModel(data: [1, 2, 3])
    let cardStack = CardStack(
      direction: LeftRight.direction(degrees:),
      viewModel: viewModel,
      onSwipe: { _, _ in }
    ) { index, _, _ in
      Text(String(index))
        .frame(width: 300, height: 300, alignment: .center)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [Color.red, Color.blue, Color.red]),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .foregroundColor(Color.white)
    }
    .frame(width: 500, height: 500, alignment: .center)

    assertSnapshot(
      matching: cardStack,
      as: .image(size: CGSize(width: 500, height: 500)),
      testName: "\(Self.namePrefix).testNext"
    )

    viewModel.next()

    assertSnapshot(
      matching: cardStack,
      as: .image(size: CGSize(width: 500, height: 500)),
      testName: "\(Self.namePrefix).testNext"
    )

  }

  static var allTests = [
    ("testOneCard", testOneCard),
    ("testTwoCards", testTwoCards),
    ("testThousandCards", testThousandCards),
    ("testCustomConfiguration", testCustomConfiguration),
    ("testNext", testNext),
  ]
}

extension CardStackTests {

  #if os(iOS)
    private static var namePrefix: String { "iOS" }
  #elseif os(macOS)
    private static var namePrefix: String { "macOS" }
  #endif

}
