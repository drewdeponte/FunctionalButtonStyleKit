    import XCTest
    import SwiftUI
    import Functional
    @testable import FunctionalButtonStyleKit

    final class ButtonStyleKitTests: XCTestCase {
        func testForwardComposition() {
            func mediumPaddingButtonStyle<A: View>(_ configuration: ButtonStyleConfiguration, _ view: A) -> some View {
                return view.padding(12)
            }

            func roundedButtonStyle<A: View>(_ configuration: ButtonStyleConfiguration, _ view: A) -> some View {
                return view.cornerRadius(8)
            }

            func composedButtonStyle(_ configuration: ButtonStyleConfiguration, _ view: ButtonStyleConfiguration.Label) -> some View {
                return (
                    mediumPaddingButtonStyle
                    >>> roundedButtonStyle
                )(configuration, view)
            }
        }
    }
